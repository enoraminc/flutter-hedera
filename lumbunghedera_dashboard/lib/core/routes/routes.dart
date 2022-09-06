import 'package:core/blocs/auth/auth_bloc.dart';
import 'package:core/utils/log.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumbunghedera_dashboard/screen/book/book.dart';
import 'package:lumbunghedera_dashboard/screen/dashboard/dashboard.dart';

import '../../screen/auth/auth.dart';

class Routes {
  static String set = "set";

  static String splash = "/";
  static String login = "/login";
  static String dashboard = "/dashboard";

  static String mainWallet = "/main-wallet";
  static String subWallet = "/sub-wallet";

  static String book = "/book";

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
            path: login,
            builder: (BuildContext context, GoRouterState state) {
              return const LoginScreen();
            },
          ),
          GoRoute(
            path: dashboard,
            builder: (BuildContext context, GoRouterState state) {
              return const DashboardScreen();
            },
          ),
          GoRoute(
            path: "$book/:id",
            builder: (BuildContext context, GoRouterState state) {
              final id = state.params["id"] ?? "";
              return BookMessageScreen(topicId: id);
            },
            // routes: [
            //   GoRoute(
            //     path: set,
            //     builder: (BuildContext context, GoRouterState state) {
            //       final id = state.params["id"] ?? "";
            //       return BookMessageScreen(id: id);
            //     },
            //   ),
            // ],
          ),
          // GoRoute(
          //   path: mainWallet,
          //   builder: (BuildContext context, GoRouterState state) {
          //     return const DetailMainWalletScreen();
          //   },
          //   routes: [
          //     GoRoute(
          //       path: set,
          //       builder: (BuildContext context, GoRouterState state) {
          //         return const SetMainWalletScreen();
          //       },
          //     ),
          //   ],
          // ),
          // GoRoute(
          //   path: subWallet,
          //   builder: (BuildContext context, GoRouterState state) {
          //     return const DetailSubWalletScreen();
          //   },
          //   routes: [
          //     GoRoute(
          //       path: set,
          //       builder: (BuildContext context, GoRouterState state) {
          //         return const SetSubWalletScreen();
          //       },
          //     ),
          //   ],
          // ),
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
