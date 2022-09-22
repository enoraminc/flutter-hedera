import 'package:core/model/hedera_sub_wallet.dart';
import 'package:core/model/job_model.dart';
import 'package:lumbung_common/base/base_repository.dart';
import 'package:lumbung_common/model/hedera/wallet.dart';
import 'package:lumbung_common/model/hedera/token.dart';

abstract class JobApi extends BaseRepository {
  Future<List<JobModel>> fetchAllJob();
  Future<JobRequestModel> submitJobRequest(JobRequestModel data);
}
