import 'package:linx/features/user/domain/model/display_user.dart';

class UserSearchPage {
  final List<DisplayUser> users;
  final int pageKey;
  final int? nextPageKey;

  UserSearchPage({
    required this.users,
    this.pageKey = 0,
    this.nextPageKey,
  });
}
