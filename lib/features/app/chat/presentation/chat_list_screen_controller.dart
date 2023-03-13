import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/chat/domain/subscribe_to_all_chats_service.dart';
import 'package:linx/features/app/chat/domain/model/chat.dart';
import 'package:linx/features/app/chat/presentation/chat_screen_controller.dart';
import 'package:linx/features/app/chat/ui/model/chat_list_screen_state.dart';
import 'package:linx/features/app/core/presentation/app_bottom_nav_screen_controller.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';

final chatListScreenControllerProvider = StateNotifierProvider.autoDispose<
    ChatListScreenController, ChatListScreenUiState>(
  (ref) => ChatListScreenController(
    ref.watch(currentUserProvider),
    ref.read(SubscribeToAllChatsService.provider),
    ref.read(selectedChatIdUpdater),
  ),
);

class ChatListScreenController extends StateNotifier<ChatListScreenUiState> {
  final LinxUser? _currentUser;
  final SubscribeToAllChatsService _fetchAllChatsService;
  final Function(String?) _updateSelectedChatId;

  ChatListScreenController(
    this._currentUser,
    this._fetchAllChatsService,
    this._updateSelectedChatId,
  ) : super(ChatListScreenUiState()) {
    _initialize();
  }

  void _initialize() {
    if (_currentUser == null) return;
    _fetchAllChatsService.execute(_currentUser!).listen((chats) {
      state = ChatListScreenUiState(
        state: ChatListScreenState.results,
        chats: chats,
      );
    });
  }

  void onChatSelected(String chatId) {
    _updateSelectedChatId.call(chatId);
  }
}

class ChatListScreenUiState {
  final ChatListScreenState state;
  final List<Chat> chats;

  ChatListScreenUiState({
    this.state = ChatListScreenState.loading,
    this.chats = const [],
  });
}
