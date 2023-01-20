enum UserType {
  club,
  business;

  UserType fromString(String s) {
    return values.firstWhere((element) => s == element.name);
  }
}