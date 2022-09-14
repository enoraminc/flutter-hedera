part of '../home.dart';

class SideBarListWidget extends StatelessWidget {
  const SideBarListWidget({Key? key, required this.controller})
      : super(key: key);

  final CustomPopupMenuController controller;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Builder(builder: (context) {
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
            floatingActionButton: createButtonWidget(),
            body: Column(
              children: [
                // HEADER
                header(context, currentUser),
                // Tab
                tabBarWidget(context),
                // Content
                Expanded(
                  child: itemList(),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Builder createButtonWidget() {
    return Builder(
      builder: (context) {
        final user =
            context.select((AuthBloc element) => element.state.currentUser);
        if (user?.isAdmin() ?? false) {
          return CustomPopupMenu(
            menuBuilder: () => Builder(builder: (context) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  padding: const EdgeInsets.all(20),
                  width: 300,
                  // height: 300,
                  child: Column(
                    children: [
                      ListTile(
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.orange,
                        ),
                        title: Text(
                          'Create Main Wallet',
                          style: Styles.commonTextStyle(
                            size: 18,
                          ),
                        ),
                        onTap: () {
                          controller.hideMenu();
                          context
                              .read<MainWalletCubit>()
                              .changeSelectedData(null);

                          context.push("${Routes.mainWallet}/${Routes.set}");
                        },
                      ),
                      const SizedBox(height: 5),
                      const Divider(
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 5),
                      ListTile(
                        title: Text(
                          'Create Sub Wallet',
                          style: Styles.commonTextStyle(
                            size: 18,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.orange,
                        ),
                        onTap: () {
                          controller.hideMenu();
                          context
                              .read<SubWalletCubit>()
                              .changeSelectedData(null);

                          context.push("${Routes.subWallet}/${Routes.set}");
                        },
                      ),
                      const SizedBox(height: 5),
                      const Divider(
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 5),
                      ListTile(
                        title: Text(
                          'Creat Book',
                          style: Styles.commonTextStyle(
                            size: 18,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.orange,
                        ),
                        onTap: () {
                          controller.hideMenu();
                          context
                              .read<SubWalletCubit>()
                              .changeSelectedData(null);

                          context.push("${Routes.book}/${Routes.set}");
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
            pressType: PressType.singleClick,
            verticalMargin: -5,
            controller: controller,
            position: PreferredPosition.top,
            barrierColor: Colors.black.withOpacity(.7),
            child: const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.orange,
              child: Icon(
                Icons.add,
              ),
            ),
          );
          // return FloatingActionButton(
          //   onPressed: () {
          //     context.read<SubWalletCubit>().changeSelectedData(null);

          //     context.push("${Routes.subWallet}/${Routes.set}");
          //   },
          //   backgroundColor: Colors.orange,
          //   child: const Icon(Icons.add),
          // );
        }

        return const SizedBox();
      },
    );
  }

  Builder itemList() {
    return Builder(builder: (context) {
      final mainScreenType = context
          .select((MainScreenBloc element) => element.state.currentScreen);

      if (mainScreenType == MainScreenType.mainWalletDetail) {
        return const MainWalletSidebarListWidget();
      } else if (mainScreenType == MainScreenType.subWalletDetail) {
        return const SubWalletSidebarListWidget();
      } else if (mainScreenType == MainScreenType.bookDetail) {
        return const BookSidebarListWidget();
      }
      return const SizedBox();
    });
  }

  Container tabBarWidget(BuildContext context) {
    return Container(
      height: 50.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        border: Border(
          right: BorderSide(
            width: 1,
            color: Theme.of(context).appBarTheme.backgroundColor!,
          ),
        ),
      ),
      child: TabBar(
        tabs: const [
          Tab(
            text: "Main Wallet",
          ),
          Tab(
            text: "Sub Wallet",
          ),
          Tab(
            text: "Book",
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            context
                .read<MainScreenBloc>()
                .add(ToMainScreen(MainScreenType.mainWalletDetail));
          } else if (index == 1) {
            context
                .read<MainScreenBloc>()
                .add(ToMainScreen(MainScreenType.subWalletDetail));
          } else {
            context
                .read<MainScreenBloc>()
                .add(ToMainScreen(MainScreenType.bookDetail));
          }

          context.read<SubWalletCubit>().changeSelectedData(null);
          context.read<MainWalletCubit>().changeSelectedData(null);
          context.read<JournalCubit>().changeSelectedData(null);
        },
      ),
    );
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
            // if (CustomFunctions.isMobile(context))
            // IconButton(
            //   icon: const Icon(
            //     Icons.search,
            //   ),
            //   onPressed: () {},
            // ),
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
}
