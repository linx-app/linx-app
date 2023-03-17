import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/chat/domain/model/chat.dart';
import 'package:linx/features/app/chat/domain/subscribe_to_all_chats_service.dart';
import 'package:linx/features/app/chat/presentation/chat_screen_controller.dart';
import 'package:linx/features/app/chat/ui/model/chat_list_screen_state.dart';
import 'package:linx/features/user/domain/subscribe_to_current_user_service.dart';

final chatListScreenControllerProvider = StateNotifierProvider.autoDispose<
    ChatListScreenController, ChatListScreenUiState>(
  (ref) => ChatListScreenController(
    ref.read(SubscribeToAllChatsService.provider),
    ref.read(selectedChatIdUpdater),
    ref.read(SubscribeToCurrentUserService.provider),
  ),
);

class ChatListScreenController extends StateNotifier<ChatListScreenUiState> {
  final SubscribeToAllChatsService _fetchAllChatsService;
  final Function(String?) _updateSelectedChatId;
  final SubscribeToCurrentUserService _subscribeToCurrentUserService;

  ChatListScreenController(
    this._fetchAllChatsService,
    this._updateSelectedChatId,
    this._subscribeToCurrentUserService,
  ) : super(ChatListScreenUiState()) {
    _initialize();
  }

  void _initialize() {
    _subscribeToCurrentUserService.execute().listen((event) {
      _fetchAllChatsService.execute(event).listen((chats) {
        state = ChatListScreenUiState(
          state: ChatListScreenState.results,
          chats: chats,
        );
      });
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
