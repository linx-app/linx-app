import 'package:linx/features/core/data/model/package_dto.dart';
import 'package:linx/features/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';

extension PackageDTOTransformationExtensions on PackageDTO {
  SponsorshipPackage toDomain(LinxUser user) {
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