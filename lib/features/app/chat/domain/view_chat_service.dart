import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/user/data/session_repository.dart';
import 'package:linx/features/user/data/user_repository.dart';

class ViewChatService {
  static final provider = Provider((ref) => ViewChatService(
    ref.read(SessionRepository.provider),
    ref.read(UserRepository.provider),
  ));

  final SessionRepository _sessionRepository;
  final UserRepository _userRepository;

  ViewChatService(this._sessionRepository, this._userRepository);

  Future<void> execute(String chatId) async {
    final userId = _sessionRepository.userId;
    await _userRepository.removeNewChatId(userId, chatId);
  }
}