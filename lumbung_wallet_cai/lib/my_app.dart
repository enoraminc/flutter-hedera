import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumbung_localizations/lumbung_localizations.dart';

import 'package:core/apis/auth_api.dart';
import 'package:core/apis/user_api.dart';
import 'package:core/blocs/auth/auth_bloc.dart';
import 'package:lumbung_wallet_cai/core/routes/routes.dart';

import 'core/blocs/main_screen/main_screen_bloc.dart';
import 'core/blocs/sidebar/sidebar_bloc.dart';

import 'core/utils/scroll_behavior.dart';
import 'core/utils/themes.dart';
import 'flavor_config.dart';
import 'injector.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleCubit>(
          create: (_) => LocaleCubit(
            sharedPreferences!,
            initialCode: "id",
          ),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            authApi: locator.get<AuthApi>(),
            userApi: locator.get<UserApi>(),
          )..add(const SilentLogin()),
        ),
        BlocProvider<SidebarBloc>(create: (_) => SidebarBloc()),
        BlocProvider<MainScreenBloc>(create: (_) => MainScreenBloc()),
      ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        buildWhen: (previousState, currentState) =>
            previousState != currentState,
        builder: (_, localeState) {
          return Builder(builder: (context) {
            final _router = Routes.getRouter(context);

            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: FlavorConfig.APP_NAME ?? "",
              theme: DynamicTheme.lightTheme(),
              darkTheme: DynamicTheme.darkTheme(),
              routeInformationProvider: _router.routeInformationProvider,
              routeInformationParser: _router.routeInformationParser,
              routerDelegate: _router.routerDelegate,
              scrollBehavior: MyCustomScrollBehavior(),
              themeMode: EasyDynamicTheme.of(context).themeMode,
              supportedLocales: AppLocalizationsSetup.supportedLocales,
              localizationsDelegates:
                  AppLocalizationsSetup.localizationsDelegates,
              localeResolutionCallback:
                  AppLocalizationsSetup.localeResolutionCallback,
              locale: localeState.locale,
            );
          });
        },
      ),
    );
  }
}
