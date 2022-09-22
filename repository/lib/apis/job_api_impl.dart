import 'package:core/apis/job_api.dart';
import 'package:core/model/job_model.dart';

import 'package:lumbung_common/utils/log.dart';
import 'package:lumbung_common/base/base_repository.dart';

class JobApiImpl extends JobApi {
  late final String url;

  final String firebase = "lumbunghedera";

  JobApiImpl({
    required this.url,
  });
  @override
  Future<List<JobModel>> fetchAllJob() async {
    try {
      final data = await request(
        '$url/job',
        RequestType.get,
        useToken: true,
        firebase: firebase,
      );

      return data.map<JobModel>((e) => JobModel.fromMap(e)).toList();
    } catch (e, s) {
      Log.setLog("$e $s", method: "fetchAllJob");
      rethrow;
    }
  }

  @override
  Future<JobRequestModel> submitJobRequest(JobRequestModel data) async {
    if (data.type.isEmpty) {
      throw Exception("Type cant be empty");
    }
    try {
      final result = await request(
        '$url/job/request',
        RequestType.post,
        body: data.toMap(),
        useToken: true,
        firebase: firebase,
      );

      return JobRequestModel.fromMap(result);
    } catch (e, s) {
      Log.setLog("$e $s", method: "submitJobRequest");
      rethrow;
    }
  }
}
