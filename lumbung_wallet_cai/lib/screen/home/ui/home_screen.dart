part of '../home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseStateful<HomeScreen> {
  final CustomPopupMenuController _controller = CustomPopupMenuController();

  Future<void> onRefresh() async {
    context.read<SubWalletCubit>().getSubWallet();
    context.read<MemberWalletCubit>().fetchAllMemberWallet();

    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  void initState() {
    onRefresh();
    super.initState();
  }

  @override
  Widget body() {
    return MultiBlocListener(
      listeners: [
        authListener(),
        mainWalletListener(),
        subWalletListener(),
      ],
      child: BaseCaiScreen(
        sidebarWidget: BlocBuilder<SidebarBloc, SidebarState>(
          builder: (context, state) {
            return SideBarListWidget(
              controller: _controller,
            );
          },
        ),
        isMobile: CustomFunctions.isMobile(context),
        mainWidget: BlocBuilder<MainScreenBloc, MainScreenState>(
          builder: (context, mainState) {
            if (mainState.currentScreen == MainScreenType.mainWalletDetail) {
              return const MainWalletChatScreen();
            } else if (mainState.currentScreen ==
                MainScreenType.subWalletDetail) {
              return const SubWalletChatScreen();
            }

            return Container();
          },
        ),
      ),
    );
  }

  BlocListener<AuthBloc, AuthState> authListener() {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          loading = LoadingUtil.build(context);
          loading?.show();
        } else {
          loading?.dismiss();
        }
        // Log.setLog(state.toString(), method: "LoginScreen");
        if (state is LogoutSuccess) {
          Router.neglect(
            context,
            () => context.go(
              Routes.login,
            ),
          );
        }

        if (state is LogoutFailure) {
          showSnackBar(state.error ?? "", isError: true);
        }
      },
    );
  }

  BlocListener<MemberWalletCubit, MemberWalletState> mainWalletListener() {
    return BlocListener<MemberWalletCubit, MemberWalletState>(
      listener: (context, state) {
        if (state is SubmitMemberLoading) {
          loading = LoadingUtil.build(context);
          loading?.show();
        } else {
          loading?.dismiss();
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
        if (state is SubWalletLoading) {
          loading = LoadingUtil.build(context);
          loading?.show();
        } else {
          loading?.dismiss();
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
