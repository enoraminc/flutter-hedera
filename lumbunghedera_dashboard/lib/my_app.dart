import 'package:core/blocs/book/book_cubit.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lumbung_localizations/lumbung_localizations.dart';

import 'package:core/apis/auth_api.dart';
import 'package:core/apis/user_api.dart';
import 'package:core/apis/hedera_sub_wallet_api.dart';
import 'package:core/apis/member_wallet_api.dart';
import 'package:core/apis/book_api.dart';

import 'package:core_cai_v3/api/chat_message_api.dart';
import 'package:lumbung_common/api/hedera/hedera_api.dart';

import 'package:core/blocs/auth/auth_bloc.dart';
import 'package:lumbung_common/bloc/hedera/hedera_cubit.dart';

import 'package:core_cai_v3/bloc/chat_message/chat_message_bloc.dart';
import 'package:core/blocs/member_wallet/member_wallet_cubit.dart';
import 'package:core/blocs/sub_wallet/sub_wallet_cubit.dart';

import 'core/routes/routes.dart';
import 'core/utils/scroll_behavior.dart';
import 'core/utils/themes.dart';
import 'flavor_config.dart';
import 'injector.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoRouter _router;

  late AuthBloc authBloc;

  @override
  void initState() {
    authBloc = AuthBloc(
      authApi: locator.get<AuthApi>(),
      userApi: locator.get<UserApi>(),
    );

    _router = Routes.getRouter(authBloc);
    super.initState();
  }

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
          create: (_) => authBloc,
        ),
        BlocProvider<ChatMessageBloc>(
          create: (_) => ChatMessageBloc(
            locator.get<ChatMessageApi>(),
          ),
        ),
        BlocProvider<HederaCubit>(
          create: (_) => HederaCubit(
            locator.get<HederaApi>(),
            sharedPreferences,
          ),
        ),
        BlocProvider<MemberWalletCubit>(
          create: (_) => MemberWalletCubit(
            locator.get<MemberWalletApi>(),
            sharedPreferences,
          ),
        ),
        BlocProvider<SubWalletCubit>(
          create: (_) => SubWalletCubit(
            subWalletApi: locator.get<HederaSubWalletApi>(),
          ),
        ),
        BlocProvider<BookCubit>(
          create: (_) => BookCubit(
            bookApi: locator.get<BookApi>(),
          ),
        ),
      ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        buildWhen: (previousState, currentState) =>
            previousState != currentState,
        builder: (_, localeState) {
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
        },
      ),
    );
  }
}
