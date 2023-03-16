import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/notifications/domain/model/fcm_notification.dart';
import 'package:linx/firebase/firebase_providers.dart';
import 'package:linx/utils/transformations/notification_transformation_extensions.dart';

class FetchCachedNotificationsService {
  static final provider = Provider(
    (ref) => FetchCachedNotificationsService(
      ref.read(fcmTerminatedMessages),
    ),
  );

  final Future<RemoteMessage?> _onTerminatedMessage;

  FetchCachedNotificationsService(this._onTerminatedMessage);

  Future<FCMNotification?> execute() async {
    return (await _onTerminatedMessage).toDomain(true);
  }
}
