part of '../home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseStateful<HomeScreen> {
  Future<void> onRefresh() async {
    context.read<SubWalletCubit>().getSubWallet();

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
      ],
      child: BaseCaiScreen(
        sidebarWidget: BlocBuilder<SidebarBloc, SidebarState>(
          builder: (context, state) {
            return const SideBarListWidget();
          },
        ),
        isMobile: CustomFunctions.isMobile(context),
        mainWidget: BlocBuilder<MainScreenBloc, MainScreenState>(
          builder: (context, mainState) {
            return const ChatScreen();
          },
        ),
      ),
    );
  }

  BlocListener<AuthBloc, AuthState> authListener() {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          loading = LoadingUtil.build(context, dismissable: true);
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
}
