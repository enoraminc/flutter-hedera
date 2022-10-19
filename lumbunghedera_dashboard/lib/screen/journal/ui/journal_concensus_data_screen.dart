part of '../journal.dart';

enum ViewData {
  pretty("Pretty Data"),
  raw("Raw Data");

  final String label;

  const ViewData(this.label);

  @override
  String toString() => label;
}

class JournalConcensusDataScreen extends StatefulWidget {
  const JournalConcensusDataScreen({super.key, required this.journalId});
  final String journalId;

  @override
  State<JournalConcensusDataScreen> createState() =>
      _JournalConcensusDataScreenState();
}

class _JournalConcensusDataScreenState
    extends BaseStateful<JournalConcensusDataScreen> {
  JournalModel? currentJournal;

  ViewData viewData = ViewData.pretty;

  List<ConcensusMessageDataModel> concensusMessageDataList = [];

  Future<void> onRefresh() async {
    context.read<JournalCubit>().getJournalMessageData(widget.journalId);

    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  void initState() {
    currentJournal = context
        .read<JournalCubit>()
        .state
        .journalList
        .firstWhereOrNull((element) => element.id == widget.journalId);

    onRefresh();
    super.initState();
  }

  @override
  Widget body() {
    return MultiBlocListener(
      listeners: [
        journalListener(),
      ],
      child: DefaultTabController(
        length: 2,
        child: BaseScreen(
          onRefresh: onRefresh,
          appBar: _appBar(),
          children: [
            const SizedBox(height: 10),
            journalInfoWidget(),
            const SizedBox(height: 10),
            if (viewData == ViewData.pretty) ...[
              if (currentJournal?.isCashbonType() ?? false) ...[
                CashbonPayableWidget(
                  currentJournal: currentJournal,
                  concensusMessageDataList: concensusMessageDataList,
                ),
                const SizedBox(height: 10),
                ReceivableCashbonJournalWidget(
                  concensusMessageDataList: concensusMessageDataList,
                ),
                const SizedBox(height: 20),
              ] else if (currentJournal?.isVoteType() ?? false) ...[
                VoteConcensusWidget(
                  concensusMessageDataList: concensusMessageDataList,
                ),
                const SizedBox(height: 20),
              ] else if (currentJournal?.isGoalType() ?? false) ...[
                GoalConcensusWidget(
                  concensusMessageDataList: concensusMessageDataList,
                ),
                const SizedBox(height: 20),
              ],
            ] else ...[
              rawTableWidget(),
              const SizedBox(height: 20),
            ],

            // messageListWidget(),
          ],
        ),
      ),
    );
  }

  Widget journalInfoWidget() {
    return Builder(builder: (context) {
      if (currentJournal == null) return const SizedBox();

      return Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    currentJournal?.title ?? "-",
                    style: Styles.commonTextStyle(
                      size: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  children: [
                    Chip(
                      label: Text(
                        currentJournal?.type ?? "-",
                        style: Styles.commonTextStyle(
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.orange,
                    ),
                    Chip(
                      label: Text(
                        currentJournal?.state ?? "-",
                        style: Styles.commonTextStyle(
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              currentJournal?.description ?? "-",
              style: Styles.commonTextStyle(
                size: 14,
              ),
            ),
            const SizedBox(height: 10),
            TabBar(
              indicatorColor: Colors.orange,
              tabs: [
                Tab(
                  text: ViewData.pretty.toString(),
                ),
                Tab(
                  text: ViewData.raw.toString(),
                ),
              ],
              onTap: (index) {
                if (index == 0) {
                  setState(() {
                    viewData = ViewData.pretty;
                  });
                } else if (index == 1) {
                  setState(() {
                    viewData = ViewData.raw;
                  });
                }
              },
            ),
          ],
        ),
      );
    });
  }

  Widget rawTableWidget() {
    return Builder(builder: (context) {
      final isLoading = context.select(
          (JournalCubit element) => element.state is JournalMessageLoading);
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              children: const [
                Expanded(
                  flex: 1,
                  child: Text("Sequence Number"),
                ),
                Expanded(
                  flex: 5,
                  child: Text("Message"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (isLoading)
              FadeShimmer(
                height: 300,
                width: double.infinity,
                radius: 4,
                fadeTheme: CustomFunctions.isDarkTheme(context)
                    ? FadeTheme.dark
                    : FadeTheme.light,
              )
            else
              ...concensusMessageDataList.map((message) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          formatNumber(message.topicSequenceNumber.toString()),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                          message.data,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            const SizedBox(height: 10),
          ],
        ),
      );
    });
  }

  Widget _appBar() {
    return const CustomSecondAppBar(
      title: "Journal Concensus Data ",
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
            concensusMessageDataList = state.data;
          });
        }
        if (state is ExportJournalFailed) {
          showSnackBar(state.message, isError: true);
        }
      },
    );
  }
}
