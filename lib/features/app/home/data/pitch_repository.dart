import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/home/data/model/pitch_dto.dart';
import 'package:linx/firebase/firebase_providers.dart';
import 'package:linx/firebase/firestore_paths.dart';

class PitchRepository {
  static final provider =
  Provider((ref) => PitchRepository(ref.read(firestoreProvider)));

  final FirebaseFirestore _firestore;

  PitchRepository(this._firestore);

  Future<List<PitchDTO>> fetchPitchesWithReceiver(String receiverId) async {
    return _firestore
        .collection(FirestorePaths.PITCHES)
        .where(FirestorePaths.RECEIVER, isEqualTo: receiverId)
        .get()
        .then((QuerySnapshot query) => _mapQueryToPitches(query));
  }

  List<PitchDTO> _mapQueryToPitches(QuerySnapshot query) {
    var list = <PitchDTO>[];

    for (var doc in query.docs) {
      var obj = doc.data() as Map<String, dynamic>;

      list.add(
        PitchDTO(
            createdDate: obj[FirestorePaths.CREATED_AT] ?? 0,
            message: obj[FirestorePaths.MESSAGE] ?? "",
            receiverId: obj[FirestorePaths.RECEIVER] ?? "",
            senderId: obj[FirestorePaths.SENDER] ?? "",
        ),
      );
    }

    return list;
  }

}