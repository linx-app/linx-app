import 'package:linx/features/user/domain/model/linx_user.dart';

class Request {
  final String id;
  final LinxUser sender;
  final LinxUser receiver;
  final DateTime createdAt;
  final String message;
  final bool hasBeenViewed;

  Request({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.createdAt,
    required this.message,
    required this.hasBeenViewed,
  });
}
