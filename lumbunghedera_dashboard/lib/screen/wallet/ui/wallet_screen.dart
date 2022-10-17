part of '../wallet.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({
    super.key,
    required this.type,
    required this.id,
  });

  final String? type;
  final String? id;

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends BaseStateful<WalletScreen> {
  final CustomPopupMenuController _controller = CustomPopupMenuController();

  String? typeWallet;
  String? selectedWalletId;

  Future<void> onRefresh() async {
    if (typeWallet == Routes.mainWallet) {
      context.read<MainWalletCubit>().fetchMainWallet();
    } else if (typeWallet == Routes.subWallet) {
      context.read<SubWalletCubit>().fetchSubWallet();
    }

    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  void initState() {
    selectedWalletId = widget.id;
    typeWallet = widget.type;
    onRefresh();
    super.initState();
  }

  @override
  Widget body() {
    return MultiBlocListener(
      listeners: [
        subWalletListener(),
        mainWalletListener(),
      ],
      child: Builder(builder: (context) {
        bool isLoading = false;

        if (typeWallet == Routes.mainWallet) {
          isLoading = context.select((MainWalletCubit element) =>
              element.state is MemberWalletLoading);
        } else if (typeWallet == Routes.subWallet) {
          isLoading = context.select(
              (SubWalletCubit element) => element.state is SubWalletLoading);
        }

        final mainWalletList = context
            .select((MainWalletCubit element) => element.state.mainWalletList);

        final subWalletList = context
            .select((SubWalletCubit element) => element.state.subWalletList);

        return DefaultTabController(
          length: 2,
          initialIndex: typeWallet == Routes.mainWallet ? 0 : 1,
          child: BaseScreen2(
            selectedId: selectedWalletId,
            onRefresh: onRefresh,
            appBar: const CustomAppBar(),
            bottomNavBar: const SizedBox(),
            tabWidget: tabWidget(),
            isLoading: isLoading,
            customButton: createButtonWidget(),
            onBack: () {
              setState(() {
                selectedWalletId = null;
              });
              context.read<SubWalletCubit>().changeSelectedData(null);
            },
            sidebarChildren: typeWallet == Routes.mainWallet
                ? mainWalletSidebarListWidget(mainWalletList)
                : typeWallet == Routes.subWallet
                    ? subWalletSidebarListWidget(subWalletList)
                    : [],
            //  sidebarListWidget(bookList),
            mainChild: typeWallet == Routes.mainWallet
                ? mainWalletInfoWidget()
                : typeWallet == Routes.subWallet
                    ? subWalletInfoWidget()
                    : const SizedBox(),
          ),
        );
      }),
    );
  }

  Widget tabWidget() {
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
        indicatorColor: Colors.orange,
        tabs: const [
          Tab(
            text: "Main Wallet",
          ),
          Tab(
            text: "Sub Wallet",
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            setState(() {
              typeWallet = Routes.mainWallet;
            });
            Router.neglect(
              context,
              () => context.go("${Routes.wallet}/${Routes.mainWallet}"),
            );
          } else if (index == 1) {
            setState(() {
              typeWallet = Routes.subWallet;
            });
            Router.neglect(
              context,
              () => context.go("${Routes.wallet}/${Routes.subWallet}"),
            );
          }
          onRefresh();
        },
      ),
    );
  }

  List<Widget> mainWalletSidebarListWidget(List<HederaWallet> walletList) {
    return walletList
        .map(
          (wallet) => InkWell(
            onTap: () {
              setState(() {
                selectedWalletId = wallet.accountId;
              });
              Router.neglect(
                context,
                () => context
                    .go("${Routes.wallet}/$typeWallet?id=$selectedWalletId"),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              margin: const EdgeInsets.only(
                bottom: 10,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
                borderRadius: BorderRadius.circular(5),
                gradient: selectedWalletId == wallet.accountId
                    ? LinearGradient(
                        stops: const [0.02, 0.02],
                        colors: [
                          Colors.orange,
                          Theme.of(context).appBarTheme.backgroundColor!
                        ],
                      )
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wallet.displayName,
                    style: Styles.commonTextStyle(
                      size: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    wallet.email,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Styles.commonTextStyle(
                      size: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Chip(
                    label: Text(
                      wallet.accountId,
                      style: Styles.commonTextStyle(
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.orange,
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  List<Widget> subWalletSidebarListWidget(List<HederaSubWallet> walletList) {
    return walletList
        .map(
          (wallet) => InkWell(
            onTap: () {
              setState(() {
                selectedWalletId = wallet.accountId;
              });
              context.read<SubWalletCubit>().changeSelectedData(wallet);
              Router.neglect(
                context,
                () => context
                    .go("${Routes.wallet}/$typeWallet?id=$selectedWalletId"),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              margin: const EdgeInsets.only(
                bottom: 10,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
                borderRadius: BorderRadius.circular(5),
                gradient: selectedWalletId == wallet.accountId
                    ? LinearGradient(
                        stops: const [0.02, 0.02],
                        colors: [
                          Colors.orange,
                          Theme.of(context).appBarTheme.backgroundColor!
                        ],
                      )
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wallet.title,
                    style: Styles.commonTextStyle(
                      size: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    wallet.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Styles.commonTextStyle(
                      size: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Chip(
                    label: Text(
                      wallet.type,
                      style: Styles.commonTextStyle(
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.orange,
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  Builder mainWalletInfoWidget() {
    return Builder(builder: (context) {
      // final isLoading = context.select(
      //     (MainWalletCubit element) => element.state is SubWalletLoading);

      final mainWalletSelected = context.select((MainWalletCubit element) =>
          element.state.mainWalletList.firstWhereOrNull(
              (element) => element.accountId == selectedWalletId));

      // final subWalletSelected = context.select((SubWalletCubit element) =>
      //     element.state.subWalletList.firstWhereOrNull((element) =>
      //         element.accountId == bookSelected?.subWalletId));

      if (mainWalletSelected == null) {
        return Center(
          child: Text(
            "No Item Selected",
            textAlign: TextAlign.center,
            style: Styles.commonTextStyle(
              size: 18,
            ),
          ),
        );
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  mainWalletSelected.displayName,
                  style: Styles.commonTextStyle(
                    size: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Chip(
                label: Text(
                  mainWalletSelected.accountId,
                  style: Styles.commonTextStyle(
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            mainWalletSelected.email,
            style: Styles.commonTextStyle(
              size: 14,
            ),
          ),
          const SizedBox(height: 10),
        ],
      );
    });
  }

  Builder subWalletInfoWidget() {
    return Builder(builder: (context) {
      // final isLoading = context.select(
      //     (SubWalletCubit element) => element.state is SubWalletLoading);

      final subWalletSelected = context.select((SubWalletCubit element) =>
          element.state.subWalletList.firstWhereOrNull(
              (element) => element.accountId == selectedWalletId));

      // final subWalletSelected = context.select((SubWalletCubit element) =>
      //     element.state.subWalletList.firstWhereOrNull((element) =>
      //         element.accountId == bookSelected?.subWalletId));

      if (subWalletSelected == null) {
        return Center(
          child: Text(
            "No Item Selected",
            textAlign: TextAlign.center,
            style: Styles.commonTextStyle(
              size: 18,
            ),
          ),
        );
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  subWalletSelected.title,
                  style: Styles.commonTextStyle(
                    size: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Chip(
                label: Text(
                  subWalletSelected.type,
                  style: Styles.commonTextStyle(
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subWalletSelected.description,
            style: Styles.commonTextStyle(
              size: 14,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Action",
                  style: Styles.commonTextStyle(
                    size: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              RoundedButton(
                text: "Edit",
                selected: true,
                isSmall: true,
                selectedColor: Colors.orange,
                onPressed: () {
                  context.push(
                      "${Routes.wallet}/${Routes.subWallet}/${Routes.set}");
                },
              ),
            ],
          ),
        ],
      );
    });
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
                          _controller.hideMenu();
                          context
                              .read<MainWalletCubit>()
                              .changeSelectedData(null);

                          context.push(
                              "${Routes.wallet}/${Routes.mainWallet}/${Routes.set}");
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
                          _controller.hideMenu();
                          context
                              .read<SubWalletCubit>()
                              .changeSelectedData(null);

                          context.push(
                              "${Routes.wallet}/${Routes.subWallet}/${Routes.set}");
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
            pressType: PressType.singleClick,
            verticalMargin: -5,
            controller: _controller,
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
        }

        return const SizedBox();
      },
    );
  }

  BlocListener<MainWalletCubit, MainWalletState> mainWalletListener() {
    return BlocListener<MainWalletCubit, MainWalletState>(
      listener: (context, state) {
        if (state is FetchMemberWalletFailed) {
          showSnackBar(state.message, isError: true);
        }
        if (state is SubmitMemberWalletSuccess) {
          onRefresh();
        }

        // if (state is SubWalletFailed) {
        //   showSnackBar(state.message, isError: true);
        // }
      },
    );
  }

  BlocListener<SubWalletCubit, SubWalletState> subWalletListener() {
    return BlocListener<SubWalletCubit, SubWalletState>(
      listener: (context, state) {
        if (state is SubWalletFailed) {
          showSnackBar(state.message, isError: true);
        }
        if (state is SubWalletDeleteSuccess ||
            state is SubWalletSubmitSuccess) {
          onRefresh();
        }

        if (state is SubWalletFailed) {
          showSnackBar(state.message, isError: true);
        }
      },
    );
  }
}
