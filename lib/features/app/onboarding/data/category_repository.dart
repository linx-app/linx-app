import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/firebase/firebase_providers.dart';
import 'package:linx/firebase/firestore_paths.dart';

class CategoryRepository {
  static final provider = Provider((ref) {
    return CategoryRepository(ref.read(firestoreProvider));
  });

  final FirebaseFirestore _firestore;

  CategoryRepository(this._firestore);

  Future<Map<String, List<String>>?> fetchCategories(List<String> categories) {
    return _firestore.collection(FirestorePaths.MISC)
        .doc(FirestorePaths.CATEGORIES)
        .get()
        .then((DocumentSnapshot doc) {
          if (doc.exists) {
            Map<String, List<String>> result = {};
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            for (var cat in categories) {
              if (data[cat] != null) {
                result[cat] = (data[cat] as List).map((e) => e as String).toList();
              } else {
                // Category does not exist
              }
            }
            return result;
          } else {
            return null;
          }
    });
  }
}
