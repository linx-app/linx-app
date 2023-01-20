extension FirebaseExtensions on List<dynamic> {
  List<String> toStrList() {
    return map((e) => e as String).toList();
  }
}

