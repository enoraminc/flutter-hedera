part of '../home.dart';

class SideBarListWidget extends StatelessWidget {
  const SideBarListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final isDarkTheme = CustomFunctions.isDarkTheme(context);
      final user =
          context.select((AuthBloc element) => element.state.currentUser);

      ChatUser? currentUser;
      if (user != null) {
        currentUser = ChatUser(
          avatar: user.avatarUrl,
          name: user.displayName,
          uid: user.email,
        );
      }
      return Container(
        width: CustomFunctions.getMediaWidth(context) / 3,
        decoration: BoxDecoration(
          color: isDarkTheme ? AppColors.chatListDark : AppColors.kLightColor,
          border: (!CustomFunctions.isMobile(context))
              ? Border(
                  right: BorderSide(
                    width: 1,
                    color: Theme.of(context).appBarTheme.backgroundColor!,
                  ),
                )
              : null,
        ),
        child: Scaffold(
          floatingActionButton: Builder(
            builder: (context) {
              final user = context
                  .select((AuthBloc element) => element.state.currentUser);
              if (user?.isAdmin() ?? false) {
                return FloatingActionButton(
                  onPressed: () {
                    context.read<SubWalletCubit>().changeSelectedData(null);

                    context.push("${Routes.subWallet}/${Routes.set}");
                  },
                  child: const Icon(Icons.add),
                  backgroundColor: Colors.orange,
                );
              }
              return const SizedBox();
            },
          ),
          body: Column(
            children: [
              // HEADER
              header(context, currentUser),
              // Content
              Expanded(
                child: Builder(builder: (context) {
                  final isLoading = context.select((SubWalletCubit element) =>
                      element.state is SubWalletLoading);

                  final selectedData = context.select(
                      (SubWalletCubit element) =>
                          element.state.selectedSubWallet);

                  final subWalletList = context.select(
                      (SubWalletCubit element) => element.state.subWalletList);

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
                        data.id == selectedData?.id,
                    items: subWalletList,
                    itemTitle: (HederaSubWallet data) => data.title,
                    subTitle: (HederaSubWallet data) => data.description,
                    subTitle2: (HederaSubWallet data) =>
                        contentTagLabel(data, context),
                    leadingWidget: (HederaSubWallet data) =>
                        getLeadingIcon(data, context),
                    trailingWidget: (HederaSubWallet data) =>
                        const SizedBox(height: 5, width: 5),
                    onTapItem: (HederaSubWallet data) {
                      // context
                      //     .read<MainScreenBloc>()
                      //     .add(ToMainScreen(MainScreenType.groundDetail));

                      context.read<SubWalletCubit>().changeSelectedData(data);

                      context
                          .read<ChatMessageBloc>()
                          .add(LoadChatMessages(path: data.id, locale: ""));

                      if (CustomFunctions.isMobile(context)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const ChatScreen();
                            },
                          ),
                        );
                      }
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      );
    });
  }

  Container header(BuildContext context, ChatUser? currentUser) {
    return Container(
      height: 56.0,
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        border: Border(
          right: BorderSide(
            width: 1,
            color: Theme.of(context).appBarTheme.backgroundColor!,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            getUserProfileIcon(context, currentUser),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyText1,
                    text: FlavorConfig.instance.values.appName,
                    children: [
                      TextSpan(
                        text: "  ${FlavorConfig.instance.values.versionNumber}",
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15.0),
            if (CustomFunctions.isMobile(context))
              IconButton(
                icon: const Icon(
                  Icons.search,
                ),
                onPressed: () {},
              ),
            getPopupMenu(context),
          ],
        ),
      ),
    );
  }

  Widget getUserProfileIcon(BuildContext context, ChatUser? currentUer) {
    if (currentUer?.avatar?.isEmpty == false) {
      return CircleAvatar(
        radius: 18,
        backgroundImage: NetworkImage(currentUer?.avatar ?? ""),
        backgroundColor: Theme.of(context).primaryColor,
      );
    }
    return CircleAvatar(
      radius: 18,
      backgroundColor: Theme.of(context).primaryColor,
      child: Text(currentUer?.name?[0] ?? ""),
    );
  }

  Widget getPopupMenu(BuildContext context) {
    return BlocBuilder<SidebarBloc, SidebarState>(
      builder: (context, sidebarState) {
        return PopupMenuButton<int>(
          color: Theme.of(context).appBarTheme.backgroundColor,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 0,
              child: Row(
                children: <Widget>[
                  Icon(
                    CustomFunctions.isDarkTheme(context)
                        ? Icons.brightness_4
                        : Icons.brightness_2,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Text(
                    CustomFunctions.isDarkTheme(context)
                        ? "Light mode"
                        : "Dark mode",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 1,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.logout,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Text(
                    "Logout",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
          ],
          onSelected: (item) {
            if (item == 0) {
              ThemeMode? themeMode = EasyDynamicTheme.of(context).themeMode;
              if (themeMode == ThemeMode.dark) {
                EasyDynamicTheme.of(context).changeTheme(dark: false);
              } else {
                EasyDynamicTheme.of(context).changeTheme(dark: true);
              }
            } else if (item == 1) {
              context.read<AuthBloc>().add(const LogoutButtonPressed());
            }
          },
        );
      },
    );
  }

  Widget getLeadingIcon(HederaSubWallet data, BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: Theme.of(context).primaryColor,
      child: Text(
        (data.title[0]).toUpperCase(),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget contentTagLabel(HederaSubWallet data, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Wrap(
        spacing: 10,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 4,
                backgroundColor: Colors.green,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                data.state,
                style: Theme.of(context).textTheme.headline2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
