enum AuthResponseType {
  SUCCESS,
  UPDATE,
  FAILURE
}

abstract class AuthResponse {
  late final String? authMessage;
  AuthResponseType type();
  String? message();
}

class AuthSuccess implements AuthResponse {

  final String userId;

  @override
  late final String? authMessage;

  @override
  String? message() => authMessage;

  @override
  AuthResponseType type() => AuthResponseType.SUCCESS;

  AuthSuccess({this.authMessage, required this.userId});
}

class AuthFailure implements AuthResponse {

  @override
  String? authMessage;

  @override
  String? message() => authMessage;

  @override
  AuthResponseType type() => AuthResponseType.FAILURE;

  AuthFailure({this.authMessage});
}