part of 'job_cubit.dart';

@immutable
abstract class JobState extends Equatable {
  final List<JobModel> jobList;
  const JobState({
    required this.jobList,
  });

  @override
  List<Object> get props => [jobList];
}

class JobInitial extends JobState {
  const JobInitial() : super(jobList: const []);
}

class JobMessageLoading extends JobState {
  const JobMessageLoading({required super.jobList});
}

class SubmitJobLoading extends JobState {
  const SubmitJobLoading({required super.jobList});
}

class JobLoading extends JobState {
  const JobLoading({required super.jobList});
}

class GetJobSuccess extends JobState {
  const GetJobSuccess({required super.jobList});
}

class SubmitJobRequestSuccess extends JobState {
  const SubmitJobRequestSuccess({required super.jobList});
}

class JobFailed extends JobState {
  final String message;
  const JobFailed({required this.message, required super.jobList});
}

class GetJobMessageDataSuccess extends JobState {
  final List<ConcensusMessageDataModel> data;
  const GetJobMessageDataSuccess({
    required this.data,
    required super.jobList,
  });
}

class GetJobMessageDataFailed extends JobState {
  final String message;
  const GetJobMessageDataFailed({
    required this.message,
    required super.jobList,
  });
}
