part of '../journal.dart';

class CreateCashbonJournalScreen extends StatefulWidget {
  const CreateCashbonJournalScreen({super.key});

  @override
  State<CreateCashbonJournalScreen> createState() =>
      _CreateCashbonJournalScreenState();
}

class _CreateCashbonJournalScreenState
    extends BaseStateful<CreateCashbonJournalScreen> {
  Future<void> onRefresh() async {
    context.read<SubWalletCubit>().fetchSubWallet(
          type: HederaSubWallet.kedaiType,
        );

    await Future.delayed(const Duration(milliseconds: 100));
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController limitController = TextEditingController();
  final TextEditingController effectiveDateController = TextEditingController();

  DateTime? effectiveDate;

  List<MemberModel> memberList = [];

  HederaWallet? activeWallet;
  List<HederaWallet> walletSelectedList = [];
  HederaSubWallet? subWalletSelected;

  void onSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // HederaWallet? wallet =
    //     context.read<MemberWalletCubit>().state.selectedWallet ??
    //         HederaWallet.empty();

    final journal = CashbonJournalModel(
      id: "",
      topicId: "",
      subWalletId: subWalletSelected?.id ?? "-",
      title:
          "${subWalletSelected?.title.replaceAll(" Wallet", "") ?? "-"} ${CustomDateUtils.monthOnly(effectiveDate)}",
      description:
          "Cashbon Journal for ${subWalletSelected?.title.replaceAll(" Wallet", "") ?? "-"} ${CustomDateUtils.monthOnly(effectiveDate)}",
      memberList: memberList,
      effectiveDate: effectiveDate,
      network: "",
      type: JournalModel.cashbonType,
      state: JournalModel.activeState,
      members: memberList.map((e) => e.email).toList(),
      amount: 0,
      additionalData: CashbonAdditionalDataModel(
        amount: 0,
        memberList: memberList,
        effectiveDate: effectiveDate,
      ).toMap(),
    );

    final jobRequest = JobRequestModel.createNewRequest(
      type: JobRequestModel.createJournalType,
      data: journal.toJobReqMap(),
      users: [
        journal.subWalletId,
        ...journal.memberList.map((e) => e.email).toList()
      ],
    );

    context.read<JournalCubit>().setJournal(jobRequest);
  }

  @override
  void initState() {
    onRefresh();
    super.initState();
  }

  @override
  Widget body() {
    return SafeArea(
      child: MultiBlocListener(
        listeners: [
          journalListener(),
        ],
        child: Form(
          key: _formKey,
          child: BaseScreen(
            onRefresh: onRefresh,
            appBar: _appBar(),
            children: [
              // const SizedBox(height: 10),
              setSubWalletWidget(),
              // const SizedBox(height: 15),
              // titleField(),
              // const SizedBox(height: 15),
              // descriptionField(),
              effectiveDateField(),
              // const SizedBox(height: 15),
              setLimitMemberWidget(),
              // const SizedBox(height: 20),

              // messageListWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget effectiveDateField() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        // borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: CustomTextFormField(
        controller: effectiveDateController,
        text: "Valid Month",
        keyboardType: TextInputType.text,
        readOnly: true,
        hint: "Valid month..",
        onChanged: (value) {},
        onTap: () {
          showMonthPicker(
            context: context,
            // firstDate: DateTime(DateTime.now().year - 1, 5),
            lastDate: DateTime.now().add(const Duration(days: 1000)),
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
          ).then((date) {
            if (date != null) {
              effectiveDate = DateTime(
                date.lastDayOfMonth.year,
                date.lastDayOfMonth.month,
                date.lastDayOfMonth.day,
                23,
                59,
                59,
              );

              effectiveDateController.text = CustomDateUtils.monthOnly(date);
              setState(() {});
            }
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Valid Month field is required';
          }

          return null;
        },
      ),
    );
  }

  Widget titleField() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        // borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: CustomTextFormField(
        controller: titleController,
        text: "Title",
        keyboardType: TextInputType.text,
        hint: "title..",
        onChanged: (value) {},
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Title field is required';
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
        // borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: CustomTextFormField(
        controller: descriptionController,
        text: "Description",
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        hint: "description..",
        onChanged: (value) {},
        validator: (value) {
          return null;
        },
      ),
    );
  }

  Builder setSubWalletWidget() {
    return Builder(
      builder: (context) {
        final subWalletList = context
            .select((SubWalletCubit element) => element.state.subWalletList);

        final isLoading = context.select(
            (SubWalletCubit element) => element.state is SubWalletLoading);

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor,
            // borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Set Kedai",
                style: Styles.commonTextStyle(
                  size: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (isLoading)
                FadeShimmer(
                  height: 50,
                  width: double.infinity,
                  radius: 4,
                  fadeTheme: CustomFunctions.isDarkTheme(context)
                      ? FadeTheme.dark
                      : FadeTheme.light,
                )
              else
                SubWalletSelector(
                  activeWallet: subWalletSelected,
                  subWalletList: subWalletList
                      .where((element) => element.id != subWalletSelected?.id)
                      .toList(),
                  onChange: (wallet) {
                    setState(() {
                      subWalletSelected = wallet;
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Builder setLimitMemberWidget() {
    return Builder(
      builder: (context) {
        // final memberWalletList = context.select(
        //     (MemberWalletCubit element) => element.state.memberWalletList);

        // final isLoading = context.select((MemberWalletCubit element) =>
        //     element.state is MemberWalletLoading);

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor,
            // borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Set Limit Payable Member",
                style: Styles.commonTextStyle(
                  size: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // if (isLoading)
              //   FadeShimmer(
              //     height: 50,
              //     width: double.infinity,
              //     radius: 4,
              //     fadeTheme: CustomFunctions.isDarkTheme(context)
              //         ? FadeTheme.dark
              //         : FadeTheme.light,
              //   )
              // else
              Row(
                children: [
                  Expanded(
                    child: MainWalletSelector(
                      activeWallet: activeWallet,
                      memberWalletList: (subWalletSelected?.userList ?? [])
                          .map((e) => HederaWallet.empty().copyWith(
                                email: e.email,
                                displayName: e.name,
                                profileImage: e.avatarUrl,
                              ))
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
                  Expanded(
                    child: CustomTextFormField(
                      controller: limitController,
                      text: "Limit",
                      keyboardType: TextInputType.number,
                      hint: "Limit..",
                      fieldOnly: true,
                      onChanged: (value) {},
                      validator: (value) {
                        return null;
                      },
                      isNumber: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  RoundedButton(
                    text: "",
                    selected: true,
                    isSmall: true,
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    selectedColor: Colors.orange,
                    onPressed: () {
                      setState(() {
                        if (activeWallet != null) {
                          walletSelectedList.add(activeWallet!);
                          memberList.add(
                            MemberModel(
                                email: activeWallet?.email ?? "",
                                name: activeWallet?.displayName ?? "",
                                limitPayable: int.tryParse(limitController.text
                                        .replaceAll(".", "")) ??
                                    0),
                          );
                          limitController.clear();
                        }
                        activeWallet = null;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Limit Payable Member List",
                style: Styles.commonTextStyle(
                  size: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (memberList.isEmpty)
                Center(
                  child: Text(
                    "Limit Payable Member List is Empty",
                    textAlign: TextAlign.center,
                    style: Styles.commonTextStyle(
                      size: 16,
                    ),
                  ),
                ),
              ...memberList
                  .map(
                    (book) => Container(
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
                              "${book.name} - ${book.email}",
                              style: Styles.commonTextStyle(
                                size: 18,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              formatAmount(book.limitPayable),
                              style: Styles.commonTextStyle(
                                size: 18,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              setState(() {
                                walletSelectedList.removeWhere(
                                    (element) => element.email == book.email);
                                memberList.removeWhere(
                                    (element) => element.email == book.email);
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

  Widget _appBar() {
    return CustomSecondAppBar(
      title: "Create Cashbon Journal",
      onActionTap: onSave,
    );
  }

  BlocListener<JournalCubit, JournalState> journalListener() {
    return BlocListener<JournalCubit, JournalState>(
      listener: (context, state) {
        if (state is SubmitJournalLoading) {
          loading = LoadingUtil.build(context);
          loading?.show();
        } else {
          loading?.dismiss();
        }

        if (state is SetJournalSuccess) {
          context.pop();
        } else if (state is JournalFailed) {
          showSnackBar(state.message, isError: true);
        }
      },
    );
  }
}
