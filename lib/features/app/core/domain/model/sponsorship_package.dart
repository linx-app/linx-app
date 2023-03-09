import 'package:linx/features/user/domain/model/user_info.dart';

class SponsorshipPackage {
  final String packageId;
  final String name;
  final String ownBenefit;
  final String partnerBenefit;
  final UserInfo user;

  SponsorshipPackage({
    this.packageId = "",
    this.name = "",
    this.ownBenefit = "",
    this.partnerBenefit = "",
    required this.user,
  });
}
