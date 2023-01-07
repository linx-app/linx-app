import 'package:linx/features/authentication/domain/models/user_type.dart';

class LinxUser {
  final String uid;
  String? displayName;
  String? email;
  UserType? type;

  LinxUser({
    required this.uid,
    this.displayName,
    this.email,
    this.type
  });
}