part of 'member_wallet_cubit.dart';

@immutable
abstract class MemberWalletState extends Equatable {
  final List<HederaWallet> memberWalletList;
  final HederaWallet? selectedWallet;

  const MemberWalletState({
    required this.memberWalletList,
    required this.selectedWallet,
  });

  @override
  List<Object?> get props => [memberWalletList, selectedWallet];
}

class MemberWalletInitial extends MemberWalletState {
  MemberWalletInitial() : super(memberWalletList: [],selectedWallet:null);
}

class MemberWalletLoading extends MemberWalletState {
  const MemberWalletLoading({
    required super.memberWalletList,
    required super.selectedWallet,
  });
}

class MemberAssetLoading extends MemberWalletState {
  const MemberAssetLoading({
    required super.memberWalletList,
    required super.selectedWallet,
  });
}

class SubmitMemberLoading extends MemberWalletState {
  const SubmitMemberLoading({
    required super.memberWalletList,
    required super.selectedWallet,
  });
}

class FetchMemberWalletSuccess extends MemberWalletState {
  const FetchMemberWalletSuccess({
    required super.memberWalletList,
    required super.selectedWallet,
  });
}

class FetchMemberWalletFailed extends MemberWalletState {
  final String message;
  const FetchMemberWalletFailed(
    this.message, {
    required super.memberWalletList,
    required super.selectedWallet,
  });
}

class FetchMemberAssetsSuccess extends MemberWalletState {
  final List<HederaToken> assets;
  const FetchMemberAssetsSuccess(
    this.assets, {
    required super.memberWalletList,
    required super.selectedWallet,
  });
}

class FetchMemberAssetsFailed extends MemberWalletState {
  final String message;
  const FetchMemberAssetsFailed(
    this.message, {
    required super.memberWalletList,
    required super.selectedWallet,
  });
}

class SubmitMemberWalletSuccess extends MemberWalletState {
  const SubmitMemberWalletSuccess({
    required super.memberWalletList,
    required super.selectedWallet,
  });
}

class SubmitMemberWalletFailed extends MemberWalletState {
  final String message;
  const SubmitMemberWalletFailed(
    this.message, {
    required super.memberWalletList,
    required super.selectedWallet,
  });
}
