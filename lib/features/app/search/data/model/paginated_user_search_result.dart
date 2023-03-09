import 'package:linx/features/user/data/model/user_dto.dart';

class PaginatedUserSearchResult {
  final List<UserDTO> users;
  final int pageKey;
  final int? nextPageKey;

  PaginatedUserSearchResult(this.users, this.pageKey, this.nextPageKey);
}