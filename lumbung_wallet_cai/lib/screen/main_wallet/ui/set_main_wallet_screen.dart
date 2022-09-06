part of '../main_wallet.dart';

class SetMainWalletScreen extends StatefulWidget {
  const SetMainWalletScreen({Key? key}) : super(key: key);

  @override
  State<SetMainWalletScreen> createState() => _SetMainWalletScreenState();
}

class _SetMainWalletScreenState extends BaseStateful<SetMainWalletScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void onSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    HederaWallet? wallet =
        context.read<MemberWalletCubit>().state.selectedWallet ??
            HederaWallet.empty();

    wallet = wallet.copyWith(
      displayName: nameController.text,
      email: emailController.text.toLowerCase(),
    );

    context.read<MemberWalletCubit>().setMainWallet(wallet);
  }

  @override
  void initState() {
    final selectedData = context.read<MemberWalletCubit>().state.selectedWallet;
    nameController.text = selectedData?.displayName ?? "";
    emailController.text = selectedData?.email ?? "";

    super.initState();
  }

  @override
  Widget body() {
    return BlocListener<MemberWalletCubit, MemberWalletState>(
      listener: (context, state) {
        if (state is SubmitMemberLoading) {
          loading = LoadingUtil.build(context);
          loading?.show();
        } else {
          loading?.dismiss();
        }

        if (state is SubmitMemberWalletSuccess) {
          context.pop();
        } else if (state is SubmitMemberWalletFailed) {
          showSnackBar(state.message, isError: true);
        }
      },
      child: BaseCaiScreen(
        mainWidget: Form(
          key: _formKey,
          child: Container(
            color: Theme.of(context).backgroundColor,
            width: CustomFunctions.isMobile(context)
                ? MediaQuery.of(context).size.width
                : 650,
            child: ListView(
              physics: const ClampingScrollPhysics(),
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bodyHeader(),
                const SizedBox(height: 16),
                nameField(),
                const SizedBox(height: 15),
                emailField(),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget nameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: CustomTextFormField(
        controller: nameController,
        text: "Name",
        keyboardType: TextInputType.text,
        hint: "name..",
        onChanged: (value) {},
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Name field is required';
          }

          return null;
        },
      ),
    );
  }

  Widget emailField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: CustomTextFormField(
        controller: emailController,
        text: "Email",
        keyboardType: TextInputType.emailAddress,
        hint: "Email..",
        onChanged: (value) {},
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Email field is required';
          }

          if (!value.isValidEmail()) {
            return "Email is not valid";
          }

          return null;
        },
      ),
    );
  }

  Widget _bodyHeader() {
    return Builder(builder: (context) {
      final selectedData = context
          .select((MemberWalletCubit element) => element.state.selectedWallet);
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
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
                color: Theme.of(context).textSelectionTheme.cursorColor,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      text: selectedData != null
                          ? "Edit Main Wallet"
                          : "Create Main Wallet",
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15.0),
              SizedBox(
                height: 50,
                width: 100,
                child: RoundedButton(
                  text: "Save",
                  onPressed: onSave,
                  selected: true,
                  selectedColor: Colors.orange,
                  isSmall: true,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
