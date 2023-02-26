class UserDTO {
  final String uid;
  final String displayName;
  final String email;
  final String location;
  final String phoneNumber;
  final String biography;
  final List<String> interests;
  final List<String> descriptors;
  final String type;
  final int numberOfPackages;
  final List<String> profileImageUrls;

  UserDTO({
    required this.uid,
    this.displayName = "",
    this.email = "",
    this.type = "",
    this.location = "",
    this.phoneNumber = "",
    this.biography = "",
    this.interests = const [],
    this.descriptors = const [],
    this.profileImageUrls = const [],
    this.numberOfPackages = 0,
  });
}
