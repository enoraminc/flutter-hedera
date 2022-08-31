import 'package:core/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lumbung_wallet_cai/screen/home/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumbung_wallet_cai/screen/sub_wallet/sub_wallet.dart';

import '../../screen/auth/auth.dart';

class Routes {
  static String set = "set";

  static String splash = "/";
  static String login = "/login";
  static String home = "/home";

  static String subWallet = "/sub-wallet";

  static GoRouter getRouter(AuthBloc authBloc) => GoRouter(
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
          ),
          GoRoute(
            path: subWallet,
            builder: (BuildContext context, GoRouterState state) {
              return const DetailSubWalletScreen();
            },
            routes: [
              GoRoute(
                path: set,
                builder: (BuildContext context, GoRouterState state) {
                  return const SetSubWalletScreen();
                },
              ),
            ],
          ),
          GoRoute(
            path: login,
            builder: (BuildContext context, GoRouterState state) {
              return const LoginScreen();
            },
          ),
        ],
        redirect: (GoRouterState state) {
          final loggingIn = state.subloc == '/login' || state.subloc == '/';
          if (loggingIn) return null;

          // if the user is not logged in, they need to login
          if (authBloc.state.currentUser == null) {
            return splash;
          }

          return null;
        },
      );
}
