part of '../auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends BaseStateful<SplashScreen> {
  @override
  void initState() {
    // navigate();
    super.initState();
  }

  // void navigate() async {
  //   await Future.delayed(const Duration(seconds: 1)).then(
  //     (value) => context.replace(
  //       Routes.login,
  //     ),
  //   );
  // }

  @override
  Widget body() {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          loading = LoadingUtil.build(context, dismissable: true);
          loading?.show();
        } else {
          loading?.dismiss();
        }
        // Log.setLog(state.toString(), method: "LoginScreen");
        if (state is UserAlreadyLoginSuccess) {
          context.go(
            Routes.home,
          );
        }

        if (state is SilentLoginFailure) {
          context.replace(
            Routes.login,
          );
        }

        // if (state is LoginFailure) {
        //   showSnackBar(state.error ?? "", isError: true);
        // }
      },
      child: Center(
        child: SizedBox(
          height: 350,
          width: 400,
          // child: Lottie.asset(
          //   'assets/lottie/loading.json',
          //   fit: BoxFit.fitWidth,
          //   repeat: true,
          // ),
        ),
      ),
    );
  }
}
