import 'package:linx/firebase/firebase_extensions.dart';
import 'package:linx/firebase/firestore_paths.dart';

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
  final List<String> pitchesTo;
  final List<String> searches;
  final List<String> newMatches;
  final int numberOfNewPitches;

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
    this.pitchesTo = const [],
    this.searches = const [],
    this.newMatches = const [],
    this.numberOfNewPitches = 0,
  });

  static UserDTO fromNetwork(String id, Map<String, dynamic> map) {
    final searches = ((map[FirestorePaths.SEARCHES] ?? []) as List<dynamic>);
    final last5Searches = searches.toStrList().reversed.take(5).toList();
    return UserDTO(
      uid: id,
      displayName: map[FirestorePaths.NAME] ?? "",
      type: map[FirestorePaths.TYPE] ?? "",
      location: map[FirestorePaths.LOCATION] ?? "",
      phoneNumber: map[FirestorePaths.PHONE_NUMBER] ?? "",
      biography: map[FirestorePaths.BIOGRAPHY] ?? "",
      interests:
          ((map[FirestorePaths.INTERESTS] ?? []) as List<dynamic>).toStrList(),
      descriptors: ((map[FirestorePaths.DESCRIPTORS] ?? []) as List<dynamic>)
          .toStrList(),
      numberOfPackages: map[FirestorePaths.NUMBER_OF_PACKAGES] ?? 0,
      profileImageUrls:
          ((map[FirestorePaths.PROFILE_IMAGES] ?? []) as List<dynamic>)
              .toStrList(),
      pitchesTo:
          ((map[FirestorePaths.PITCHES_TO] ?? []) as List<dynamic>).toStrList(),
      searches: last5Searches,
      newMatches: ((map[FirestorePaths.NEW_MATCHES] ?? []) as List<dynamic>)
          .toStrList(),
      numberOfNewPitches: map[FirestorePaths.NUMBER_OF_NEW_PITCHES] ?? 0,
    );
  }
}
