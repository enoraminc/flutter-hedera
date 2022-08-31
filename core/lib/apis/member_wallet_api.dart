import 'package:lumbung_common/base/base_repository.dart';
import 'package:lumbung_common/model/hedera/token.dart';
import 'package:lumbung_common/model/hedera/wallet.dart';

import '../model/log_model.dart';

abstract class MemberWalletApi extends BaseRepository {
  Future<List<HederaWallet>> getAllWalletMember();
  Future<List<HederaToken>> getMemberAsaByAddress(String address);
  Future<RevokeAssetLogModel> revokeAsset(
      String userEmail, num revokeAmount, String assetId);
  Future<String?> swapAssets(String assetA, String assetB, int amount);
}
