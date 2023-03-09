import 'package:linx/features/user/domain/model/linx_user.dart';

class SearchGroup {
  final String category;
  final Set<LinxUser> users;

  SearchGroup({required this.category, required this.users});
}