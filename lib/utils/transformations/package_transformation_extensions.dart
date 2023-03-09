import 'package:linx/features/app/core/data/model/package_dto.dart';
import 'package:linx/features/app/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/user/domain/model/user_info.dart';

extension PackageDTOTransformationExtensions on PackageDTO {
  SponsorshipPackage toDomain(UserInfo user) {
    return SponsorshipPackage(
      packageId: packageId,
      user: user,
      name: packageName,
      ownBenefit: ownBenefits,
      partnerBenefit: partnerBenefits,
    );
  }
}

extension SponsorshipPackageTransformationExtensions on SponsorshipPackage {
  PackageDTO toNetwork() {
    return PackageDTO(
      userId: user.uid,
      packageName: name,
      ownBenefits: ownBenefit,
      partnerBenefits: partnerBenefit,
    );
  }
}