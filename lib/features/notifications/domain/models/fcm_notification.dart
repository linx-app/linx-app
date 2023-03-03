import 'package:linx/features/notifications/domain/models/fcm_types.dart';

class FCMNotification {
  final FCMType type;
  final Map<String, dynamic> data;

  FCMNotification(this.type, this.data);
}