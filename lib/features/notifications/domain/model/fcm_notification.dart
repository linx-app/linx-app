abstract class FCMNotification {
  bool wasClickedOnBackground;

  FCMNotification(this.wasClickedOnBackground);
}

class NewMessageNotification extends FCMNotification {
  final String chatId;

  NewMessageNotification(this.chatId, super.wasClickedOnBackground);
}

class NewPitchNotification extends FCMNotification {
  NewPitchNotification(super.wasClickedOnBackground);
}

class NewMatchNotification extends FCMNotification {
  final String userId;
  final String name;
  final String imageUrl;

  NewMatchNotification(
    this.userId,
    this.name,
    this.imageUrl,
    super.wasClickedOnBackground,
  );
}
