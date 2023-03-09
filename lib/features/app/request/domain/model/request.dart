import 'package:linx/features/user/domain/model/display_user.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';

class Request {
  final DisplayUser sender;
  final LinxUser receiver;
  final DateTime createdAt;
  final String message;

  Request({
    required this.sender,
    required this.receiver,
    required this.createdAt,
    required this.message,
  });
}
