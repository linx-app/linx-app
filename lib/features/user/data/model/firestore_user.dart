class FirestoreUser {
  final String uid;
  final String displayName;
  final String email;
  final String location;
  final String phoneNumber;
  final String biography;
  final List<String> interests;
  final List<String> descriptors;
  final String type;
  final List<String> packages;
  final List<String> profileImageUrls;

  FirestoreUser({
    required this.uid,
    this.displayName = "",
    this.email = "",
    this.type = "",
    this.location = "",
    this.phoneNumber ="",
    this.biography = "",
    this.interests = const [],
    this.descriptors = const [],
    this.packages = const [],
    this.profileImageUrls = const [],
  });
}