part of '../home.dart';

class MainWalletChatScreen extends StatefulWidget {
  const MainWalletChatScreen({Key? key}) : super(key: key);

  @override
  State<MainWalletChatScreen> createState() => _MainWalletChatScreenState();
}

class _MainWalletChatScreenState extends BaseChatScreen<MainWalletChatScreen> {
  @override
  Widget appBar() {
    return Builder(
      builder: (context) {
        final selectedData = context
            .select((MainWalletCubit element) => element.state.selectedWallet);
        return ChatMessageHeader(
          leadingWidget: CircleAvatar(
            radius: 18,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              selectedData?.displayName[0] ?? "-",
              style: const TextStyle(fontSize: 20),
            ),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  "${selectedData?.displayName ?? "-"} (${selectedData?.accountId ?? "-"})",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          subTitle: Text(
            selectedData?.email ?? "",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          actions: [
            // RoundedButton(
            //   text: "Explore",
            //   isSmall: true,
            //   selected: true,
            //   onPressed: () {
            //     launchUrlString(
            //         "https://app.dragonglass.me/hedera/accounts/${selectedData?.accountId ?? "0"}");
            //   },
            // ),
          ],
        );
      },
    );
  }

  @override
  Builder builder({required Widget child}) {
    return Builder(
      builder: (context) {
        final selectedData = context
            .select((MainWalletCubit element) => element.state.selectedWallet);

        if (selectedData == null) {
          return unselectedChatWidget(context);
        }
        return child;
      },
    );
  }

  @override
  String currentChatId() {
    return context.read<MainWalletCubit>().state.selectedWallet?.id ?? "";
  }

  @override
  Widget detailContentsWidget() {
    return Builder(
      builder: (context) {
        final selectedData = context
            .select((MainWalletCubit element) => element.state.selectedWallet);

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedData?.displayName ?? "-",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              selectedData?.email ?? "-",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Account ID : ${selectedData?.accountId ?? "-"}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  @override
  Widget floatingActionsWidget() {
    return Builder(builder: (context) {
      final user =
          context.select((AuthBloc element) => element.state.currentUser);

      // if (ground == null) return const SizedBox();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // FloatingButton(
          //   title: "Delete Sub Wallet",
          //   icon: Icons.delete,
          //   onTap: () {
          //     showCustomDialog(
          //       title: "Delete Sub Wallet",
          //       description: "Are you sure you want to delete this sub wallet?",
          //       onTap: () {
          //         context.read<SubWalletCubit>().deleteSubWallet();
          //       },
          //     );
          //   },
          // ),
          // const SizedBox(
          //   height: 15,
          // ),
          // FloatingButton(
          //   title: "Edit Sub Wallet",
          //   icon: Icons.edit,
          //   onTap: () {
          //     context.push("${Routes.subWallet}/${Routes.set}");
          //   },
          // ),
          // const SizedBox(
          //   height: 15,
          // ),
          FloatingButton(
            title: "Main Wallet Details",
            icon: Icons.info,
            onTap: () {
              showDetailContent();
            },
          ),
        ],
      );
    });
  }

  @override
  ChatUser? getUser() {
    final user = context.read<AuthBloc>().state.currentUser;

    return ChatUser(
      avatar: user?.avatarUrl,
      name: user?.displayName,
      uid: user?.email,
    );
  }

  @override
  Future<String?> uploadMediaMessage(Uint8List data,
      [String extension = "png"]) async {
    String fileUrl = await StorageUtils.uploadMediaMessage(data, extension);

    return fileUrl;
  }

  @override
  Widget getCustomMessageChatWidget(String msgType,ChatMessage message) {
    return Container();
  }
}
