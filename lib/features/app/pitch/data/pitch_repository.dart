import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/pitch/data/model/pitch_dto.dart';
import 'package:linx/firebase/firebase_providers.dart';
import 'package:linx/firebase/firestore_paths.dart';

class PitchRepository {
  static final provider =
      Provider((ref) => PitchRepository(ref.read(firestoreProvider)));

  final FirebaseFirestore _firestore;

  PitchRepository(this._firestore);

  Future<void> sendPitch({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    await _firestore.collection(FirestorePaths.PITCHES).add({
      FirestorePaths.CREATED_AT: DateTime.now().millisecondsSinceEpoch,
      FirestorePaths.RECEIVER: receiverId,
      FirestorePaths.SENDER: senderId,
      FirestorePaths.MESSAGE: message,
      FirestorePaths.VIEWED: false,
      FirestorePaths.DISMISSED: false
    });
  }

  Future<List<PitchDTO>> fetchPitchesWithReceiver(String receiverId) async {
    return await _firestore
        .collection(FirestorePaths.PITCHES)
        .where(FirestorePaths.RECEIVER, isEqualTo: receiverId)
        .where(FirestorePaths.DISMISSED, isEqualTo: false)
        .limit(10)
        .get()
        .then((QuerySnapshot query) => _mapQueryToPitches(query));
  }

  Future<List<PitchDTO>> fetchOutgoingPitches(String senderId) async {
    return await _firestore
        .collection(FirestorePaths.PITCHES)
        .where(FirestorePaths.SENDER, isEqualTo: senderId)
        .orderBy(FirestorePaths.CREATED_AT, descending: true)
        .get()
        .then((QuerySnapshot query) => _mapQueryToPitches(query));
  }

  Future<void> changeViewedFlag(String pitchId) async {
    await _firestore
        .collection(FirestorePaths.PITCHES)
        .doc(pitchId)
        .update({FirestorePaths.VIEWED: true});
  }

  Future<void> changeDismissedFlag(String pitchId) async {
    await _firestore
        .collection(FirestorePaths.PITCHES)
        .doc(pitchId)
        .update({FirestorePaths.DISMISSED: true});
  }

  List<PitchDTO> _mapQueryToPitches(QuerySnapshot query) {
    var list = <PitchDTO>[];

    for (var doc in query.docs) {
      var obj = doc.data() as Map<String, dynamic>;
      list.add(
        PitchDTO(
          id: doc.id,
          createdDate: obj[FirestorePaths.CREATED_AT] ?? 0,
          message: obj[FirestorePaths.MESSAGE] ?? "",
          receiverId: obj[FirestorePaths.RECEIVER] ?? "",
          senderId: obj[FirestorePaths.SENDER] ?? "",
          viewed: obj[FirestorePaths.VIEWED] ?? false,
        ),
      );
    }

    return list;
  }
}
