import 'package:algolia/algolia.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final algoliaProvider = Provider<Algolia>(
  (ref) => const Algolia.init(
    applicationId: "C2D08KXN6F",
    apiKey: "9b3830fe4130a40ce04e913a4d821a4a",
  ),
);
