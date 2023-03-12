import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/buttons/linx_back_button.dart';
import 'package:linx/common/buttons/linx_icon_button.dart';
import 'package:linx/common/empty.dart';
import 'package:linx/common/linx_loading_spinner.dart';
import 'package:linx/common/linx_text_field.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/chat/domain/model/chat_user_suggestion.dart';
import 'package:linx/features/app/chat/presentation/chat_creation_screen_controller.dart';
import 'package:linx/features/app/chat/ui/model/chat_creation_screen_state.dart';
import 'package:linx/features/app/chat/ui/widgets/chat_address_bar.dart';
import 'package:linx/features/app/chat/ui/widgets/chat_user_suggestion_item.dart';
import 'package:linx/utils/ui_extensions.dart';

class ChatCreationScreen extends ConsumerWidget {
  final Text _title = const Text(
    "New message",
    style: TextStyle(
      color: LinxColors.black,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  );

  final _addressController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(chatCreationScreenControllerProvider);

    return BaseScaffold(
        body: Column(
      children: [
        _buildAppBar(context),
        _buildAddressBar(context, ref),
        Expanded(child: _buildBody(ref, uiState)),
        _buildMessageField(context, ref),
      ],
    ));
  }

  Widget _buildAppBar(BuildContext context) {
    return SizedBox(
      width: context.width(),
      height: context.height() * 0.1,
      child: Material(
        elevation: 0,
        child: Stack(
          children: [
            _buildBackButton(context),
            Container(
              padding: const EdgeInsets.only(bottom: 12),
              alignment: Alignment.bottomCenter,
              child: _title,
            ),
          ],
        ),
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
      case ChatCreationScreenState.selected:
        return Empty(); // TODO: Replace with suggestion box
    }
  }

  Widget _buildChatUserSuggestionList(WidgetRef ref, List<ChatUserSuggestion> suggestions) {
    final items = suggestions.map(
      (e) => ChatUserSuggestionItem(
        name: e.name,
        onPressed: () => _onSuggestionPressed(ref, e),
      ),
    );
    return Column(children: [...items]);
  }

  Widget _buildMessageField(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: LinxTextField(
        label: "Type a message...",
        controller: _messageController,
        suffixIcon: LinxIconButton(
          icon: Image.asset("assets/send_message.png", scale: 4),
          onPressed: () => _onSendMessagePressed(context, ref),
        ),
        minLines: 1,
        maxLines: 3,
      ),
    );
  }

  Container _buildBackButton(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      width: context.width() / 2,
      child: LinxBackButton(onPressed: () => _onBackPressed(context)),
    );
  }

  void _onBackPressed(BuildContext context) {
    Navigator.maybePop(context);
  }

  void _onSendMessagePressed(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(chatCreationScreenControllerProvider.notifier);
    final success = await notifier.onMessageSendPressed(_messageController.text);

    if (success) {
      Navigator.of(context).pop();
      // Navigator.of(context).push()
    }
  }

  void _onSuggestionPressed(WidgetRef ref, ChatUserSuggestion selected) {
    final notifier = ref.read(chatCreationScreenControllerProvider.notifier);
    _addressController.text = selected.name;
    notifier.onSuggestionPressed(selected);
  }
}
