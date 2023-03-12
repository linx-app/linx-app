import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/chat/data/model/chat_dto.dart';
import 'package:linx/firebase/firebase_providers.dart';
import 'package:linx/firebase/firestore_paths.dart';

class ChatRepository {
  static final provider =
      Provider((ref) => ChatRepository(ref.read(firestoreProvider)));

  final FirebaseFirestore _firestore;

  ChatRepository(this._firestore);

  Future<List<ChatDTO>> fetchAllChats(bool isClub, String uid) async {
    final userIdField = isClub ? FirestorePaths.CLUB : FirestorePaths.BUSINESS;
    return _firestore
        .collection(FirestorePaths.CHATS)
        .where(userIdField, isEqualTo: uid)
        .get()
        .then((value) {
      final chats = <ChatDTO>[];
      for (var doc in value.docs) {
        chats.add(ChatDTO.fromNetwork(doc.id, doc.data()));
      }
      return chats;
    });
  }
}
