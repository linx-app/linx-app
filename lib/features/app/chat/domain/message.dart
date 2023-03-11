class Message {
  final String message;
  final String receiverId;
  final String senderId;
  final DateTime createdAt;

  Message(this.message, this.receiverId, this.senderId, this.createdAt);
}