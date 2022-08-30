import 'package:get_it/get_it.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:core/apis/auth_api.dart';
import 'package:core/apis/user_api.dart';
import 'package:repository/apis/auth_api_impl.dart';
import 'package:repository/apis/user_api_impl.dart';
import 'flavor_config.dart';

GetIt locator = GetIt.instance;
SharedPreferences? sharedPreferences;

Future<void> setupLocator() async {
  sharedPreferences = await SharedPreferences.getInstance();

  ///
  /// Auth
  ///

  locator.registerSingleton<AuthApi>(
    AuthApiImpl(),
    signalsReady: true,
  );

  locator.registerSingleton<UserApi>(
    UserApiImpl(
      FlavorConfig.instance.values.rempahApiUrl,
    ),
    signalsReady: true,
  );
}
