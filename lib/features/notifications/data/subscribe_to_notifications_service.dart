import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/notifications/domain/models/fcm_notification.dart';
import 'package:linx/features/notifications/domain/models/fcm_types.dart';
import 'package:linx/firebase/firebase_providers.dart';

class SubscribeToNotificationsService {
  static const String _NOTIFICATION_TYPE = "type";
  static final provider = Provider(
        (ref) => SubscribeToNotificationsService(ref.read(fcmMessages)),
  );

  final Stream<RemoteMessage> _onNotification;

  SubscribeToNotificationsService(this._onNotification);

  void execute(void Function(FCMNotification) handler) {
    _onNotification.listen((message) {
      if (message.notification != null) {
        var type = message.data[_NOTIFICATION_TYPE] ?? "";
        if (type == FCMType.new_pitch.name) {
          var notif = FCMNotification(FCMType.new_pitch, message.data);
          handler.call(notif);
        } else if (type == FCMType.new_match.name) {
          var notif = FCMNotification(FCMType.new_pitch, message.data);
          handler.call(notif);
        }
      }
    });
  }
}

