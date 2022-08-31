part of 'sub_wallet_cubit.dart';

@immutable
abstract class SubWalletState extends Equatable {
  final HederaSubWallet? selectedSubWallet;
  final List<HederaSubWallet> subWalletList;

  const SubWalletState({
    required this.selectedSubWallet,
    required this.subWalletList,
  });

  @override
  List<Object?> get props => [selectedSubWallet, subWalletList];
}

class SubWalletInitial extends SubWalletState {
  SubWalletInitial() : super(selectedSubWallet: null, subWalletList: []);
}

class SubWalletLoading extends SubWalletState {
  const SubWalletLoading({
    required super.selectedSubWallet,
    required super.subWalletList,
  });
}

class SubWalletSubmitLoading extends SubWalletState {
  const SubWalletSubmitLoading({
    required super.selectedSubWallet,
    required super.subWalletList,
  });
}

class SubWalletFetchSuccess extends SubWalletState {
  const SubWalletFetchSuccess({
    required super.selectedSubWallet,
    required super.subWalletList,
  });
}

class SubWalletSubmitSuccess extends SubWalletState {
  const SubWalletSubmitSuccess({
    required super.selectedSubWallet,
    required super.subWalletList,
  });
}

class SubWalletFailed extends SubWalletState {
  final String message;
  const SubWalletFailed({
    required this.message,
    required super.selectedSubWallet,
    required super.subWalletList,
  });
}
