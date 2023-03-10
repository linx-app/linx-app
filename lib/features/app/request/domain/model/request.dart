import 'package:linx/features/user/domain/model/linx_user.dart';

class Request {
  final LinxUser sender;
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
