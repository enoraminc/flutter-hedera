import 'package:bloc/bloc.dart';
import 'package:hedera_core/apis/concensus_api.dart';
import 'package:hedera_core/apis/journal_api.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../../model/concensus_model.dart';
import '../../model/journal_model.dart';
import '../../utils/excel_utils.dart';
import '../../utils/log.dart';

part 'journal_state.dart';

class JournalCubit extends Cubit<JournalState> {
  final JournalApi journalApi;
  final ConcensusApi concensusApi;
  JournalCubit({
    required this.journalApi,
    required this.concensusApi,
  }) : super(JournalInitial());

  Future<void> changeSelectedData(JournalModel? book) async {
    emit(GetJournalSuccess(
      journalList: state.journalList,
      selectedJournal: book,
    ));
  }

  Future<void> setJournal(JournalModel book) async {
    emit(SubmitJournalLoading(
      journalList: state.journalList,
      selectedJournal: state.selectedJournal,
    ));

    await journalApi.setJournal(book).then((value) {
      emit(SetJournalSuccess(
        journalList: state.journalList,
        selectedJournal: value,
      ));
    }).catchError((e, s) {
      Log.setLog("$e $s", method: "setSubWallet Bloc");
      emit(
        JournalFailed(
          message: e.toString(),
          journalList: state.journalList,
          selectedJournal: state.selectedJournal,
        ),
      );
    });
  }

  Future<void> getJournal({String? subWalletId}) async {
    emit(JournalLoading(
      journalList: state.journalList,
      selectedJournal: state.selectedJournal,
    ));

    await journalApi.getJournal(subWalletId: subWalletId).then((value) {
      Log.setLog(
        "Total Book : ${value.length}",
        method: "getBook Bloc",
      );
      emit(GetJournalSuccess(
        journalList: value,
        selectedJournal: state.selectedJournal,
      ));
    }).catchError((e, s) {
      Log.setLog("$e $s", method: "getBook Bloc");
      emit(
        JournalFailed(
          message: e.toString(),
          journalList: state.journalList,
          selectedJournal: state.selectedJournal,
        ),
      );
    });
  }

  Future<void> deleteJournal() async {
    emit(SubmitJournalLoading(
      journalList: state.journalList,
      selectedJournal: state.selectedJournal,
    ));

    if (state.selectedJournal == null) {
      emit(JournalFailed(
        message: "Book Not Found",
        journalList: state.journalList,
        selectedJournal: state.selectedJournal,
      ));
      return;
    }

    final book =
        state.selectedJournal!.copyWith(state: JournalModel.deletedState);

    await journalApi.setJournal(book).then((value) {
      emit(SetJournalSuccess(
        journalList: state.journalList,
        selectedJournal: null,
      ));
    }).catchError((e, s) {
      Log.setLog("$e $s", method: "setSubWallet Bloc");
      emit(
        JournalFailed(
          message: e.toString(),
          journalList: state.journalList,
          selectedJournal: state.selectedJournal,
        ),
      );
    });
  }

  Future<void> getJournalMessageData(String topicId) async {
    emit(JournalMessageLoading(
      journalList: state.journalList,
      selectedJournal: state.selectedJournal,
    ));

    await concensusApi.getConcensusMessageData(topicId).then((value) {
      Log.setLog(
        "Total Book Message : ${value.length}",
        method: "getBookMessageData Bloc",
      );
      emit(GetJournalMessageDataSuccess(
        data: value,
        journalList: state.journalList,
        selectedJournal: state.selectedJournal,
      ));
    }).catchError((e, s) {
      Log.setLog("$e $s", method: "getBookMessageData Bloc");
      emit(
        GetJournalMessageDataFailed(
          message: e.toString(),
          journalList: state.journalList,
          selectedJournal: state.selectedJournal,
        ),
      );
    });
  }

  Future<void> exportJournal(List<ConcensusMessageDataModel> dataList) async {
    emit(SubmitJournalLoading(
      journalList: state.journalList,
      selectedJournal: state.selectedJournal,
    ));
    try {
      await ExcelUtils.generateCashbonExcel(dataList);

      await Future.delayed(const Duration(milliseconds: 500));

      emit(SetJournalSuccess(
        journalList: state.journalList,
        selectedJournal: state.selectedJournal,
      ));
    } catch (e, s) {
      Log.setLog("$e $s", method: "setSubWallet Bloc");
      emit(
        JournalFailed(
          message: e.toString(),
          journalList: state.journalList,
          selectedJournal: state.selectedJournal,
        ),
      );
    }
  }

  Future<void> submitCashbonMember({
    required String type,
    required int amount,
  }) async {
    emit(SubmitJournalLoading(
      journalList: state.journalList,
      selectedJournal: state.selectedJournal,
    ));

    await journalApi
        .submitCashbonMember(
      amount: amount,
      type: type,
      bookId: state.selectedJournal?.id ?? "",
    )
        .then((value) {
      emit(SetJournalSuccess(
        journalList: state.journalList,
        selectedJournal: state.selectedJournal,
      ));
    }).catchError((e, s) {
      Log.setLog("$e $s", method: "submitCashbonMember Bloc");
      emit(
        JournalFailed(
          message: e.toString(),
          journalList: state.journalList,
          selectedJournal: state.selectedJournal,
        ),
      );
    });
  }
}
