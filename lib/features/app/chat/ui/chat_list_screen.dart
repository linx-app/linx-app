import 'package:flutter/material.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/empty.dart';
import 'package:linx/common/linx_loading_spinner.dart';
import 'package:linx/features/app/chat/presentation/chat_list_screen_controller.dart';
import 'package:linx/features/app/chat/ui/chat_creation_screen.dart';
import 'package:linx/features/app/chat/ui/model/chat_item_data.dart';
import 'package:linx/features/app/chat/ui/model/chat_list_screen_state.dart';
import 'package:linx/features/app/chat/ui/widgets/chat_item.dart';
import 'package:linx/features/app/core/ui/search_bar.dart';
import 'package:linx/features/app/core/ui/widgets/app_title_bar.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/utils/ui_extensions.dart';

class ChatListScreen extends StatelessWidget {
  final LinxUser _currentUser;
  final ChatListScreenUiState _state;
  final ChatListScreenController _controller;

  final TextEditingController _searchController = TextEditingController();

  ChatListScreen(this._currentUser, this._state, this._controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: context.height() * 0.1),
            AppTitleBar(
              title: "Messages",
              icon: Image.asset("create_message.png", height: 24, width: 24),
              onIconPressed: () => _onCreateChatPressed(context),
            ),
            SearchBar(
              controller: _searchController,
              label: "Search",
              onFocusChanged: _onSearchFocusChanged,
            ),
            _buildBody()
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_state.state) {
      case ChatListScreenState.loading:
        return LinxLoadingSpinner();
      case ChatListScreenState.results:
        return _buildChatList();
      case ChatListScreenState.searching:
        return Empty();
    }
  }

  Widget _buildChatList() {
    final data = _state.chats
        .map((e) => ChatItemData.fromChat(_currentUser.info.type, e));

    final items = data.map(
          (e) =>
          ChatItem(
            data: e,
            onPressed: () => _onChatPressed(e.chatId),
          ),
    );

    return Column(children: [...items]);
  }

  void _onChatPressed(String chatId) {}

  void _onCreateChatPressed(BuildContext context) {
    final route = MaterialPageRoute(builder: (_) {
      return ChatCreationScreen();
    });
    Navigator.of(context).push(route);
  }

  void _onSearchFocusChanged(bool hasFocus) {}
}
