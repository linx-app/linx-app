import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/linx_loading_spinner.dart';
import 'package:linx/features/app/chat/presentation/chat_screen_controller.dart';
import 'package:linx/features/app/chat/ui/model/chat_screen_state.dart';
import 'package:linx/features/app/chat/ui/widgets/chat_app_bar.dart';
import 'package:linx/features/app/chat/ui/widgets/chat_bubble.dart';
import 'package:linx/features/app/chat/ui/widgets/message_text_field.dart';
import 'package:linx/features/user/domain/model/user_type.dart';

class ChatScreen extends ConsumerWidget {
  final TextEditingController _messageController = TextEditingController();

  void onDispose() {
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(chatScreenControllerProvider);

    return BaseScaffold(
      body: Column(
        children: [
          _buildAppBar(context, ref, uiState,),
          Expanded(child: _buildBody(uiState)),
          MessageTextField(
            controller: _messageController,
            onSendPressed: () => _onSendMessagePressed(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, WidgetRef ref,
      ChatScreenUiState state,) {
    var title = "";

    if (state.chat != null) {
      title = state.isCurrentUserClub
          ? state.chat!.business.displayName
          : state.chat!.club.displayName;
    }

    return ChatAppBar(title: title, onBackPressed: () => _onBackPressed(ref));
  }

  Widget _buildBody(ChatScreenUiState state) {
    if (state.state == ChatScreenState.loaded) {
      return _buildChatList(state);
    } else {
      return LinxLoadingSpinner();
    }
  }

  Widget _buildChatList(ChatScreenUiState state) {
    final bubbles = state.messages.map(
          (e) =>
          ChatBubble(
            message: e,
            currentUserType:
            state.isCurrentUserClub ? UserType.club : UserType.business,
          ),
    );

    return SingleChildScrollView(
      reverse: true,
      child: Column(
        children: [...bubbles],
      ),
    );
  }

  void _onSendMessagePressed(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(chatScreenControllerProvider.notifier);
    notifier.onSendMessagePressed(_messageController.text);
    _messageController.clear();
  }

  void _onBackPressed(WidgetRef ref) {
    final notifier = ref.read(chatScreenControllerProvider.notifier);
    notifier.onChatViewed();
  }
}
