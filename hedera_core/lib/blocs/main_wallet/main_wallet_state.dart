part of 'main_wallet_cubit.dart';

@immutable
abstract class MainWalletState extends Equatable {
  final List<HederaWallet> mainWalletList;
  final HederaWallet? selectedWallet;

  const MainWalletState({
    required this.mainWalletList,
    required this.selectedWallet,
  });

  @override
  List<Object?> get props => [mainWalletList, selectedWallet];
}

class MemberWalletInitial extends MainWalletState {
  MemberWalletInitial() : super(mainWalletList: [], selectedWallet: null);
}

class MemberWalletLoading extends MainWalletState {
  const MemberWalletLoading({
    required super.mainWalletList,
    required super.selectedWallet,
  });
}

class MemberAssetLoading extends MainWalletState {
  const MemberAssetLoading({
    required super.mainWalletList,
    required super.selectedWallet,
  });
}

class SubmitMemberLoading extends MainWalletState {
  const SubmitMemberLoading({
    required super.mainWalletList,
    required super.selectedWallet,
  });
}

class FetchMemberWalletSuccess extends MainWalletState {
  const FetchMemberWalletSuccess({
    required super.mainWalletList,
    required super.selectedWallet,
  });
}

class FetchMemberWalletFailed extends MainWalletState {
  final String message;
  const FetchMemberWalletFailed(
    this.message, {
    required super.mainWalletList,
    required super.selectedWallet,
  });
}

class FetchMemberAssetsSuccess extends MainWalletState {
  final List<HederaToken> assets;
  const FetchMemberAssetsSuccess(
    this.assets, {
    required super.mainWalletList,
    required super.selectedWallet,
  });
}

class FetchMemberAssetsFailed extends MainWalletState {
  final String message;
  const FetchMemberAssetsFailed(
    this.message, {
    required super.mainWalletList,
    required super.selectedWallet,
  });
}

class SubmitMemberWalletSuccess extends MainWalletState {
  const SubmitMemberWalletSuccess({
    required super.mainWalletList,
    required super.selectedWallet,
  });
}

class SubmitMemberWalletFailed extends MainWalletState {
  final String message;
  const SubmitMemberWalletFailed(
    this.message, {
    required super.mainWalletList,
    required super.selectedWallet,
  });
}
