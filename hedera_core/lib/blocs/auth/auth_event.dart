part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent([List props = const []]) : super();
}

class LoginWithGoogle extends AuthEvent {
  const LoginWithGoogle() : super();

  @override
  String toString() => 'LoginWithGoogle';

  @override
  List<Object> get props => [];
}

class SilentLogin extends AuthEvent {
  const SilentLogin() : super();

  @override
  String toString() => 'SilentLogin';

  @override
  List<Object> get props => [];
}

class LogoutButtonPressed extends AuthEvent {
  const LogoutButtonPressed() : super();

  @override
  String toString() => 'LogoutButtonPressed';

  @override
  List<Object> get props => [];
}

class GetUserByEmail extends AuthEvent {
  final String? email;

  const GetUserByEmail({this.email}) : super();

  @override
  String toString() => 'GetUserByEmail { email: $email}';

  @override
  List<Object?> get props => [email];
}
