import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/chat/domain/fetch_chat_user_suggestions_service.dart';
import 'package:linx/features/app/chat/domain/model/chat_user_suggestion.dart';
import 'package:linx/features/app/chat/domain/send_message_service.dart';
import 'package:linx/features/app/chat/presentation/chat_screen_controller.dart';
import 'package:linx/features/app/chat/ui/model/chat_creation_screen_state.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/model/user_info.dart';
import 'package:linx/features/user/domain/subscribe_to_current_user_service.dart';

final chatCreationScreenControllerProvider = StateNotifierProvider.autoDispose<
    ChatCreationScreenController, ChatCreationScreenUiState>(
  (ref) => ChatCreationScreenController(
    ref.read(FetchChatUserSuggestionsService.provider),
    ref.read(SendMessageService.provider),
    ref.read(selectedChatIdUpdater),
    ref.read(SubscribeToCurrentUserService.provider),
  ),
);

class ChatCreationScreenController
    extends StateNotifier<ChatCreationScreenUiState> {
  final FetchChatUserSuggestionsService _fetchChatUserSuggestionsService;
  final SendMessageService _sendMessageService;
  final Function(String?) _updateSelectedChatId;
  final SubscribeToCurrentUserService _subscribeToCurrentUserService;

  late LinxUser _currentUser;
  late List<ChatUserSuggestion> _fullSuggestionList;
  late ChatUserSuggestion? _selectedUser;

  ChatCreationScreenController(
    this._fetchChatUserSuggestionsService,
    this._sendMessageService,
    this._updateSelectedChatId,
    this._subscribeToCurrentUserService,
  ) : super(ChatCreationScreenUiState()) {
    _initialize();
  }

  void _initialize() async {
    _fullSuggestionList =
        await _fetchChatUserSuggestionsService.execute(_currentUser);
    _selectedUser = null;

    _subscribeToCurrentUserService.execute().listen((event) {
      _currentUser = event;
    });

    state = ChatCreationScreenUiState(
      state: ChatCreationScreenState.list,
      suggestions: _fullSuggestionList,
    );
  }

  void searchForSuggestions(String search) {
    _selectedUser = null;
    final filtered = _fullSuggestionList.where(
        (element) => element.name.toLowerCase().contains(search.toLowerCase()));
    state = ChatCreationScreenUiState(
      state: ChatCreationScreenState.list,
      suggestions: filtered.toList(),
    );
  }

  Future<bool> onMessageSendPressed(String message) async {
    if (_selectedUser != null) {
      final chatId = await _sendMessageService.execute(
        _currentUser.info.isClub(),
        _currentUser.info.uid,
        _selectedUser!.userId,
        message,
      );
      _updateSelectedChatId.call(chatId);
      return true;
    }
    return false;
  }

  void onSuggestionPressed(ChatUserSuggestion selected) {
    _selectedUser = selected;
    state = ChatCreationScreenUiState(
      state: ChatCreationScreenState.selected,
    );
  }
}

class ChatCreationScreenUiState {
  final ChatCreationScreenState state;
  final List<ChatUserSuggestion> suggestions;

  ChatCreationScreenUiState({
    this.state = ChatCreationScreenState.loading,
    this.suggestions = const [],
  });
}
