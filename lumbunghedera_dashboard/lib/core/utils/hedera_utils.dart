import '../../flavor_config.dart';

class HederaUtils {
  static String explorerUrlMainnet = "https://testnet.hederaexplorer.io";
  static String explorerUrlTestnet = "https://testnet.hederaexplorer.io";

  static String getExplorerUrl() {
    if (FlavorConfig.instance.values.hederaNetwork == HederaNetwork.mainnet) {
      return explorerUrlMainnet;
    } else {
      return explorerUrlTestnet;
    }
  }
}
