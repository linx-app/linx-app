import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/model/user_info.dart';

class Request {
  final LinxUser sender;
  final UserInfo receiver;
  final DateTime createdAt;
  final String message;

  Request({
    required this.sender,
    required this.receiver,
    required this.createdAt,
    required this.message,
  });
}
