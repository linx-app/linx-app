import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/core/data/model/package_dto.dart';
import 'package:linx/features/app/core/domain/model/sponsorship_package.dart';
import 'package:linx/firebase/firebase_providers.dart';
import 'package:linx/firebase/firestore_paths.dart';

class SponsorshipPackageRepository {
  static final provider = Provider((ref) {
    return SponsorshipPackageRepository(ref.read(firestoreProvider));
  });

  final FirebaseFirestore _firestore;

  SponsorshipPackageRepository(this._firestore);

  Future<void> updateSponsorshipPackages(
    List<SponsorshipPackage> packages,
  ) async {

    for (var package in packages) {
      if (package.packageId != "") {
        _firestore
            .collection(FirestorePaths.PACKAGES)
            .doc(package.packageId)
            .update({
          FirestorePaths.NAME: package.name,
          FirestorePaths.OWN_BENEFITS: package.ownBenefit,
          FirestorePaths.PARTNER_BENEFITS: package.partnerBenefit,
          FirestorePaths.USER_ID: package.user.uid,
        });
      } else {
        _firestore.collection(FirestorePaths.PACKAGES).add({
          FirestorePaths.NAME: package.name,
          FirestorePaths.OWN_BENEFITS: package.ownBenefit,
          FirestorePaths.PARTNER_BENEFITS: package.partnerBenefit,
          FirestorePaths.USER_ID: package.user.uid,
        });
      }
    }
  }

  Future<List<PackageDTO>> fetchSponsorshipPackagesByUser(
    String userId,
  ) async {
    return _firestore
        .collection(FirestorePaths.PACKAGES)
        .where(FirestorePaths.USER_ID, isEqualTo: userId)
        .get()
        .then(
          (query) => _mapQueryToPackage(query),
        );
  }

  List<PackageDTO> _mapQueryToPackage(QuerySnapshot query) {
    var list = <PackageDTO>[];

    for (var doc in query.docs) {
      var data = doc.data() as Map<String, dynamic>;
      list.add(
        PackageDTO(
            packageId: doc.id,
            packageName: data[FirestorePaths.NAME] ?? "",
            ownBenefits: data[FirestorePaths.OWN_BENEFITS] ?? "",
            partnerBenefits: data[FirestorePaths.PARTNER_BENEFITS] ?? "",
            userId: data[FirestorePaths.USER_ID] ?? ""),
      );
    }

    return list;
  }
}
