import 'package:core/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lumbung_wallet_cai/screen/home/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../screen/auth/auth.dart';

class Routes {
  static String splash = "/";
  static String login = "/login";
  static String home = "/home";

  static GoRouter getRouter(BuildContext context) => GoRouter(
        initialLocation: splash,
        urlPathStrategy: UrlPathStrategy.path,
        debugLogDiagnostics: true,
        routes: <GoRoute>[
          GoRoute(
            path: splash,
            builder: (BuildContext context, GoRouterState state) {
              return const SplashScreen();
            },
          ),
          GoRoute(
            path: home,
            builder: (BuildContext context, GoRouterState state) {
              return const HomeScreen();
            },
            redirect: (GoRouterState state) {
              // if the user is not logged in, they need to login
              if (context.read<AuthBloc>().state.currentUser == null) {
                return login;
              }

              return null;
            },
          ),
          GoRoute(
            path: login,
            builder: (BuildContext context, GoRouterState state) {
              return const LoginScreen();
            },
          ),
        ],
      );
}
