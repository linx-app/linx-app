import 'package:linx/features/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';

class DisplayUser {
  final LinxUser info;
  final List<SponsorshipPackage> packages;
  final int matchPercentage;

  DisplayUser({
    required this.info,
    required this.packages,
    required this.matchPercentage,
  });
}
