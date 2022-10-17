part of 'vote_cubit.dart';

@immutable
abstract class VoteState extends Equatable {
  final List<VoteJournalModel> voteList;

  const VoteState({
    required this.voteList,
  });

  @override
  List<Object?> get props => [voteList];
}

class VoteInitial extends VoteState {
  const VoteInitial() : super(voteList: const []);
}

class VoteLoading extends VoteState {
  const VoteLoading({
    required super.voteList,
  });
}

class VoteSubmitLoading extends VoteState {
  const VoteSubmitLoading({
    required super.voteList,
  });
}

class VoteSuccess extends VoteState {
  const VoteSuccess({
    required super.voteList,
  });
}

class VoteSubmitSuccess extends VoteState {
  const VoteSubmitSuccess({
    required super.voteList,
  });
}

class VotePaymentSuccess extends VoteState {
  const VotePaymentSuccess({
    required super.voteList,
  });
}

class GenerateVoteReportSuccess extends VoteState {
  final String url;
  const GenerateVoteReportSuccess({
    required this.url,
    required super.voteList,
  });
}

class VoteFailed extends VoteState {
  final String message;
  const VoteFailed({
    required this.message,
    required super.voteList,
  });
}
