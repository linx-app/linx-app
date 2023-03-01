import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/firebase/fcm_types.dart';
import 'package:linx/firebase/firebase_providers.dart';

class NotificationsService {
  static const String _NOTIFICATION_TYPE = "type";
  static final provider = Provider(
        (ref) => NotificationsService(ref.read(fcmMessages)),
  );

  final Stream<RemoteMessage> _onNotification;

  NotificationsService(this._onNotification);

  void listenInForeground() {
    _onNotification.listen((message) {
      if (message.notification != null && message.data != null) {
        var type = message.data[_NOTIFICATION_TYPE] ?? "";
        if (type == FCMType.new_pitch.name) {
          var notif = FCMNotification(FCMType.new_pitch, message.data);
        } else if (type == FCMType.new_match.name) {
          var notif = FCMNotification(FCMType.new_pitch, message.data);
        }
      }
    });
  }
}

class FCMNotification {
  final FCMType type;
  final Map<String, dynamic> data;

  FCMNotification(this.type, this.data);
}
