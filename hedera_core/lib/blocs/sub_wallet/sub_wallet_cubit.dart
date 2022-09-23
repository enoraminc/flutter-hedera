import 'package:bloc/bloc.dart';
import 'package:hedera_core/apis/hedera_sub_wallet_api.dart';
import 'package:hedera_core/model/hedera_sub_wallet.dart';
import 'package:meta/meta.dart';

import 'package:equatable/equatable.dart';

import '../../utils/log.dart';

part 'sub_wallet_state.dart';

class SubWalletCubit extends Cubit<SubWalletState> {
  final HederaSubWalletApi subWalletApi;

  SubWalletCubit({
    required this.subWalletApi,
  }) : super(SubWalletInitial());

  Future<void> changeSelectedData(HederaSubWallet? subWallet) async {
    emit(SubWalletFetchSuccess(
      selectedSubWallet: subWallet,
      subWalletList: state.subWalletList,
    ));
  }

  Future<void> setSubWallet(HederaSubWallet subWallet) async {
    emit(SubWalletSubmitLoading(
      selectedSubWallet: state.selectedSubWallet,
      subWalletList: state.subWalletList,
    ));

    await subWalletApi.setSubWallet(subWallet).then((value) {
      emit(SubWalletSubmitSuccess(
        selectedSubWallet: value,
        subWalletList: state.subWalletList,
      ));
    }).catchError((e, s) {
      Log.setLog("$e $s", method: "setSubWallet Bloc");
      emit(
        SubWalletFailed(
          message: e.toString(),
          selectedSubWallet: state.selectedSubWallet,
          subWalletList: state.subWalletList,
        ),
      );
    });
  }

  Future<void> fetchSubWallet() async {
    emit(SubWalletLoading(
      selectedSubWallet: state.selectedSubWallet,
      subWalletList: state.subWalletList,
    ));

    await subWalletApi.fetchAllSubWallet().then((value) {
      Log.setLog(
        "Total Sub Walet : ${value.length}",
        method: "getSubWallet Bloc",
      );
      emit(SubWalletFetchSuccess(
        selectedSubWallet: state.selectedSubWallet,
        subWalletList: value,
      ));
    }).catchError((e, s) {
      Log.setLog("$e $s", method: "getSubWallet Bloc");
      emit(
        SubWalletFailed(
          message: e.toString(),
          selectedSubWallet: state.selectedSubWallet,
          subWalletList: state.subWalletList,
        ),
      );
    });
  }

  Future<void> deleteSubWallet() async {
    emit(SubWalletSubmitLoading(
      selectedSubWallet: state.selectedSubWallet,
      subWalletList: state.subWalletList,
    ));

    if (state.selectedSubWallet == null) {
      emit(SubWalletFailed(
        message: "Sub Wallet Not Found",
        selectedSubWallet: state.selectedSubWallet,
        subWalletList: state.subWalletList,
      ));
      return;
    }

    final subWallet = state.selectedSubWallet!.copyWith(
      state: HederaSubWallet.deletedState,
    );

    await subWalletApi.setSubWallet(subWallet).then((value) {
      emit(SubWalletDeleteSuccess(
        selectedSubWallet: null,
        subWalletList: state.subWalletList,
      ));
    }).catchError((e, s) {
      Log.setLog("$e $s", method: "setSubWallet Bloc");
      emit(SubWalletFailed(
        message: e.toString(),
        selectedSubWallet: state.selectedSubWallet,
        subWalletList: state.subWalletList,
      ));
    });
  }
}
