import 'package:linx/features/user/domain/model/linx_user.dart';

class UserSearchPage {
  final List<LinxUser> users;
  final int pageKey;
  final int? nextPageKey;

  UserSearchPage({
    required this.users,
    this.pageKey = 0,
    this.nextPageKey,
  });
}
