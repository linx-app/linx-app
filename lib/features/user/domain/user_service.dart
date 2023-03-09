import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/user/data/model/user_dto.dart';
import 'package:linx/features/user/data/session_repository.dart';
import 'package:linx/features/user/data/user_repository.dart';
import 'package:linx/features/user/domain/model/user_info.dart';
import 'package:linx/utils/transformations/user_transformation_extensions.dart';

class UserService {
  static final provider = Provider((ref) {
    return UserService(
      ref.read(UserRepository.provider),
      ref.read(SessionRepository.provider),
    );
  });

  final SessionRepository _sessionRepository;
  final UserRepository _userRepository;

  UserService(this._userRepository, this._sessionRepository);

  Future<UserInfo> fetchUserInfo() async {
    var uid = _sessionRepository.userId;
    UserDTO networkUser = await _userRepository.fetchUserProfile(uid);
    return networkUser.toDomain();
  }
}
