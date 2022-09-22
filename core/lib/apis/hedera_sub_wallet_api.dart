import 'package:core/model/hedera_sub_wallet.dart';
import 'package:lumbung_common/base/base_repository.dart';
import 'package:lumbung_common/model/hedera/wallet.dart';
import 'package:lumbung_common/model/hedera/token.dart';

abstract class HederaSubWalletApi extends BaseRepository {
  Future<List<HederaSubWallet>> fetchAllSubWallet();
  Future<HederaSubWallet> setSubWallet(HederaSubWallet subWallet);
}
