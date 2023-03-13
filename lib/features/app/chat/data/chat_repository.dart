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

  Stream<List<ChatDTO>> subscribeToChats(bool isClub, String uid) {
    final userIdField = isClub ? FirestorePaths.CLUB : FirestorePaths.BUSINESS;
    return _firestore
        .collection(FirestorePaths.CHATS)
        .where(userIdField, isEqualTo: uid)
        .snapshots()
        .map((event) {
      final chats = <ChatDTO>[];
      for (var change in event.docChanges) {
        final doc = change.doc;
        final data = doc.data();
        if (data != null) {
          chats.add(ChatDTO.fromNetwork(doc.id, data));
        }
      }
      return chats;
    });
  }

  Future<List<ChatDTO>> fetchAllChats(bool isClub, String uid) {
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

  Future<String?> fetchChat(String clubId, String businessId) async {
    return _firestore
        .collection(FirestorePaths.CHATS)
        .where(FirestorePaths.CLUB, isEqualTo: clubId)
        .where(FirestorePaths.BUSINESS, isEqualTo: businessId)
        .get()
        .then((query) {
      if (query.docs.isEmpty) {
        return null;
      } else {
        return query.docs.first.id;
      }
    });
  }

  Future<ChatDTO> fetchChatById(String chatId) async {
    return _firestore
        .collection(FirestorePaths.CHATS)
        .doc(chatId)
        .get()
        .then((value) => ChatDTO.fromNetwork(value.id, value.data()!));
  }

  Future<void> updateLastMessageId(String chatId, String messageId) async {
    _firestore
        .collection(FirestorePaths.CHATS)
        .doc(chatId)
        .update({FirestorePaths.LAST_MESSAGE_ID: messageId});
  }

  Future<String> createNewChat(String clubId, String businessId) async {
    final data = {
      FirestorePaths.CLUB: clubId,
      FirestorePaths.BUSINESS: businessId
    };
    return _firestore
        .collection(FirestorePaths.CHATS)
        .add(data)
        .then((value) => value.id);
  }
}
