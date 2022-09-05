part of '../auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseStateful<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

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
          if (state is LoginSuccess || state is UserAlreadyLoginSuccess) {
            Router.neglect(
              context,
              () => context.go(
                Routes.dashboard,
              ),
            );
          }

          if (state is LoginFailure) {
            showSnackBar(state.error ?? "", isError: true);
          }
        },
        child: Center(
          child: Container(
            width: CustomFunctions.isMobile(context) ? double.infinity : 600,
            padding: EdgeInsets.only(left: 18, right: 18),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Expanded(
                  flex: 3,
                  child: Lottie.asset(
                    'assets/lottie/login.json',
                    repeat: true,
                  ),
                ),
                // Text(
                //   'Silahkan masuk terlebih dahulu untuk memulai lumbung village',
                //   style: Styles.commonTextStyle(
                //     size: 18,
                //     fontWeight: FontWeight.w400,
                //     color: Colors.grey,
                //   ),
                // ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: RoundedButton(
                    text: "Masuk dengan Google",
                    selected: true,
                    icon: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Image(
                        height: 24,
                        color: Colors.white,
                        image: AssetImage(
                          'assets/logo/google.png',
                        ),
                      ),
                    ),
                    onPressed: () {
                      context.read<AuthBloc>().add(const LoginWithGoogle());
                    },
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
