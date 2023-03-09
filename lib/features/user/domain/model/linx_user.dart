import 'package:linx/features/app/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/user/domain/model/user_info.dart';

class LinxUser {
  final UserInfo info;
  final List<SponsorshipPackage> packages;
  final int matchPercentage;

  LinxUser({
    required this.info,
    required this.packages,
    required this.matchPercentage,
  });
}
