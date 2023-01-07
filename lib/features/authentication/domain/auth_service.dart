import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/authentication/data/auth_repository.dart';
import 'package:linx/features/authentication/domain/models/auth_response.dart';
import 'package:linx/features/authentication/domain/models/linx_user.dart';
import 'package:linx/features/authentication/domain/models/user_type.dart';

class AuthService {
  final ProviderRef ref;
  late AuthRepository authRepo = ref.watch(AuthRepository.provider);

  AuthService({required this.ref});

  static final provider = Provider<AuthService>((ref) => AuthService(ref: ref));

  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
    UserType userType,
  ) async {
    AuthResponse res =
        await authRepo.createUserWithEmailAndPassword(email, password, userType.name);

    if (res.type() == AuthResponseType.SUCCESS) {
      AuthSuccess success = res as AuthSuccess;
      LinxUser(
        uid: success.userId,
      );
    } else {
      print("User sign up failed!!");
    }
  }
}
