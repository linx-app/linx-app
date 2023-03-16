import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:linx/features/notifications/domain/model/fcm_notification.dart';
import 'package:linx/features/notifications/domain/model/fcm_types.dart';

extension NotificationExtensions on RemoteMessage? {
  static const String _NOTIFICATION_TYPE = "type";
  static const String _CHAT_ID = "chat_id";
  static const String _USER_ID = "user_id";
  static const String _NAME = "name";
  static const String _PROFILE_IMAGE_URL = "profile_image_url";

  FCMNotification? toDomain(bool wasClickOnBackground) {
    final message = this;
    if (message == null) return null;
    if (message.notification != null) {
      final typeRaw = message.data[_NOTIFICATION_TYPE] ?? "";
      if (typeRaw.isEmpty) return null;
      final type = FCMType.values.firstWhere((e) => e.name == typeRaw);

      switch (type) {
        case FCMType.new_pitch:
          return NewPitchNotification(wasClickOnBackground);
        case FCMType.new_match:
          final userId = message.data[_USER_ID] ?? "";
          final name = message.data[_NAME] ?? "";
          final profileImageUrl = message.data[_PROFILE_IMAGE_URL] ?? "";
          return NewMatchNotification(userId, name, profileImageUrl, wasClickOnBackground);
        case FCMType.new_message:
          return NewMessageNotification(message.data[_CHAT_ID] ?? "", wasClickOnBackground);
      }
    }
  }
}