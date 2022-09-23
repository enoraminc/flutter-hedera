import 'dart:async';

import 'package:lumbung_common/model/user.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../apis/auth_api.dart';
import '../../apis/user_api.dart';
import '../../utils/log.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthApi authApi;
  final UserApi userApi;

  AuthBloc({
    required this.authApi,
    required this.userApi,
  }) : super(AuthState());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is LoginWithGoogle) {
      yield* _loginWithGoogle(event);
    } else if (event is SilentLogin) {
      yield* _silentLogin(event);
    } else if (event is LogoutButtonPressed) {
      yield* _logout();
    }
  }

  Stream<AuthState> _loginWithGoogle(LoginWithGoogle event) async* {
    yield AuthLoading();

    try {
      bool isLoginSuccessful = await authApi.loginWithGoogle();

      if (!isLoginSuccessful) {
        yield LoginFailure(error: 'Google login error');
      }

      User? user = await userApi.currentUser();
      Log.setLog('user ${user.toString()} ', method: "Auth Bloc");

      if (user == null) {
        Log.setLog('Unauthorized user ', method: "Auth Bloc");
        await authApi.logout();
        yield LoginFailure(error: 'Unauthorized user');
      } else {
        yield LoginSuccess(
          currentUser: user,
        );
      }
    } on Exception catch (e, s) {
      Log.setLog('error _loginWithGoogle: $e, $s', method: "Auth Bloc");

      yield LoginFailure(error: e.toString());
    } catch (e, s) {
      Log.setLog('error _loginWithGoogle: $e, $s', method: "Auth Bloc");

      yield LoginFailure(error: e.toString());
    }
  }

  Stream<AuthState> _silentLogin(SilentLogin event) async* {
    yield AuthLoading();

    try {
      // await Future.delayed(const Duration(milliseconds: 500));
      bool userAlreadyLoggedIn = await authApi.isUserLoggedIn();
      if (userAlreadyLoggedIn) {
        User? user = await userApi.currentUser();

        if (user != null) {
          yield UserAlreadyLoginSuccess(
            currentUser: user,
          );
        } else {
          await authApi.logout();
          yield SilentLoginFailure();
        }
      } else {
        yield SilentLoginFailure();
      }
    } on Exception catch (e, s) {
      Log.setLog('error: $e, $s', method: "Auth Bloc");
      yield LoginFailure(error: e.toString());
    }
  }

  Stream<AuthState> _logout() async* {
    yield AuthLoading();
    try {
      await authApi.logout();
      yield LogoutSuccess();
      yield state.copyWith(
        currentUser: null,
      );
    } on Exception catch (e, s) {
      Log.setLog('error: $e, $s', method: "Auth Bloc");
      yield LogoutFailure(error: e.toString());
    }
  }
}
