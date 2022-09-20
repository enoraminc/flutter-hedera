import 'package:core/apis/hedera_sub_wallet_api.dart';
import 'package:core/model/hedera_sub_wallet.dart';
import 'package:lumbung_common/base/base_repository.dart';
import 'package:lumbung_common/model/hedera/token.dart';
import 'package:lumbung_common/utils/log.dart';

class HederaSubWalletApiImpl extends HederaSubWalletApi {
  late final String url;

  final String firebase = "lumbunghedera";

  HederaSubWalletApiImpl({
    required this.url,
  });

  @override
  Future<List<HederaSubWallet>> fetchAllSubWallet() async {
    try {
      final data = await request(
        '$url/sub-wallet',
        RequestType.get,
        useToken: true,
        firebase: firebase,
      );

      return data
          .map<HederaSubWallet>((e) => HederaSubWallet.fromMap(e))
          .toList();
    } catch (e, s) {
      Log.setLog("$e $s", method: "fetchAllSubWallet");
      rethrow;
    }
  }

  @override
  Future<HederaSubWallet> setSubWallet(HederaSubWallet subWallet) async {
    if (subWallet.title.isEmpty) {
      throw Exception("Title cant be empty");
    }

    if (subWallet.users.isEmpty) {
      throw Exception("Users cant be empty");
    }

    try {
      final data = await request(
        '$url/sub-wallet',
        RequestType.post,
        body: subWallet.toMap(),
        useToken: true,
        firebase: firebase,
      );

      return HederaSubWallet.fromMap(data);
    } catch (e, s) {
      Log.setLog("$e $s", method: "setSubWallet");
      rethrow;
    }
  }
}
