import 'package:lumbung_common/base/base_repository.dart';

import '../model/concensus_model.dart';

abstract class ConcensusApi extends BaseRepository {
  Future<List<ConcensusMessageDataModel>> getConcensusMessageData(
      String topicId);
}
