import 'package:linx/features/user/domain/model/linx_user.dart';

class SponsorshipPackage {
  final String packageId;
  final String name;
  final String ownBenefit;
  final String partnerBenefit;
  final LinxUser user;

  SponsorshipPackage({
    this.packageId = "",
    this.name = "",
    this.ownBenefit = "",
    this.partnerBenefit = "",
    required this.user,
  });
}
