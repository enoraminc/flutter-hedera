part of '../sub_wallet.dart';

class SetSubWalletScreen extends StatefulWidget {
  const SetSubWalletScreen({Key? key}) : super(key: key);

  @override
  State<SetSubWalletScreen> createState() => _SetSubWalletScreenState();
}

class _SetSubWalletScreenState extends BaseStateful<SetSubWalletScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  HederaWallet? activeWallet;
  List<HederaWallet> walletSelectedList = [];

  void onSave() {
    HederaSubWallet? subWallet =
        context.read<SubWalletCubit>().state.selectedSubWallet ??
            HederaSubWallet.empty();

    subWallet = subWallet.copyWith(
      title: titleController.text,
      description: descriptionController.text,
      users: walletSelectedList.map((e) => e.email).toList(),
    );

    context.read<SubWalletCubit>().setSubWallet(subWallet);
  }

  @override
  void initState() {
    final selectedData = context.read<SubWalletCubit>().state.selectedSubWallet;
    titleController.text = selectedData?.title ?? "";
    descriptionController.text = selectedData?.description ?? "";
    walletSelectedList = List<HederaWallet>.from((selectedData?.users ?? [])
        .map((e) => HederaWallet.empty().copyWith(email: e)));

    context.read<MemberWalletCubit>().fetchAllMemberWallet();
    super.initState();
  }

  @override
  Widget body() {
    return BlocListener<SubWalletCubit, SubWalletState>(
      listener: (context, state) {
        if (state is SubWalletSubmitLoading) {
          loading = LoadingUtil.build(context, dismissable: true);
          loading?.show();
        } else {
          loading?.dismiss();
        }

        if (state is SubWalletSubmitSuccess) {
          context.read<SubWalletCubit>().getSubWallet();
          context.pop();
        } else if (state is SubWalletFailed) {
          showSnackBar(state.message, isError: true);
        }
      },
      child: BaseCaiScreen(
        mainWidget: Container(
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
              titleField(),
              const SizedBox(height: 15),
              descriptionField(),
              const SizedBox(height: 15),
              memberSelectorWidget(),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Builder memberSelectorWidget() {
    return Builder(
      builder: (context) {
        final memberWalletList = context.select(
            (MemberWalletCubit element) => element.state.memberWalletList);

        final isLoading = context.select((MemberWalletCubit element) =>
            element.state is MemberWalletLoading);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
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
                      child: DropdownButtonHideUnderline(
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                Theme.of(context).appBarTheme.backgroundColor,
                          ),
                          padding: const EdgeInsets.only(left: 10),
                          alignment: Alignment.center,
                          child: DropdownSearch<HederaWallet>(
                            popupProps: PopupProps.dialog(
                              dialogProps: DialogProps(
                                backgroundColor: Theme.of(context)
                                    .appBarTheme
                                    .backgroundColor,
                              ),
                              showSearchBox: true,
                              textStyle: Styles.commonTextStyle(
                                size: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              searchFieldProps: TextFieldProps(
                                style: Styles.commonTextStyle(
                                  size: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Search User",
                                  border: const OutlineInputBorder(),
                                  hintStyle: Theme.of(context)
                                      .inputDecorationTheme
                                      .hintStyle,
                                ),
                              ),
                            ),
                            validator: (v) =>
                                v == null ? "required field" : null,
                            dropdownSearchTextStyle:
                                Theme.of(context).primaryTextTheme.bodyText1,
                            dropdownSearchDecoration: InputDecoration(
                              hintText: "Select User",
                              contentPadding:
                                  const EdgeInsets.fromLTRB(12, 12, 0, 0),
                              border: InputBorder.none,
                              hintStyle: Theme.of(context)
                                  .inputDecorationTheme
                                  .hintStyle,
                            ),
                            items: memberWalletList
                                .where((element) => !walletSelectedList
                                    .map((e) => e.email)
                                    .toList()
                                    .contains(element.email))
                                .toList(),
                            onChanged: (wallet) {
                              setState(() {
                                activeWallet = wallet;
                              });
                            },
                            itemAsString: (type) => type.email,
                            selectedItem: activeWallet,
                          ),
                          // DropdownButton<HederaWallet>(
                          //   value: activeWallet,
                          //   focusColor: Colors.transparent,
                          //   borderRadius: BorderRadius.circular(10),
                          //   dropdownColor:
                          //       Theme.of(context).appBarTheme.backgroundColor,
                          //   items: memberWalletList
                          //       .where((element) => !walletSelectedList
                          //           .map((e) => e.email)
                          //           .toList()
                          //           .contains(element.email))
                          //       .map(
                          //         (wallet) => DropdownMenuItem<HederaWallet>(
                          //           value: wallet,
                          //           child: Text(
                          //             wallet.email,
                          //             style: Theme.of(context)
                          //                 .primaryTextTheme
                          //                 .bodyText1,
                          //           ),
                          //         ),
                          //       )
                          //       .toList(),
                          //   onChanged: (selected) {
                          //     setState(() {
                          //       activeWallet = selected;
                          //     });
                          //   },
                          // ),
                        ),
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
                          color: Theme.of(context).buttonColor,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: CustomTextField(
        controller: titleController,
        text: "Sub Wallet Name",
        keyboardType: TextInputType.text,
        hint: "Sub Wallet name..",
        onChanged: (value) {},
      ),
    );
  }

  Widget descriptionField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: CustomTextField(
        controller: descriptionController,
        text: "Sub Wallet Description",
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        hint: "Sub Wallet Description..",
        onChanged: (value) {},
      ),
    );
  }

  Widget _bodyHeader() {
    return Builder(builder: (context) {
      final selectedData = context
          .select((SubWalletCubit element) => element.state.selectedSubWallet);
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
                color: Theme.of(context).cursorColor,
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
                          ? "Edit Sub Wallet"
                          : "Create Sub Wallet",
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
