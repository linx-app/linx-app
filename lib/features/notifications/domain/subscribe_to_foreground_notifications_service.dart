import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/notifications/domain/model/fcm_notification.dart';
import 'package:linx/firebase/firebase_providers.dart';
import 'package:linx/utils/transformations/notification_transformation_extensions.dart';

class SubscribeToForegroundNotificationsService {
  static final provider = Provider(
    (ref) => SubscribeToForegroundNotificationsService(
      ref.read(fcmForegroundMessages),
    ),
  );

  final Stream<RemoteMessage> _onForegroundNotification;

  SubscribeToForegroundNotificationsService(this._onForegroundNotification);

  Stream<FCMNotification?> execute() {
    return _onForegroundNotification.map((message) => message.toDomain(false));
  }
}
