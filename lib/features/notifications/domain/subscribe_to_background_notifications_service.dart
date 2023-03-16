import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/notifications/domain/model/fcm_notification.dart';
import 'package:linx/firebase/firebase_providers.dart';
import 'package:linx/utils/transformations/notification_transformation_extensions.dart';

class SubscribeToBackgroundNotificationsService {
  static final provider = Provider(
        (ref) => SubscribeToBackgroundNotificationsService(
      ref.read(fcmBackgroundOpenedMessages),
    ),
  );

  final Stream<RemoteMessage> _onBackgroundNotification;

  SubscribeToBackgroundNotificationsService(this._onBackgroundNotification);

  Stream<FCMNotification?> execute() {
    return _onBackgroundNotification.map((message) => message.toDomain(true));
  }
}
