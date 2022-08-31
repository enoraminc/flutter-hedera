import 'package:lumbung_common/api/hedera/hedera_api.dart';
import 'package:lumbung_common/base/base_repository.dart';
import 'package:lumbung_common/model/hedera/token.dart';
import 'package:lumbung_common/utils/log.dart';

import 'package:lumbung_common/model/hedera/wallet.dart';

class HederaApiImpl extends HederaApi {
  late final String url;

  final String firebase = "lumbungalgo";

  HederaApiImpl({
    required this.url,
  });

  @override
  Future<HederaWallet?> fetchWallet() async {
    try {
      final data = await request(
        '$url/wallet',
        RequestType.post,
        useToken: true,
        firebase: firebase,
      );

      return HederaWallet.fromMap(data);
    } catch (e, s) {
      Log.setLog("$e $s", method: "fetchAccount");
      rethrow;
    }
  }

  @override
  Future<List<HederaToken>> fetchToken(String id) async {
    if (id.isEmpty) {
      throw Exception("Token ID Cant be Empty");
    }
    try {
      final data = await request(
        '$url/token/balance/$id',
        RequestType.get,
        useToken: true,
        firebase: firebase,
      );

      return data.map<HederaToken>((e) => HederaToken.fromMap(e)).toList();
    } catch (e, s) {
      Log.setLog("$e $s", method: "fetchToken");
      rethrow;
    }
  }

  @override
  Future<String> autoOptin() async {
    try {
      final data = await request(
        '$url/wallet/auto-optin',
        RequestType.post,
        useToken: true,
        firebase: firebase,
      );

      return data.toString();
    } catch (e, s) {
      Log.setLog("$e $s", method: "autoOptin");
      rethrow;
    }
  }
}
