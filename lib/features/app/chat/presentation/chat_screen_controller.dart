import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/chat/domain/fetch_chat_service.dart';
import 'package:linx/features/app/chat/domain/model/chat.dart';
import 'package:linx/features/app/chat/domain/model/message.dart';
import 'package:linx/features/app/chat/domain/send_message_service.dart';
import 'package:linx/features/app/chat/domain/subscribe_to_chat_service.dart';
import 'package:linx/features/app/chat/domain/view_chat_service.dart';
import 'package:linx/features/app/chat/ui/model/chat_screen_state.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/model/user_info.dart';
import 'package:linx/features/user/domain/subscribe_to_current_user_service.dart';

final chatScreenControllerProvider =
    StateNotifierProvider.autoDispose<ChatScreenController, ChatScreenUiState>(
        (ref) {
  return ChatScreenController(
    ref.watch(selectedChatIdProvider),
    ref.read(FetchChatService.provider),
    ref.read(SubscribeToChatService.provider),
    ref.read(SendMessageService.provider),
    ref.read(SubscribeToCurrentUserService.provider),
    ref.read(ViewChatService.provider),
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
  final FetchChatService _fetchChatService;
  final SubscribeToChatService _subscribeToChatService;
  final SendMessageService _sendMessageService;
  final SubscribeToCurrentUserService _subscribeToCurrentUserService;
  final ViewChatService _viewChatService;

  late LinxUser _currentUser;
  late Chat _chat;

  ChatScreenController(
    this._chatId,
    this._fetchChatService,
    this._subscribeToChatService,
    this._sendMessageService,
    this._subscribeToCurrentUserService,
    this._viewChatService,
  ) : super(ChatScreenUiState()) {
    _initialize();
  }

  void _initialize() async {
    if (_chatId == null) return;
    _subscribeToCurrentUserService.execute().listen((event) async {
      _currentUser = event;
      _chat = await _fetchChatService.execute(_chatId!, _currentUser);

      _subscribeToChatService.execute(_chatId!).listen((event) {
        var messages = [...state.messages];
        messages.addAll(event);
        messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        _setState(
          messages: messages,
          newState: ChatScreenState.loaded,
        );
      });
    });
  }

  void onSendMessagePressed(String message) {
    if (message.isNotEmpty) {
      final isClub = _currentUser.info.isClub();
      final senderId = isClub ? _chat.club.uid : _chat.business.uid;
      final receiverId = isClub ? _chat.business.uid : _chat.club.uid;
      _sendMessageService.execute(isClub, senderId, receiverId, message);
    }
  }

  void _setState({
    List<Message>? messages,
    ChatScreenState? newState,
  }) {
    state = ChatScreenUiState(
      chat: _chat,
      messages: messages ?? state.messages,
      state: newState ?? state.state,
      isCurrentUserClub: _currentUser.info.isClub(),
    );
  }

  void onChatViewed() async {
    await _viewChatService.execute(_chat.chatId);
  }
}

class ChatScreenUiState {
  final Chat? chat;
  final List<Message> messages;
  final ChatScreenState state;
  final bool isCurrentUserClub;

  ChatScreenUiState({
    this.chat,
    this.messages = const [],
    this.isCurrentUserClub = false,
    this.state = ChatScreenState.loading,
  });
}
