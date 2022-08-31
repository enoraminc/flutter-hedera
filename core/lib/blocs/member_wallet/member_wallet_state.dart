part of 'member_wallet_cubit.dart';

@immutable
abstract class MemberWalletState {
  final List<HederaWallet> memberWalletList;

  const MemberWalletState({
    required this.memberWalletList,
  });
}

class MemberWalletInitial extends MemberWalletState {
  MemberWalletInitial() : super(memberWalletList: []);
}

class MemberWalletLoading extends MemberWalletState {
  const MemberWalletLoading({
    required super.memberWalletList,
  });
}

class MemberAssetLoading extends MemberWalletState {
  const MemberAssetLoading({
    required super.memberWalletList,
  });
}

class SubmitMemberLoading extends MemberWalletState {
  const SubmitMemberLoading({
    required super.memberWalletList,
  });
}

class FetchMemberWalletSuccess extends MemberWalletState {
  const FetchMemberWalletSuccess({
    required super.memberWalletList,
  });
}

class FetchMemberWalletFailed extends MemberWalletState {
  final String message;
  const FetchMemberWalletFailed(
    this.message, {
    required super.memberWalletList,
  });
}

class FetchMemberAssetsSuccess extends MemberWalletState {
  final List<HederaToken> assets;
  const FetchMemberAssetsSuccess(
    this.assets, {
    required super.memberWalletList,
  });
}

class FetchMemberAssetsFailed extends MemberWalletState {
  final String message;
  const FetchMemberAssetsFailed(
    this.message, {
    required super.memberWalletList,
  });
}

class SubmitMemberWalletSuccess extends MemberWalletState {
  const SubmitMemberWalletSuccess({
    required super.memberWalletList,
  });
}

class SubmitMemberWalletFailed extends MemberWalletState {
  final String message;
  const SubmitMemberWalletFailed(
    this.message, {
    required super.memberWalletList,
  });
}
