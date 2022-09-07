part of '../main_wallet.dart';

class MainWalletSidebarListWidget extends StatelessWidget {
  const MainWalletSidebarListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      // Sub Wallet
      final isLoading = context.select(
          (MemberWalletCubit element) => element.state is MemberWalletLoading);

      final selectedMainWallet = context
          .select((MemberWalletCubit element) => element.state.selectedWallet);

      final mainWalletList = context.select(
          (MemberWalletCubit element) => element.state.memberWalletList);

      if (isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (mainWalletList.isEmpty) {
        return const Center(
          child: Text('Item is Empty'),
        );
      }

      return ChatItemScreen<HederaWallet>(
        isCurrentSelected: (HederaWallet data) =>
            data.id == selectedMainWallet?.id,
        items: mainWalletList,
        itemTitle: (HederaWallet data) => data.displayName,
        subTitle: (HederaWallet data) => data.email,
        subTitle2: (HederaWallet data) =>
            ContentTagLabelWidget(title: data.accountId),
        leadingWidget: (HederaWallet data) =>
            LeadingIconWidget(title: data.displayName),
        trailingWidget: (HederaWallet data) =>
            const SizedBox(height: 5, width: 5),
        onTapItem: (HederaWallet data) {
          context.read<MemberWalletCubit>().changeSelectedData(data);

          context
              .read<ChatMessageBloc>()
              .add(LoadChatMessages(path: data.id, locale: ""));

          if (CustomFunctions.isMobile(context)) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const MainWalletChatScreen();
                },
              ),
            );
          }
        },
      );
    });
  }
}
