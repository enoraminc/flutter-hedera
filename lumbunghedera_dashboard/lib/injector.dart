import 'package:get_it/get_it.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:hedera_core/apis/auth_api.dart';
import 'package:hedera_core/apis/user_api.dart';
import 'package:lumbung_common/api/hedera/hedera_sub_wallet_api.dart';
import 'package:hedera_core/apis/member_wallet_api.dart';
import 'package:hedera_core/apis/journal_api.dart';
import 'package:lumbung_common/api/hedera/job_api.dart';
import 'package:lumbung_common/api/hedera/journal_vote_api.dart';
import 'package:hedera_core/apis/concensus_api.dart';

import 'package:core_cai_v3/api/chat_message_api.dart';
import 'package:lumbung_common/api/hedera/hedera_api.dart';

import 'package:repository/apis/auth_api_impl.dart';
import 'package:repository/apis/user_api_impl.dart';
import 'package:repository/apis/member_wallet_api_impl.dart';
import 'package:repository/apis/chat_message_api_impl.dart';
import 'package:repository/apis/journal_api_impl.dart';
import 'package:lumbung_common/go_api/hedera/job_api_impl.dart';
import 'package:repository/apis/concensus_api_impl.dart';

import 'package:lumbung_common/go_api/hedera/hedera_api_impl.dart';
import 'package:lumbung_common/go_api/hedera/hedera_sub_wallet_api_impl.dart';
import 'package:lumbung_common/go_api/hedera/journal_vote_api_impl.dart';

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
      firebase: HederaSubWalletApiImpl.lumbunghederaFirebase,
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

  ///
  /// Concensus
  ///
  locator.registerSingleton<ConcensusApi>(
    ConcensusApiImpl(
      url: FlavorConfig.instance.values.hederaApiUrl,
    ),
    signalsReady: true,
  );

  ///
  /// Journal
  ///
  locator.registerSingleton<JournalApi>(
    JournalApiImpl(
      url: FlavorConfig.instance.values.hederaApiUrl,
    ),
    signalsReady: true,
  );

  locator.registerSingleton<JournalVoteApi>(
    JournalVoteApiImpl(
      firebase: JobApiImpl.lumbunghederaFirebase,
      url: FlavorConfig.instance.values.hederaApiUrl,
    ),
    signalsReady: true,
  );

  ///
  /// Job
  ///
  locator.registerSingleton<JobApi>(
    JobApiImpl(
      firebase: JobApiImpl.lumbunghederaFirebase,
      url: FlavorConfig.instance.values.hederaApiUrl,
    ),
    signalsReady: true,
  );
}
