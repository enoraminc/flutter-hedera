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
    context.read<AuthBloc>().add(const SilentLogin());
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
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            loading = LoadingUtil.build(context, dismissable: true);
            loading?.show();
          } else {
            loading?.dismiss();
          }
          // Log.setLog(state.toString(), method: "LoginScreen");
          if (state is UserAlreadyLoginSuccess) {
            Router.neglect(
              context,
              () => context.go(
                Routes.home,
              ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: 350,
                width: 400,
                child: Lottie.asset(
                  'assets/lottie/loading.json',
                  fit: BoxFit.fitWidth,
                  repeat: true,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Text(
              FlavorConfig.instance.values.appName,
              textAlign: TextAlign.center,
              style: Styles.commonTextStyle(
                size: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "v${FlavorConfig.instance.values.versionNumber}",
              textAlign: TextAlign.center,
              style: Styles.commonTextStyle(
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
