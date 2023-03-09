import 'package:linx/features/app/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/user/domain/model/user_info.dart';

class DisplayUser {
  final UserInfo info;
  final List<SponsorshipPackage> packages;
  final int matchPercentage;

  DisplayUser({
    required this.info,
    required this.packages,
    required this.matchPercentage,
  });
}
