import 'package:core/blocs/auth/auth_bloc.dart';
import 'package:core/utils/log.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumbunghedera_dashboard/screen/book/book.dart';
import 'package:lumbunghedera_dashboard/screen/dashboard/dashboard.dart';
import 'package:lumbunghedera_dashboard/screen/wallet/wallet.dart';

import '../../screen/auth/auth.dart';

class Routes {
  static String set = "set";

  static String splash = "/";
  static String login = "/login";
  static String dashboard = "/dashboard";

  static String wallet = "/wallet";
  static String mainWallet = "main";
  static String subWallet = "sub";

  static String book = "/book";
  static String convertBook = "convert";

  static GoRouter getRouter(AuthBloc authBloc) => GoRouter(
        initialLocation: splash,
        urlPathStrategy: UrlPathStrategy.path,
        debugLogDiagnostics: true,
        routes: <GoRoute>[
          GoRoute(
            path: splash,
            // builder: (BuildContext context, GoRouterState state) {
            //   return const SplashScreen();
            // },
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: const SplashScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child),
            ),
          ),
          GoRoute(
            path: login,
            // builder: (BuildContext context, GoRouterState state) {
            //   return const LoginScreen();
            // },
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: const LoginScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child),
            ),
          ),
          GoRoute(
            path: dashboard,
            // builder: (BuildContext context, GoRouterState state) {
            //   return const DashboardScreen();
            // },
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: const DashboardScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child),
            ),
          ),
          GoRoute(
            path: book,
            // builder: (BuildContext context, GoRouterState state) {
            //   final id = state.queryParams["id"] ?? "";
            //   return BookScreen(
            //     id: id,
            //   );
            // },
            pageBuilder: (context, state) {
              final id = state.queryParams["id"] ?? "";
              return CustomTransitionPage<void>(
                key: state.pageKey,
                child: BookScreen(
                  id: id,
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        FadeTransition(opacity: animation, child: child),
              );
            },
            routes: [
              GoRoute(
                path: "$convertBook/:id",
                builder: (BuildContext context, GoRouterState state) {
                  final id = state.params["id"] ?? "";
                  return BookMessageScreen(topicId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: "$wallet/:type",
            builder: (BuildContext context, GoRouterState state) {
              final id = state.queryParams["id"] ?? "";
              final type = state.params["type"] ?? "";
              return WalletScreen(
                id: id,
                type: type,
              );
            },
            pageBuilder: (context, state) {
              final id = state.queryParams["id"] ?? "";
              final type = state.params["type"] ?? "";
              return CustomTransitionPage<void>(
                key: state.pageKey,
                child: WalletScreen(
                  id: id,
                  type: type,
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        FadeTransition(opacity: animation, child: child),
              );
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
