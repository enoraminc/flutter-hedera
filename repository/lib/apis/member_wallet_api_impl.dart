import 'package:core/apis/member_wallet_api.dart';
import 'package:core/model/log_model.dart';
import 'package:lumbung_common/base/base_repository.dart';
import 'package:lumbung_common/model/hedera/token.dart';
import 'package:lumbung_common/model/hedera/wallet.dart';
import 'package:lumbung_common/utils/log.dart';

class MemberWalletApiImpl extends MemberWalletApi {
  late final String url;

  final String firebase = "lumbungalgo";

  MemberWalletApiImpl({
    required this.url,
  });

  @override
  Future<List<HederaWallet>> getAllWalletMember() async {
    try {
      final data = await request(
        '$url/wallet',
        RequestType.get,
        useToken: true,
        firebase: firebase,
      );

      return data.map<HederaWallet>((e) => HederaWallet.fromMap(e)).toList();
    } catch (e, s) {
      Log.setLog("$e $s", method: "getAllWalletMember");
      rethrow;
    }
  }

  @override
  Future<List<HederaToken>> getMemberAsaByAddress(String address) async {
    try {
      final data = await request(
        '$url/token/balance/$address',
        RequestType.get,
        useToken: true,
        firebase: firebase,
      );

      return data.map<HederaToken>((e) => HederaToken.fromMap(e)).toList();
    } catch (e, s) {
      Log.setLog("$e $s", method: "getMemberAsaByAddress");
      rethrow;
    }
  }

  @override
  Future<RevokeAssetLogModel> revokeAsset(
      String userEmail, num revokeAmount, String assetId) async {
    try {
      final data = await request(
        '$url/wallet/revoke-asset',
        RequestType.post,
        body: {
          "userEmail": userEmail,
          "revokeAmount": revokeAmount,
          "assetId": assetId,
        },
        useToken: true,
        firebase: firebase,
      );

      return RevokeAssetLogModel.fromMap(data);
    } catch (e, s) {
      Log.setLog("$e $s", method: "revokeAsset");
      rethrow;
    }
  }

  @override
  Future<String?> swapAssets(String assetA, String assetB, int amount) async {
    try {
      final data = await request(
        '$url/wallet/swap',
        RequestType.post,
        body: {
          "assetIdA": assetA,
          "assetIdB": assetB,
          "amount": amount,
        },
        useToken: true,
        firebase: firebase,
      );

      return data;
    } catch (e, s) {
      Log.setLog("$e $s", method: "swapAssets");
      rethrow;
    }
  }

  @override
  Future<HederaWallet> setMainWallet(HederaWallet wallet) async {
    if (wallet.email.isEmpty) {
      throw Exception("Email cant be empty");
    }

    try {
      final data = await request(
        '$url/wallet/set',
        RequestType.post,
        body: wallet.toMap(),
        useToken: true,
        firebase: firebase,
      );

      return HederaWallet.fromMap(data);
    } catch (e, s) {
      Log.setLog("$e $s", method: "setMainWallet");
      rethrow;
    }
  }
}
