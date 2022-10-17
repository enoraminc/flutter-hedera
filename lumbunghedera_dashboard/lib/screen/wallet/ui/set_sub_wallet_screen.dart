part of '../wallet.dart';

class SetSubWalletScreen extends StatefulWidget {
  const SetSubWalletScreen({Key? key}) : super(key: key);

  @override
  State<SetSubWalletScreen> createState() => _SetSubWalletScreenState();
}

class _SetSubWalletScreenState extends BaseStateful<SetSubWalletScreen> {
  final _formKey = GlobalKey<FormState>();

  Future<void> onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String typeSelected = "";

  HederaWallet? activeWallet;

  List<HederaWallet> walletSelectedList = [];

  void onSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    HederaSubWallet? subWallet =
        context.read<SubWalletCubit>().state.selectedSubWallet ??
            HederaSubWallet.empty();

    subWallet = subWallet.copyWith(
      title: titleController.text,
      description: descriptionController.text,
      users: walletSelectedList.map((e) => e.email).toList(),
      userList: walletSelectedList
          .map((e) => UserData(
                name: e.displayName,
                email: e.email,
                avatarUrl: e.profileImage,
              ))
          .toList(),
      type: typeSelected,
    );

    context.read<SubWalletCubit>().setSubWallet(subWallet);
  }

  @override
  void initState() {
    final selectedData = context.read<SubWalletCubit>().state.selectedSubWallet;
    titleController.text = selectedData?.title ?? "";
    descriptionController.text = selectedData?.description ?? "";
    typeSelected = selectedData?.type ?? "";
    walletSelectedList = List<HederaWallet>.from(
        (selectedData?.userList ?? []).map((e) => HederaWallet.empty().copyWith(
              email: e.email,
              displayName: e.name,
              profileImage: e.avatarUrl,
            )));

    super.initState();
  }

  @override
  Widget body() {
    return BlocListener<SubWalletCubit, SubWalletState>(
      listener: (context, state) {
        if (state is SubWalletSubmitLoading) {
          loading = LoadingUtil.build(context);
          loading?.show();
        } else {
          loading?.dismiss();
        }

        if (state is SubWalletSubmitSuccess) {
          context.pop();
        } else if (state is SubWalletFailed) {
          showSnackBar(state.message, isError: true);
        }
      },
      child: Form(
        key: _formKey,
        child: BaseScreen(
          onRefresh: onRefresh,
          appBar: _appBar(),
          children: [
            const SizedBox(height: 10),
            titleField(),
            const SizedBox(height: 15),
            descriptionField(),
            const SizedBox(height: 15),
            bookTypeField(),
            const SizedBox(height: 15),
            memberSelectorWidget(),
            const SizedBox(height: 20),
            // messageListWidget(),
          ],
        ),
      ),
    );
  }

  Widget bookTypeField() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SubWalletTypeSelectorWidget(
        onChange: (String? type) {
          setState(() {
            if (type?.isNotEmpty ?? false) {
              typeSelected = type ?? "";
            }
          });
        },
        selectedType: typeSelected,
      ),
    );
  }

  Builder memberSelectorWidget() {
    return Builder(
      builder: (context) {
        final memberWalletList = context
            .select((MainWalletCubit element) => element.state.mainWalletList);

        final isLoading = context.select(
            (MainWalletCubit element) => element.state is MemberWalletLoading);

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Add User to Sub Wallet",
                style: Styles.commonTextStyle(
                  size: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (isLoading)
                const CircularProgressIndicator()
              else
                Row(
                  children: [
                    Expanded(
                      child: MainWalletSelector(
                        activeWallet: activeWallet,
                        memberWalletList: memberWalletList
                            .where((element) => !walletSelectedList
                                .map((e) => e.email)
                                .toList()
                                .contains(element.email))
                            .toList(),
                        onChange: (wallet) {
                          setState(() {
                            activeWallet = wallet;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    RoundedButton(
                      text: "",
                      selected: true,
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      selectedColor: Colors.orange,
                      onPressed: () {
                        setState(() {
                          if (activeWallet != null) {
                            walletSelectedList.add(activeWallet!);
                          }
                          activeWallet = null;
                        });
                      },
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              Text(
                "Selected User List",
                style: Styles.commonTextStyle(
                  size: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (walletSelectedList.isEmpty)
                Center(
                  child: Text(
                    "Selected User is Empty",
                    textAlign: TextAlign.center,
                    style: Styles.commonTextStyle(
                      size: 16,
                    ),
                  ),
                ),
              ...walletSelectedList
                  .map(
                    (wallet) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                          width: 1.0,
                        ),
                      ),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            height: 20,
                            width: 5,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              wallet.email,
                              style: Styles.commonTextStyle(
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              setState(() {
                                walletSelectedList.removeWhere(
                                    (element) => element.email == wallet.email);
                              });
                            },
                            child: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        );
      },
    );
  }

  Widget titleField() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: CustomTextFormField(
        controller: titleController,
        text: "Name",
        keyboardType: TextInputType.text,
        hint: "Name..",
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

  Widget descriptionField() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: CustomTextField(
        controller: descriptionController,
        text: "Description",
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        hint: "Description..",
        onChanged: (value) {},
      ),
    );
  }

  Widget _appBar() {
    return Builder(builder: (context) {
      final selectedData = context
          .select((SubWalletCubit element) => element.state.selectedSubWallet);
      return CustomSecondAppBar(
        title: selectedData != null ? "Edit Sub Wallet" : "Create Sub Wallet",
        onActionTap: onSave,
      );
    });
  }
}
