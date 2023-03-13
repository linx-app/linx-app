import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/chat/data/model/message_dto.dart';
import 'package:linx/features/user/domain/model/user_type.dart';
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

  Future<List<MessageDTO>> fetchMessagesFromChat(String chatId) async {
    return await _firestore
        .collection(FirestorePaths.MESSAGES)
        .where(FirestorePaths.CHAT_ID, isEqualTo: chatId)
        .orderBy(FirestorePaths.CREATED_AT)
        .get()
        .then((query) => _mapQueryToMessages(query));
  }

  Stream<List<MessageDTO>> subscribeToNewMessages(String chatId) {
    return _firestore
        .collection(FirestorePaths.MESSAGES)
        .where(FirestorePaths.CHAT_ID, isEqualTo: chatId)
        .orderBy(FirestorePaths.CREATED_AT)
        .snapshots()
        .map((event) {
      final messages = <MessageDTO>[];
      for (final change in event.docChanges) {
        final data = change.doc.data();
        if (data != null) {
          messages.add(MessageDTO.fromNetwork(change.doc.id, data));
        }
      }
      return messages;
    });
  }

  Future<String> createNewMessage(
    String chatId,
    String content,
    bool isCurrentClub,
  ) async {
    final data = {
      FirestorePaths.CHAT_ID: chatId,
      FirestorePaths.CONTENT: content,
      FirestorePaths.CREATED_AT: DateTime.now().millisecondsSinceEpoch,
      FirestorePaths.SENT_BY_USER_TYPE:
          isCurrentClub ? UserType.club.name : UserType.business.name,
    };
    return await _firestore
        .collection(FirestorePaths.MESSAGES)
        .add(data)
        .then((value) => value.id);
  }

  List<MessageDTO> _mapQueryToMessages(QuerySnapshot query) {
    final messages = <MessageDTO>[];
    for (final doc in query.docs) {
      final data = doc.data();
      if (data != null) {
        messages
            .add(MessageDTO.fromNetwork(doc.id, data as Map<String, dynamic>));
      }
    }
    return messages;
  }
}
