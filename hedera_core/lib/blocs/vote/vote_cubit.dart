import 'package:bloc/bloc.dart';
import 'package:lumbung_common/model/hedera/hedera_sub_wallet.dart';
import 'package:lumbung_common/model/hedera/journal_model.dart';
import 'package:lumbung_common/api/hedera/job_api.dart';
import 'package:lumbung_common/api/hedera/journal_vote_api.dart';
import 'package:lumbung_common/model/hedera/job_model.dart';
import 'package:lumbung_common/utils/log.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:lumbung_common/model/hedera/vote_journal_model.dart';

part 'vote_state.dart';

class VoteCubit extends Cubit<VoteState> {
  final JournalVoteApi voteApi;
  final JobApi jobApi;

  VoteCubit({
    required this.voteApi,
    required this.jobApi,
  }) : super(const VoteInitial());

  Future<void> submitVoteMember({
    required String journalId,
    required String note,
  }) async {
    emit(VoteSubmitLoading(
      voteList: state.voteList,
    ));

    voteApi.submitVoteMember(journalId: journalId, note: note).then((value) {
      Log.setLog(value, method: "submitVoteMember Bloc");

      emit(VoteSubmitSuccess(
        voteList: state.voteList,
      ));
    }).catchError((e, s) {
      Log.setLog("$e $s", method: "submitVoteMember Bloc");
      emit(VoteFailed(
        message: e.toString(),
        voteList: state.voteList,
      ));
    });
  }
}
