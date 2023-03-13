import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/chat/domain/fetch_chat_service.dart';
import 'package:linx/features/app/chat/domain/model/chat.dart';
import 'package:linx/features/app/chat/domain/model/message.dart';
import 'package:linx/features/app/chat/domain/send_message_service.dart';
import 'package:linx/features/app/chat/domain/subscribe_to_chat_service.dart';
import 'package:linx/features/app/chat/ui/model/chat_screen_state.dart';
import 'package:linx/features/app/core/presentation/app_bottom_nav_screen_controller.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/model/user_info.dart';

final chatScreenControllerProvider =
    StateNotifierProvider.autoDispose<ChatScreenController, ChatScreenUiState>(
        (ref) {
  return ChatScreenController(
    ref.watch(selectedChatIdProvider),
    ref.watch(currentUserProvider),
    ref.read(FetchChatService.provider),
    ref.read(SubscribeToChatService.provider),
    ref.read(SendMessageService.provider),
  );
});

final selectedChatIdProvider = StateProvider<String?>((ref) => null);

final selectedChatIdUpdater = Provider<Function(String?)>((ref) {
  return ((chatId) {
    ref.read(selectedChatIdProvider.notifier).state = chatId;
  });
});

class ChatScreenController extends StateNotifier<ChatScreenUiState> {
  final String? _chatId;
  final LinxUser? _currentUser;
  final FetchChatService _fetchChatService;
  final SubscribeToChatService _subscribeToChatService;
  final SendMessageService _sendMessageService;

  late Chat _chat;

  ChatScreenController(
    this._chatId,
    this._currentUser,
    this._fetchChatService,
    this._subscribeToChatService,
    this._sendMessageService,
  ) : super(ChatScreenUiState()) {
    _initialize();
  }

  void _initialize() async {
    if (_chatId == null || _currentUser == null) return;
    _chat = await _fetchChatService.execute(_chatId!, _currentUser!);
    state = ChatScreenUiState(chat: _chat);
    _subscribeToChatService.execute(_chatId!).listen((event) {
      var messages = [...state.messages];
      messages.addAll(event);
      messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      state = ChatScreenUiState(
        chat: state.chat,
        messages: messages,
        currentUser: _currentUser!,
        state: ChatScreenState.loaded,
      );
    });
  }

  void onSendMessagePressed(String message) {
    if (message.isNotEmpty) {
      final isClub = _currentUser!.info.isClub();
      final senderId = isClub ? _chat.club.uid : _chat.business.uid;
      final receiverId = isClub ? _chat.business.uid : _chat.club.uid;
      _sendMessageService.execute(isClub, senderId, receiverId, message);
    }
  }
}

class ChatScreenUiState {
  final Chat? chat;
  final List<Message> messages;
  final ChatScreenState state;
  final LinxUser? currentUser;

  ChatScreenUiState({
    this.chat,
    this.messages = const [],
    this.currentUser,
    this.state = ChatScreenState.loading,
  });
}
