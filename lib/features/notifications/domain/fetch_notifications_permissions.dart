import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/user/data/session_repository.dart';
import 'package:linx/features/user/data/user_repository.dart';
import 'package:linx/firebase/firebase_providers.dart';

class FetchNotificationPermissionsService {
  static final provider = Provider(
    (ref) => FetchNotificationPermissionsService(
      ref.read(fcmProvider),
      ref.read(SessionRepository.provider),
      ref.read(UserRepository.provider),
    ),
  );

  final SessionRepository _sessionRepository;
  final UserRepository _userRepository;
  final FirebaseMessaging _fcmInstance;

  FetchNotificationPermissionsService(
    this._fcmInstance,
    this._sessionRepository,
    this._userRepository,
  );

  Future<void> execute() async {
    NotificationSettings settings = await _fcmInstance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      var uid = _sessionRepository.userId;
      await _userRepository.removeFCMToken(uid);
    }
  }
}
