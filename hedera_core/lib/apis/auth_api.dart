import 'dart:async';

abstract class AuthApi {
  Future<bool> loginWithGoogle();

  Future logout();

  Future<bool> isUserLoggedIn();
}
