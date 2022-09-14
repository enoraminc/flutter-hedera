import 'package:bloc/bloc.dart';
import 'package:core/apis/concensus_api.dart';
import 'package:core/apis/job_api.dart';
import 'package:core/utils/log.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../../model/concensus_model.dart';
import '../../model/job_model.dart';
part 'job_state.dart';

class JobCubit extends Cubit<JobState> {
  final JobApi jobApi;
  final ConcensusApi concensusApi;
  JobCubit({
    required this.jobApi,
    required this.concensusApi,
  }) : super(const JobInitial());

  Future<void> fetchAllJob() async {
    emit(JobLoading(jobList: state.jobList));

    jobApi.fetchAllJob().then((value) {
      Log.setLog("Fetch Job ${value.length}", method: "fetchAllJob Bloc");
      emit(GetJobSuccess(jobList: value));
    }).catchError((e, s) {
      Log.setLog("$e $s", method: "fetchAllJob Bloc");
      emit(JobFailed(
        message: e.toString(),
        jobList: state.jobList,
      ));
    });
  }

  Future<void> submitJobRequestSuccess(JobRequestModel data) async {
    emit(SubmitJobLoading(jobList: state.jobList));

    jobApi.submitJobRequest(data).then((value) {
      emit(SubmitJobRequestSuccess(jobList: state.jobList));
    }).catchError((e, s) {
      Log.setLog("$e $s", method: "submitJobRequestSuccess Bloc");
      emit(JobFailed(
        message: e.toString(),
        jobList: state.jobList,
      ));
    });
  }

  Future<void> getJobMessageData(String topicId) async {
    emit(JobMessageLoading(jobList: state.jobList));

    await concensusApi.getConcensusMessageData(topicId).then((value) {
      Log.setLog(
        "Total Job Message : ${value.length}",
        method: "getJobMessageData Bloc",
      );
      emit(GetJobMessageDataSuccess(
        data: value,
        jobList: state.jobList,
      ));
    }).catchError((e, s) {
      Log.setLog("$e $s", method: "getJobMessageData Bloc");
      emit(
        GetJobMessageDataFailed(
          message: e.toString(),
          jobList: state.jobList,
        ),
      );
    });
  }
}
