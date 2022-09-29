import 'package:hedera_core/apis/concensus_api.dart';
import 'package:lumbung_common/model/hedera/concensus_model.dart';
import 'package:lumbung_common/utils/log.dart';
import 'package:lumbung_common/base/base_repository.dart';

class ConcensusApiImpl extends ConcensusApi {
  late final String url;

  final String firebase = "lumbunghedera";

  ConcensusApiImpl({
    required this.url,
  });

  @override
  Future<List<ConcensusMessageDataModel>> getConcensusMessageData(
      String topicId) async {
    try {
      final data = await request(
        '$url/consensus/message/$topicId',
        RequestType.get,
        useToken: true,
        firebase: firebase,
      );

      return data
          .map<ConcensusMessageDataModel>(
              (e) => ConcensusMessageDataModel.fromMap(e))
          .toList();
    } catch (e, s) {
      Log.setLog("$e $s", method: "getBookMessageData");
      rethrow;
    }
  }
}
