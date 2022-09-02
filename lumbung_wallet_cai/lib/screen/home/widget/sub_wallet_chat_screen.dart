part of '../home.dart';

class SubWalletChatScreen extends StatefulWidget {
  const SubWalletChatScreen({Key? key}) : super(key: key);

  @override
  State<SubWalletChatScreen> createState() => _SubWalletChatScreenState();
}

class _SubWalletChatScreenState extends BaseChatScreen<SubWalletChatScreen> {
  @override
  Widget appBar() {
    return Builder(
      builder: (context) {
        final selectedData = context.select(
            (SubWalletCubit element) => element.state.selectedSubWallet);
        return ChatMessageHeader(
          leadingWidget: CircleAvatar(
            radius: 18,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              selectedData?.title[0] ?? "-",
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
                  "${selectedData?.title ?? "-"} (${selectedData?.accountId ?? "-"})",
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
            selectedData?.description ?? "",
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
        final selectedData = context.select(
            (SubWalletCubit element) => element.state.selectedSubWallet);

        if (selectedData == null) {
          return unselectedChatWidget(context);
        }
        return child;
      },
    );
  }

  @override
  String currentChatId() {
    return context.read<SubWalletCubit>().state.selectedSubWallet?.id ?? "";
  }

  @override
  Widget detailContentsWidget() {
    return Builder(
      builder: (context) {
        final selectedData = context.select(
            (SubWalletCubit element) => element.state.selectedSubWallet);

        final walletSelectedList = selectedData?.users ?? [];
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedData?.title ?? "-",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              selectedData?.description ?? "-",
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
            Text(
              "Users List",
              style: Styles.commonTextStyle(
                size: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (walletSelectedList.isEmpty)
              Center(
                child: Text(
                  "Users is Empty",
                  textAlign: TextAlign.center,
                  style: Styles.commonTextStyle(
                    size: 16,
                  ),
                ),
              ),
            ...walletSelectedList
                .map(
                  (wallet) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).buttonColor,
                        width: 1.0,
                      ),
                    ),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          height: 20,
                          width: 5,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            wallet,
                            style: Styles.commonTextStyle(
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
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
      final selectedData = context
          .select((SubWalletCubit element) => element.state.selectedSubWallet);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (user?.isAdmin() ?? false) ...[
            FloatingButton(
              title: "Book",
              icon: Icons.book,
              onTap: () {
                context.push("${Routes.book}/${selectedData?.id ?? ""}");
              },
            ),
            const SizedBox(
              height: 15,
            ),
            FloatingButton(
              title: "Delete Sub Wallet",
              icon: Icons.delete,
              onTap: () {
                showCustomDialog(
                  title: "Delete Sub Wallet",
                  description:
                      "Are you sure you want to delete this sub wallet?",
                  onTap: () {
                    context.read<SubWalletCubit>().deleteSubWallet();
                  },
                );
              },
            ),
            const SizedBox(
              height: 15,
            ),
            FloatingButton(
              title: "Edit Sub Wallet",
              icon: Icons.edit,
              onTap: () {
                context.push("${Routes.subWallet}/${Routes.set}");
              },
            ),
            const SizedBox(
              height: 15,
            ),
          ],
          FloatingButton(
            title: "Sub Wallet Details",
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
  Widget getCustomMessageChatWidget(String msgType) {
    return Container();
  }
}
