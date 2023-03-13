import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/chat/data/chat_repository.dart';
import 'package:linx/features/app/chat/domain/model/chat_user_suggestion.dart';
import 'package:linx/features/app/match/data/match_repository.dart';
import 'package:linx/features/user/data/user_repository.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/model/user_info.dart';

class FetchChatUserSuggestionsService {
  static final provider = Provider(
    (ref) => FetchChatUserSuggestionsService(
      ref.read(MatchRepository.provider),
      ref.read(ChatRepository.provider),
      ref.read(UserRepository.provider),
    ),
  );

  final MatchRepository _matchRepository;
  final ChatRepository _chatRepository;
  final UserRepository _userRepository;

  FetchChatUserSuggestionsService(
    this._matchRepository,
    this._chatRepository,
    this._userRepository,
  );

  Future<List<ChatUserSuggestion>> execute(LinxUser currentUser) async {
    final isClub = currentUser.info.isClub();
    final uid = currentUser.info.uid;

    final allMatches = await _matchRepository.fetchMatches(currentUser.info);
    final matchUserIds =
        allMatches.map((e) => isClub ? e.businessId : e.clubId).toList();
    final allChats = await _chatRepository.fetchAllChats(isClub, uid);
    final chatUserIds =
        allChats.map((e) => isClub ? e.businessId : e.clubId).toList();
    matchUserIds.removeWhere((element) => chatUserIds.contains(element));

    final names = <ChatUserSuggestion>[];

    for (final uid in matchUserIds) {
      final user = await _userRepository.fetchUserProfile(uid);
      names.add(ChatUserSuggestion(userId: uid, name: user.displayName));
    }

    return names;
  }
}
