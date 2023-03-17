import 'package:linx/features/user/domain/model/linx_user.dart';

class Match {
  final String id;
  final LinxUser user;
  final DateTime date;
  final bool isNew;

  Match({
    required this.id,
    required this.user,
    required this.date,
    required this.isNew,
  });
}
