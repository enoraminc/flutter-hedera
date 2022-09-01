import 'package:bloc/bloc.dart';
import 'package:core/apis/member_wallet_api.dart';
import 'package:lumbung_common/model/hedera/token.dart';
import 'package:lumbung_common/model/hedera/wallet.dart';
import 'package:meta/meta.dart';

import 'package:lumbung_common/utils/log.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:equatable/equatable.dart';

part 'member_wallet_state.dart';

class MemberWalletCubit extends Cubit<MemberWalletState> {
  final MemberWalletApi _memberWalletApi;
  final SharedPreferences? sharedPreferences;
  MemberWalletCubit(this._memberWalletApi, this.sharedPreferences)
      : super(MemberWalletInitial());

  Future<void> _setMemberWallet(List<HederaWallet> data) async {
    await sharedPreferences?.setStringList(
        "member_wallet", data.map((e) => e.toJson()).toList());
  }

  Future<void> _getMemberWallet() async {
    List<String>? json = sharedPreferences?.getStringList("member_wallet");
    if (json == null) {
      return;
    }

    final data = json.map((e) => HederaWallet.fromJson(e)).toList();

    if (data.isNotEmpty) {
      emit(FetchMemberWalletSuccess(
        memberWalletList: data,
        selectedWallet: state.selectedWallet,
      ));
    }
  }

  Future<void> fetchAllMemberWallet() async {
    emit(MemberWalletLoading(
      memberWalletList: state.memberWalletList,
      selectedWallet: state.selectedWallet,
    ));

    await _getMemberWallet();

    _memberWalletApi.getAllWalletMember().then((value) {
      List<HederaWallet> wallets = [];
      List<String> emailList = [];

      for (HederaWallet element in value) {
        if (!emailList.contains(element.email)) {
          wallets.add(element);
          emailList.add(element.email);
        } else {
          Log.setLog(element.id, method: "Duplicate");
        }
      }

      wallets.sort((a, b) =>
          b.createdAt?.millisecondsSinceEpoch ??
          0.compareTo(a.createdAt?.millisecondsSinceEpoch ?? 0));

      _setMemberWallet(wallets);

      emit(FetchMemberWalletSuccess(
        memberWalletList: wallets,
        selectedWallet: state.selectedWallet,
      ));
    }).catchError((e, s) {
      emit(FetchMemberWalletFailed(
        e.toString(),
        memberWalletList: state.memberWalletList,
        selectedWallet: state.selectedWallet,
      ));
      Log.setLog("$e $s", method: "fetchAllMemberWallet Bloc");
    });
  }

  Future<void> fetchMemberAssets(String address) async {
    emit(MemberAssetLoading(
      memberWalletList: state.memberWalletList,
      selectedWallet: state.selectedWallet,
    ));

    _memberWalletApi.getMemberAsaByAddress(address).then((value) {
      emit(FetchMemberAssetsSuccess(
        value,
        memberWalletList: state.memberWalletList,
        selectedWallet: state.selectedWallet,
      ));
    }).catchError((e, s) {
      emit(FetchMemberAssetsFailed(
        e.toString(),
        memberWalletList: state.memberWalletList,
        selectedWallet: state.selectedWallet,
      ));
      Log.setLog("$e $s", method: "fetchMemberAssets Bloc");
    });
  }

  Future<void> revokeMemberAssets(
      String userEmail, num revokeAmount, String assetId) async {
    emit(SubmitMemberLoading(
      memberWalletList: state.memberWalletList,
      selectedWallet: state.selectedWallet,
    ));

    _memberWalletApi
        .revokeAsset(userEmail, revokeAmount, assetId)
        .then((value) {
      emit(SubmitMemberWalletSuccess(
        memberWalletList: state.memberWalletList,
        selectedWallet: state.selectedWallet,
      ));
    }).catchError((e, s) {
      emit(SubmitMemberWalletFailed(
        e.toString(),
        memberWalletList: state.memberWalletList,
        selectedWallet: state.selectedWallet,
      ));
      Log.setLog("$e $s", method: "fetchMemberAssets Bloc");
    });
  }

  Future<void> changeSelectedWallet(HederaWallet? wallet) async {
    emit(FetchMemberWalletSuccess(
      memberWalletList: state.memberWalletList,
      selectedWallet: wallet,
    ));
  }

  Future<void> setMainWallet(HederaWallet wallet) async {
    emit(SubmitMemberLoading(
      memberWalletList: state.memberWalletList,
      selectedWallet: state.selectedWallet,
    ));

    _memberWalletApi.setMainWallet(wallet).then((value) {
      emit(SubmitMemberWalletSuccess(
        memberWalletList: state.memberWalletList,
        selectedWallet: wallet,
      ));
    }).catchError((e, s) {
      emit(SubmitMemberWalletFailed(
        e.toString(),
        memberWalletList: state.memberWalletList,
        selectedWallet: state.selectedWallet,
      ));
      Log.setLog("$e $s", method: "fetchMemberAssets Bloc");
    });
  }
}
