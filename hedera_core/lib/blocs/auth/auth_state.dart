part of 'auth_bloc.dart';

class AuthState {
  final User? currentUser;

  AuthState({
    this.currentUser,
  });

  AuthState copyWith(
      {User? currentUser}) {
    return AuthState(
      currentUser: currentUser,
    );
  }
}

class AuthLoading extends AuthState {
  AuthLoading();
}

class LoginSuccess extends AuthState {
  LoginSuccess({
    super.currentUser,
  });

  @override
  String toString() => 'LoginSuccess {} }';
}

// class LoginNewM

class SilentLoginFailure extends AuthState {
  SilentLoginFailure() : super();

  @override
  String toString() => 'SilentLoginFailure';
}

class LoginFailure extends AuthState {
  final String? error;

  LoginFailure({required this.error}) : super();

  @override
  String toString() => 'LoginFailure { error: $error }';
}

class LogoutSuccess extends AuthState {
  @override
  String toString() => 'LogoutSuccess';
}

class LogoutFailure extends AuthState {
  final String? error;

  LogoutFailure({required this.error}) : super();

  @override
  String toString() => 'LogoutFailure { error: $error }';
}

class UserAlreadyLoginSuccess extends AuthState {
  UserAlreadyLoginSuccess({
    super.currentUser,
  });

  @override
  String toString() => 'UserAlreadyLoginSuccess { }';
}

class UnauthorizedUsersTesting extends AuthState {
  UnauthorizedUsersTesting()
      : super(
          currentUser: null,
        );
}
