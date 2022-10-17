part of '../journal.dart';

class CreateVoteJournalScreen extends StatefulWidget {
  const CreateVoteJournalScreen({super.key});

  @override
  State<CreateVoteJournalScreen> createState() =>
      _CreateVoteJournalScreenState();
}

class _CreateVoteJournalScreenState
    extends BaseStateful<CreateVoteJournalScreen> {
  Future<void> onRefresh() async {
    context.read<SubWalletCubit>().fetchSubWallet(
          type: HederaSubWallet.voteType,
        );

    await Future.delayed(const Duration(milliseconds: 100));
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  HederaSubWallet? subWalletSelected;

  void onSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // HederaWallet? wallet =
    //     context.read<MemberWalletCubit>().state.selectedWallet ??
    //         HederaWallet.empty();

    final journal = VoteJournalModel(
      id: "",
      topicId: "",
      network: "",
      subWalletId: subWalletSelected?.id ?? "-",
      title: titleController.text,
      description: descriptionController.text,
      type: JournalModel.voteType,
      state: JournalModel.activeState,
      members: subWalletSelected?.users ?? [],
      participant: subWalletSelected?.users ?? [],
      refId: '',
      additionalData: VoteAdditionalDataModel(
        refId: "",
        participant: subWalletSelected?.users ?? [],
      ).toMap(),
    );

    final jobRequest = JobRequestModel.createNewRequest(
      type: JobRequestModel.createJournalType,
      data: journal.toJobReqMap(),
      users: [
        journal.subWalletId,
        ...journal.members,
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
              const SizedBox(height: 15),
              titleField(),
              const SizedBox(height: 15),
              descriptionField(),
              const SizedBox(height: 15),
              // const SizedBox(height: 20),

              // messageListWidget(),
            ],
          ),
        ),
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

  Widget _appBar() {
    return CustomSecondAppBar(
      title: "Create Vote Journal",
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
