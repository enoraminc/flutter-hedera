import 'dart:async';

import 'package:lumbung_common/model/user.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumbung_common/model/permissions.dart';
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
  }) : super(AuthState()) {
    on<LoginWithGoogle>((event, emit) async {
      await _loginWithGoogle(event, emit);
    });

    on<SilentLogin>((event, emit) async {
      await _silentLogin(event, emit);
    });

    on<LogoutButtonPressed>((event, emit) async {
      await _logout(event, emit);
    });
  }

  Future<void> _loginWithGoogle(
      LoginWithGoogle event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      bool isLoginSuccessful = await authApi.loginWithGoogle();

      if (!isLoginSuccessful) {
        emit(LoginFailure(error: 'Google login error'));
      }

      UserData? userData = await userApi.currentUser();
      Log.setLog('user ${userData?.user.toString()} ', method: "Auth Bloc");

      if (userData?.user == null) {
        Log.setLog('Unauthorized user ', method: "Auth Bloc");
        await authApi.logout();
        emit(LoginFailure(error: 'Unauthorized user'));
      } else {
        emit(LoginSuccess(
          currentUser: userData?.user,
          permissions: userData?.permissions,
        ));
      }
    } on Exception catch (e, s) {
      Log.setLog('error _loginWithGoogle: $e, $s', method: "Auth Bloc");

      emit(LoginFailure(error: e.toString()));
    } catch (e, s) {
      Log.setLog('error _loginWithGoogle: $e, $s', method: "Auth Bloc");

      emit(LoginFailure(error: e.toString()));
    }
  }

  Future<void> _silentLogin(SilentLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      // await Future.delayed(const Duration(milliseconds: 500));
      bool userAlreadyLoggedIn = await authApi.isUserLoggedIn();
      if (userAlreadyLoggedIn) {
        UserData? userData = await userApi.currentUser();

        if (userData?.user != null) {
          emit(UserAlreadyLoginSuccess(
            currentUser: userData?.user,
            permissions: userData?.permissions,
          ));
        } else {
          await authApi.logout();
          emit(SilentLoginFailure());
        }
      } else {
        emit(SilentLoginFailure());
      }
    } on Exception catch (e, s) {
      Log.setLog('error: $e, $s', method: "Auth Bloc");
      emit(LoginFailure(error: e.toString()));
    } catch (e, s) {
      Log.setLog('error: $e, $s', method: "Auth Bloc");
      emit(LoginFailure(error: e.toString()));
    }
  }

  Future<void> _logout(
      LogoutButtonPressed event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authApi.logout();
      emit(LogoutSuccess());
      emit(state.copyWith(
        currentUser: null,
      ));
    } on Exception catch (e, s) {
      Log.setLog('error: $e, $s', method: "Auth Bloc");
      emit(LogoutFailure(error: e.toString()));
    } catch (e, s) {
      Log.setLog('error: $e, $s', method: "Auth Bloc");
      emit(LoginFailure(error: e.toString()));
    }
  }
}
