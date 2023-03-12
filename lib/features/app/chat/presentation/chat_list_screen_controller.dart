import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/chat/domain/fetch_all_chats_service.dart';
import 'package:linx/features/app/chat/domain/model/chat.dart';
import 'package:linx/features/app/chat/ui/model/chat_list_screen_state.dart';
import 'package:linx/features/app/core/presentation/app_bottom_nav_screen_controller.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';

final chatListScreenControllerProvider = StateNotifierProvider.autoDispose<
    ChatListScreenController, ChatListScreenUiState>(
  (ref) => ChatListScreenController(
    ref.watch(currentUserProvider),
    ref.read(FetchAllChatsService.provider),
  ),
);

class ChatListScreenController extends StateNotifier<ChatListScreenUiState> {
  final LinxUser? _currentUser;
  final FetchAllChatsService _fetchAllChatsService;

  ChatListScreenController(
    this._currentUser,
    this._fetchAllChatsService,
  ) : super(ChatListScreenUiState()) {
    _initialize();
  }

  void _initialize() async {
    if (_currentUser == null) return;
    final chats = await _fetchAllChatsService.execute(_currentUser!);
    state = ChatListScreenUiState(
      state: ChatListScreenState.results,
      chats: chats,
    );
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
