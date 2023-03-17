import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/linx_loading_spinner.dart';
import 'package:linx/features/app/chat/domain/model/chat_user_suggestion.dart';
import 'package:linx/features/app/chat/presentation/chat_creation_screen_controller.dart';
import 'package:linx/features/app/chat/ui/chat_screen.dart';
import 'package:linx/features/app/chat/ui/model/chat_creation_screen_state.dart';
import 'package:linx/features/app/chat/ui/widgets/chat_address_bar.dart';
import 'package:linx/features/app/chat/ui/widgets/chat_app_bar.dart';
import 'package:linx/features/app/chat/ui/widgets/chat_bubble.dart';
import 'package:linx/features/app/chat/ui/widgets/chat_user_suggestion_item.dart';
import 'package:linx/features/app/chat/ui/widgets/message_suggestion.dart';
import 'package:linx/features/app/chat/ui/widgets/message_text_field.dart';
import 'package:linx/features/user/domain/model/user_type.dart';

class ChatCreationScreen extends ConsumerWidget {
  final _addressController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(chatCreationScreenControllerProvider);

    return BaseScaffold(
      body: Column(
        children: [
          const ChatAppBar(title: "New message"),
          _buildAddressBar(context, ref),
          Expanded(child: _buildBody(ref, uiState)),
          MessageTextField(
            controller: _messageController,
            onSendPressed: () => _onSendMessagePressed(context, ref),
          )
        ],
      ),
    );
  }

  Widget _buildAddressBar(BuildContext context, WidgetRef ref) {
    _addressController.addListener(() {
      final notifier = ref.read(chatCreationScreenControllerProvider.notifier);
      notifier.searchForSuggestions(_addressController.text);
    });
    return ChatAddressBar(controller: _addressController);
  }

  Widget _buildBody(WidgetRef ref, ChatCreationScreenUiState state) {
    switch (state.state) {
      case ChatCreationScreenState.loading:
        return LinxLoadingSpinner();
      case ChatCreationScreenState.list:
        return _buildChatUserSuggestionList(ref, state.suggestions);
      case ChatCreationScreenState.new_chat:
        return _buildMessageSuggestion(state);
      case ChatCreationScreenState.existing_chat:
        return _buildMessageList(state);
    }
  }

  Widget _buildChatUserSuggestionList(
      WidgetRef ref, List<ChatUserSuggestion> suggestions) {
    final items = suggestions.map(
      (e) => ChatUserSuggestionItem(
        name: e.name,
        onPressed: () => _onSuggestionPressed(ref, e),
      ),
    );
    return Column(children: [...items]);
  }

  Widget _buildMessageSuggestion(ChatCreationScreenUiState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: MessageSuggestion(isCurrentClub: state.isCurrentClub),
    );
  }

  Widget _buildMessageList(ChatCreationScreenUiState state) {
    final bubbles = state.messages.map((e) {
      return ChatBubble(
        message: e,
        currentUserType:
            state.isCurrentClub ? UserType.club : UserType.business,
      );
    });

    return SingleChildScrollView(
      reverse: true,
      child: Column(
        children: [...bubbles],
      ),
    );
  }

  void _onSendMessagePressed(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(chatCreationScreenControllerProvider.notifier);
    final success =
        await notifier.onMessageSendPressed(_messageController.text);

    if (success) {
      final route = MaterialPageRoute(builder: (_) => ChatScreen());
      Navigator.of(context).pop();
      Navigator.of(context).push(route);
    }
  }

  void _onSuggestionPressed(WidgetRef ref, ChatUserSuggestion selected) {
    final notifier = ref.read(chatCreationScreenControllerProvider.notifier);
    _addressController.text = selected.name;
    notifier.onSuggestionPressed(selected);
  }
}
