part of '../wallet.dart';

class SetMainWalletScreen extends StatefulWidget {
  const SetMainWalletScreen({Key? key}) : super(key: key);

  @override
  State<SetMainWalletScreen> createState() => _SetMainWalletScreenState();
}

class _SetMainWalletScreenState extends BaseStateful<SetMainWalletScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Future<void> onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  void onSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    HederaWallet? wallet =
        context.read<MainWalletCubit>().state.selectedWallet ??
            HederaWallet.empty();

    wallet = wallet.copyWith(
      displayName: nameController.text,
      email: emailController.text.toLowerCase(),
    );

    // context.read<MainWalletCubit>().setMainWallet(wallet);

    // Use Job Request
    final jobReq = JobRequestModel(
      type: JobRequestModel.walletType,
      data: wallet.toJobReqMap(),
      users: [
        wallet.email,
      ],
      id: 0,
      topicId: "",
      state: "",
      message: "",
      network: "",
    );
    context.read<JobCubit>().submitJobRequestSuccess(jobReq);
  }

  @override
  void initState() {
    final selectedData = context.read<MainWalletCubit>().state.selectedWallet;
    nameController.text = selectedData?.displayName ?? "";
    emailController.text = selectedData?.email ?? "";

    super.initState();
  }

  @override
  Widget body() {
    return MultiBlocListener(
      listeners: [
        mainWalletListener(),
        jobListener(),
      ],
      child: Form(
        key: _formKey,
        child: BaseScreen(
          onRefresh: onRefresh,
          appBar: _appBar(),
          children: [
            const SizedBox(height: 10),
            nameField(),
            const SizedBox(height: 15),
            emailField(),
            const SizedBox(height: 20),
            // messageListWidget(),
          ],
        ),
      ),
    );
  }

  Widget nameField() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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

  Widget _appBar() {
    return Builder(builder: (context) {
      final selectedData = context
          .select((MainWalletCubit element) => element.state.selectedWallet);

      return CustomSecondAppBar(
        title: selectedData != null ? "Edit Main Wallet" : "Create Main Wallet",
        onActionTap: onSave,
      );
    });
  }

  BlocListener<JobCubit, JobState> jobListener() {
    return BlocListener<JobCubit, JobState>(
      listener: (context, state) {
        if (state is SubmitJobLoading) {
          loading = LoadingUtil.build(context);
          loading?.show();
        } else {
          loading?.dismiss();
        }

        if (state is SubmitJobRequestSuccess) {
          showSnackBar(
              "Succesfully submit new job request for create new wallet. Please wait..");

          context.pop();
        } else if (state is JobFailed) {
          showSnackBar(state.message, isError: true);
        }
      },
    );
  }

  BlocListener<MainWalletCubit, MainWalletState> mainWalletListener() {
    return BlocListener<MainWalletCubit, MainWalletState>(
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
    );
  }
}
