import 'package:lumbung_common/base/base_repository.dart';
import 'package:lumbung_common/model/hedera/concensus_model.dart';

abstract class ConcensusApi extends BaseRepository {
  Future<List<ConcensusMessageDataModel>> getConcensusMessageData(
      String topicId);
}
