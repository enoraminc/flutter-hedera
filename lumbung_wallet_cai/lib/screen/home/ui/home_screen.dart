part of '../home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseStateful<HomeScreen> {
  @override
  Widget body() {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              loading = LoadingUtil.build(context, dismissable: true);
              loading?.show();
            } else {
              loading?.dismiss();
            }
            // Log.setLog(state.toString(), method: "LoginScreen");
            if (state is LogoutSuccess) {
              context.go(
                Routes.login,
              );
            }

            if (state is LogoutFailure) {
              showSnackBar(state.error ?? "", isError: true);
            }
          },
        ),
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
}
