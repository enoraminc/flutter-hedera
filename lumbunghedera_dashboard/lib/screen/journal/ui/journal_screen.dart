part of '../journal.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({
    super.key,
    required this.id,
  });

  final String id;
  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends BaseStateful<JournalScreen> {
  final CustomPopupMenuController _controller = CustomPopupMenuController();
  String? selectedTopicId;

  List<ConcensusMessageDataModel> journalMessageList = [];

  Future<void> onRefresh() async {
    context.read<JournalCubit>().getJournal();

    // if (selectedTopicId?.isNotEmpty ?? false) {
    //   context.read<JournalCubit>().getJournalMessageData(selectedTopicId!);
    // }

    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  void initState() {
    selectedTopicId = widget.id;
    onRefresh();
    super.initState();
  }

  @override
  Widget body() {
    return MultiBlocListener(
      listeners: [
        journalListener(),
        voteListener(),
      ],
      child: Builder(builder: (context) {
        final isLoading = context
            .select((JournalCubit element) => element.state is JournalLoading);

        final journalList =
            context.select((JournalCubit element) => element.state.journalList);

        final user =
            context.select((AuthBloc element) => element.state.currentUser);

        return BaseScreen2(
          selectedId: selectedTopicId,
          onRefresh: onRefresh,
          isLoading: isLoading,
          appBar: const CustomAppBar(),
          bottomNavBar: const SizedBox(),
          onBack: () {
            setState(() {
              selectedTopicId = null;
            });
          },
          sidebarChildren: sidebarListWidget(journalList),
          mainChild: journalInfoWidget(),
          // onCreateTap: (user?.isAdmin() ?? false)
          //     ? () => context.push(Routes.createCashbonJournal)
          //     : null,
          customButton: createButtonWidget(),
        );
      }),
    );
  }

  CustomPopupMenu createButtonWidget() {
    return CustomPopupMenu(
      menuBuilder: () => Builder(builder: (context) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            color: Theme.of(context).appBarTheme.backgroundColor,
            padding: const EdgeInsets.all(20),
            width: 300,
            // height: 300,
            child: Column(
              children: [
                ListTile(
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.orange,
                  ),
                  title: Text(
                    'Create Cashbon Journal',
                    style: Styles.commonTextStyle(
                      size: 18,
                    ),
                  ),
                  onTap: () {
                    _controller.hideMenu();
                    context.push(
                        "${Routes.journal}/${Routes.createCashbonJournal}");
                  },
                ),
                const SizedBox(height: 5),
                const Divider(
                  color: Colors.grey,
                ),
                const SizedBox(height: 5),
                ListTile(
                  title: Text(
                    'Create Vote Journal',
                    style: Styles.commonTextStyle(
                      size: 18,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.orange,
                  ),
                  onTap: () {
                    _controller.hideMenu();

                    context
                        .push("${Routes.journal}/${Routes.createVoteJournal}");
                  },
                ),
              ],
            ),
          ),
        );
      }),
      pressType: PressType.singleClick,
      verticalMargin: -5,
      controller: _controller,
      position: PreferredPosition.top,
      barrierColor: Colors.black.withOpacity(.7),
      child: const CircleAvatar(
        radius: 25,
        backgroundColor: Colors.orange,
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  List<Widget> sidebarListWidget(List<JournalModel> journals) {
    return journals
        .map((journal) => SingleJournalWidget(
              journal: journal,
              onTap: () {
                setState(() {
                  selectedTopicId = journal.topicId;
                });
                // context.read<JournalCubit>().getJournalMessageData(book.topicId);
                Router.neglect(
                  context,
                  () => context.go("${Routes.journal}?id=${journal.topicId}"),
                );
              },
              isSelected: selectedTopicId == journal.topicId,
            ))
        .toList();
  }

  Widget journalInfoWidget() {
    return DetailJournalWidget(
      selectedId: selectedTopicId ?? "",
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
        // Log.setLog(state.toString(), method: "LoginScreen");

        if (state is GetJournalMessageDataFailed) {
          showSnackBar(state.message, isError: true);
        }
        if (state is GetJournalMessageDataSuccess) {
          setState(() {
            journalMessageList = state.data;
          });
        }
        if (state is ExportJournalFailed) {
          showSnackBar(state.message, isError: true);
        }
        if (state is SetJournalSuccess) {
          onRefresh();
        } else if (state is JournalFailed) {
          showSnackBar(state.message, isError: true);
        }
      },
    );
  }

  BlocListener<VoteCubit, VoteState> voteListener() {
    return BlocListener<VoteCubit, VoteState>(
      listener: (context, state) {
        if (state is VoteSubmitLoading) {
          loading = LoadingUtil.build(context);
          loading?.show();
        } else {
          loading?.dismiss();
        }

        if (state is VoteSubmitSuccess) {
          // onRefresh();
        } else if (state is VoteFailed) {
          showSnackBar(state.message, isError: true);
        }
      },
    );
  }
}
