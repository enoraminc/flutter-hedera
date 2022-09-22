part of '../sub_wallet.dart';

class SubWalletSidebarListWidget extends StatelessWidget {
  const SubWalletSidebarListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      // Sub Wallet
      final isLoading = context.select(
          (SubWalletCubit element) => element.state is SubWalletLoading);

      final selectedSubWallet = context
          .select((SubWalletCubit element) => element.state.selectedSubWallet);

      final subWalletList = context
          .select((SubWalletCubit element) => element.state.subWalletList);

      if (isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (subWalletList.isEmpty) {
        return const Center(
          child: Text('Item is Empty'),
        );
      }

      return ChatItemScreen<HederaSubWallet>(
        isCurrentSelected: (HederaSubWallet data) =>
            data.id == selectedSubWallet?.id,
        items: subWalletList,
        itemTitle: (HederaSubWallet data) => data.title,
        subTitle: (HederaSubWallet data) => data.description,
        subTitle2: (HederaSubWallet data) =>
            ContentTagLabelWidget(title: data.accountId),
        leadingWidget: (HederaSubWallet data) =>
            LeadingIconWidget(title: data.title),
        trailingWidget: (HederaSubWallet data) =>
            const SizedBox(height: 5, width: 5),
        onTapItem: (HederaSubWallet data) {
          context.read<SubWalletCubit>().changeSelectedData(data);

          context
              .read<ChatMessageBloc>()
              .add(LoadChatMessages(path: data.id, locale: ""));

          if (CustomFunctions.isMobile(context)) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const SubWalletChatScreen();
                },
              ),
            );
          }
        },
      );
    });
  }
}
