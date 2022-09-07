part of '../home.dart';

class BookChatScreen extends StatefulWidget {
  const BookChatScreen({Key? key}) : super(key: key);

  @override
  State<BookChatScreen> createState() => _BookChatScreenState();
}

class _BookChatScreenState extends BaseChatScreen<BookChatScreen> {
  @override
  Widget appBar() {
    return Builder(
      builder: (context) {
        final selectedData =
            context.select((BookCubit element) => element.state.selectedBook);
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
                  "${selectedData?.title ?? "-"} (${selectedData?.topicId ?? "-"})",
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
        final selectedData =
            context.select((BookCubit element) => element.state.selectedBook);

        if (selectedData == null) {
          return unselectedChatWidget(context);
        }
        return child;
      },
    );
  }

  @override
  String currentChatId() {
    return context.read<BookCubit>().state.selectedBook?.id ?? "";
  }

  @override
  Widget detailContentsWidget() {
    return Builder(
      builder: (context) {
        final selectedData =
            context.select((BookCubit element) => element.state.selectedBook);

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
              "Topic ID : ${selectedData?.topicId ?? "-"}",
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
          FloatingButton(
            title: "Delete Book",
            icon: Icons.delete,
            onTap: () {
              showCustomDialog(
                title: "Delete Book",
                description: "Are you sure you want to delete this book?",
                onTap: () {
                  context.read<BookCubit>().deleteBook();
                },
              );
            },
          ),
          const SizedBox(
            height: 15,
          ),
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
            title: "Book Details",
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
