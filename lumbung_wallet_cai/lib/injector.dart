import 'package:get_it/get_it.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:core/apis/auth_api.dart';
import 'package:core/apis/user_api.dart';
import 'package:core/apis/hedera_sub_wallet_api.dart';
import 'package:core/apis/member_wallet_api.dart';

import 'package:core_cai_v3/api/chat_message_api.dart';
import 'package:lumbung_common/api/hedera/hedera_api.dart';

import 'package:repository/apis/auth_api_impl.dart';
import 'package:repository/apis/user_api_impl.dart';
import 'package:repository/apis/hedera_sub_wallet_api_impl.dart';
import 'package:repository/apis/member_wallet_api_impl.dart';
import 'package:repository/apis/chat_message_api_impl.dart';

import 'package:lumbung_common/go_api/hedera/hedera_api_impl.dart';

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

  ///
  /// CAI
  ///
  locator.registerSingleton<ChatMessageApi>(
    ChatMessageApiImpl(),
    signalsReady: true,
  );

  ///
  /// Wallet
  ///
  locator.registerSingleton<HederaApi>(
    HederaApiImpl(
      url: FlavorConfig.instance.values.hederaApiUrl,
    ),
    signalsReady: true,
  );

  locator.registerSingleton<HederaSubWalletApi>(
    HederaSubWalletApiImpl(
      url: FlavorConfig.instance.values.hederaApiUrl,
    ),
    signalsReady: true,
  );

  locator.registerSingleton<MemberWalletApi>(
    MemberWalletApiImpl(
      url: FlavorConfig.instance.values.hederaApiUrl,
    ),
    signalsReady: true,
  );
}
