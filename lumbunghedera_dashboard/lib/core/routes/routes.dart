import 'package:core/blocs/auth/auth_bloc.dart';
import 'package:core/utils/log.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumbunghedera_dashboard/screen/job/job.dart';
import 'package:lumbunghedera_dashboard/screen/journal/journal.dart';
import 'package:lumbunghedera_dashboard/screen/dashboard/dashboard.dart';
import 'package:lumbunghedera_dashboard/screen/wallet/wallet.dart';

import '../../screen/auth/auth.dart';

class Routes {
  static String set = "set";
  static String create = "create";

  static String splash = "/";
  static String login = "/login";
  static String dashboard = "/dashboard";

  static String wallet = "/wallet";
  static String mainWallet = "main";
  static String subWallet = "sub";

  static String journal = "/journal";
  static String convertJournal = "convert";

  static String job = "/job";

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
            path: journal,
            pageBuilder: (context, state) {
              final id = state.queryParams["id"] ?? "";
              return CustomTransitionPage<void>(
                key: state.pageKey,
                child: JournalScreen(
                  id: id,
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        FadeTransition(opacity: animation, child: child),
              );
            },
            routes: [
              GoRoute(
                path: "$convertJournal/:id",
                builder: (BuildContext context, GoRouterState state) {
                  final id = state.params["id"] ?? "";
                  return JournalMessageScreen(topicId: id);
                },
              ),
              GoRoute(
                path: create,
                builder: (BuildContext context, GoRouterState state) {
                  return const CreateJournalScreen();
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
            routes: [
              GoRoute(
                path: set,
                builder: (BuildContext context, GoRouterState state) {
                  final type = state.params["type"] ?? "";
                  if (type == Routes.mainWallet) {
                    return const SetMainWalletScreen();
                  } else {
                    return const SetSubWalletScreen();
                  }
                },
              ),
            ],
          ),
          GoRoute(
            path: job,
            pageBuilder: (context, state) {
              final id = state.queryParams["id"] ?? "";
              return CustomTransitionPage<void>(
                key: state.pageKey,
                child: JobScreen(
                  id: id,
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
