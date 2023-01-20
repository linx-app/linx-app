import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/core/domain/model/sponsorship_package.dart';
import 'package:linx/firebase/firebase_providers.dart';
import 'package:linx/firebase/firestore_paths.dart';

class SponsorshipPackageRepository {
  static final provider = Provider((ref) {
    return SponsorshipPackageRepository(ref.read(firestoreProvider));
  });

  final FirebaseFirestore _firestore;

  SponsorshipPackageRepository(this._firestore);

  Future<List<String>> addSponsorshipPackages(
    List<SponsorshipPackage> packages,
  ) async {
    List<String> packageIds = [];

    for (var package in packages) {
      _firestore.collection(FirestorePaths.PACKAGES).add({
        FirestorePaths.NAME: package.name,
        FirestorePaths.OWN_BENEFITS: package.ownBenefit,
        FirestorePaths.PARTNER_BENEFITS: package.partnerBenefit,
      }).then((doc) => packageIds.add(doc.id));
    }

    return packageIds;
  }

  Future<List<SponsorshipPackage>> fetchSponsorshipPackages(
    List<String> ids,
  ) async {
    if (ids.isEmpty) return [];
    List<SponsorshipPackage> packages = [];

    _firestore
        .collection(FirestorePaths.PACKAGES)
        .where(FieldPath.documentId, whereIn: ids)
        .get()
        .then(
          (query) => query.docs.forEach(
            (doc) {
              var data = doc.data();
              packages.add(
                SponsorshipPackage(
                  name: data[FirestorePaths.NAME] as String,
                  ownBenefit: data[FirestorePaths.OWN_BENEFITS] as String,
                  partnerBenefit:
                      data[FirestorePaths.PARTNER_BENEFITS] as String,
                ),
              );
            },
          ),
        );

    return packages;
  }
}
