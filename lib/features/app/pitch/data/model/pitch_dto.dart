class PitchDTO {
  final String id;
  final int createdDate;
  final String message;
  final String receiverId;
  final String senderId;
  final bool viewed;

  PitchDTO({
    required this.id,
    required this.createdDate,
    required this.message,
    required this.receiverId,
    required this.senderId,
    required this.viewed,
  });
}
