part of '../journal.dart';

class CreateGoalJournalScreen extends StatefulWidget {
  const CreateGoalJournalScreen({super.key});

  @override
  State<CreateGoalJournalScreen> createState() =>
      _CreateGoalJournalScreenState();
}

class _CreateGoalJournalScreenState
    extends BaseStateful<CreateGoalJournalScreen> {
  Future<void> onRefresh() async {
    context
        .read<SubWalletCubit>()
        .fetchSubWallet(
          type: HederaSubWallet.goalType,
        )
        .then((value) async {
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        subWalletSelected =
            context.read<SubWalletCubit>().state.subWalletList.firstOrNull;
      });
    });

    await Future.delayed(const Duration(milliseconds: 100));
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController batchDateController = TextEditingController();

  DateTime? batchDate;

  HederaSubWallet? subWalletSelected;

  void onSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // HederaWallet? wallet =
    //     context.read<MemberWalletCubit>().state.selectedWallet ??
    //         HederaWallet.empty();

    final journal = GoalJournalModel(
      id: "",
      topicId: "",
      subWalletId: subWalletSelected?.id ?? "-",
      title: "Goal Batch ${CustomDateUtils.monthOnly(batchDate)}",
      description:
          "Goal Journal Batch for ${CustomDateUtils.monthOnly(batchDate)}",
      network: "",
      type: JournalModel.goalType,
      state: JournalModel.activeState,
      members: [
        subWalletSelected?.id ?? "-",
      ],
      isEncrypted: true,
      additionalData: GoalAdditionalDataModel(
        refId: "",
      ).toMap(),
      refId: "",
    );

    final jobRequest = JobRequestModel.createNewRequest(
      type: JobRequestModel.createJournalType,
      data: journal.toJobReqMap(),
      users: [
        journal.subWalletId,
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
              setSubWalletWidget(),
              batchDateField(),

              // messageListWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget batchDateField() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        // borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: CustomTextFormField(
        controller: batchDateController,
        text: "Batch Month",
        keyboardType: TextInputType.text,
        readOnly: true,
        hint: "Batch Month..",
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
              batchDate = DateTime(
                date.lastDayOfMonth.year,
                date.lastDayOfMonth.month,
                date.lastDayOfMonth.day,
                23,
                59,
                59,
              );

              batchDateController.text = CustomDateUtils.monthOnly(date);
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
                "Set Sub Wallet",
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

  Widget _appBar() {
    return CustomSecondAppBar(
      title: "Create Goal Journal",
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
