part of 'auth_bloc.dart';

class AuthState {
  final User? currentUser;
  final Permissions? permissions;

  AuthState({
    this.currentUser,
    this.permissions,
  });

  AuthState copyWith({
    User? currentUser,
    Permissions? permissions,
  }) {
    return AuthState(
      currentUser: currentUser,
      permissions: permissions,
    );
  }
}

class AuthLoading extends AuthState {
  AuthLoading();
}

class LoginSuccess extends AuthState {
  LoginSuccess({
    super.currentUser,
    super.permissions,
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
    super.permissions,
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
