class PitchDTO {
  final int createdDate;
  final String message;
  final String receiverId;
  final String senderId;

  PitchDTO({
    required this.createdDate,
    required this.message,
    required this.receiverId,
    required this.senderId,
  });
}
