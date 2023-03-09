import 'package:linx/features/user/domain/model/user_type.dart';

class LinxUser {
  final String uid;
  final String displayName;
  final String email;
  final String location;
  final String phoneNumber;
  final String biography;
  final Set<String> interests;
  final Set<String> descriptors;
  final int numberOfPackages;
  final UserType type;
  final List<String> profileImageUrls;
  final List<String> pitchesTo;
  final List<String> searches;

  const LinxUser({
    required this.uid,
    this.displayName = "",
    this.email = "",
    this.type = UserType.club,
    this.location = "",
    this.phoneNumber ="",
    this.biography = "",
    this.interests = const {},
    this.descriptors = const {},
    this.numberOfPackages = 0,
    this.profileImageUrls = const [],
    this.pitchesTo = const [],
    this.searches = const [],
  });
}

extension LinxUserExtensions on LinxUser {
  double findMatchPercent(LinxUser other) {
    final length = interests.length;
    return (interests.intersection(other.interests).length / length) * 100;
  }

  bool isClub() => type == UserType.club;
}