import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/chat/data/model/message_dto.dart';
import 'package:linx/firebase/firebase_providers.dart';
import 'package:linx/firebase/firestore_paths.dart';

class MessageRepository {
  static final provider =
      Provider((ref) => MessageRepository(ref.read(firestoreProvider)));

  final FirebaseFirestore _firestore;

  MessageRepository(this._firestore);

  Future<MessageDTO> fetchMessage(String messageId) async {
    return await _firestore
        .collection(FirestorePaths.MESSAGES)
        .doc(messageId)
        .get()
        .then(
          (doc) => MessageDTO.fromNetwork(
            doc.id,
            doc.data() as Map<String, dynamic>,
          ),
        );
  }
}
