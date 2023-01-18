import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/core/data/sponsorship_package_repository.dart';
import 'package:linx/features/core/domain/model/sponsorship_package.dart';

class SponsorshipPackageService {
  static final provider = Provider((ref) {
    return SponsorshipPackageService(
      ref.read(SponsorshipPackageRepository.provider),
    );
  });

  final SponsorshipPackageRepository _sponsorshipPackageRepository;

  SponsorshipPackageService(
    this._sponsorshipPackageRepository,
  );

  Future<List<SponsorshipPackage>> fetchSponsorshipPackages(
    List<String> ids,
  ) async {
    return await _sponsorshipPackageRepository.fetchSponsorshipPackages(ids);
  }
}
