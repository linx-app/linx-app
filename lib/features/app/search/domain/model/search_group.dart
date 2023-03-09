import 'package:linx/features/user/domain/model/display_user.dart';

class SearchGroup {
  final String category;
  final Set<DisplayUser> users;

  SearchGroup({required this.category, required this.users});
}