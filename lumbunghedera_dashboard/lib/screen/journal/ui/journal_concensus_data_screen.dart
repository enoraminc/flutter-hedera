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
  const JournalConcensusDataScreen({super.key, required this.topicId});
  final String topicId;

  @override
  State<JournalConcensusDataScreen> createState() =>
      _JournalConcensusDataScreenState();
}

class _JournalConcensusDataScreenState
    extends BaseStateful<JournalConcensusDataScreen> {
  JournalModel? currentJournal;
  MemberModel? payableMemberSelected;

  ViewData viewData = ViewData.pretty;

  List<ConcensusMessageDataModel> concensusMessageDataList = [];

  Future<void> onRefresh() async {
    context.read<JournalCubit>().getJournalMessageData(widget.topicId);

    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  void initState() {
    currentJournal = context
        .read<JournalCubit>()
        .state
        .journalList
        .firstWhereOrNull((element) => element.topicId == widget.topicId);

    payableMemberSelected = currentJournal?.memberList.first;

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
            bookInfoWidget(),
            const SizedBox(height: 10),
            if (viewData == ViewData.pretty) ...[
              payableBookWidget(),
              const SizedBox(height: 10),
              receivableBookWidget(),
              const SizedBox(height: 20),
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

  Widget bookInfoWidget() {
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
                Chip(
                  label: Text(
                    currentJournal?.type ?? "-",
                    style: Styles.commonTextStyle(
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.orange,
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
        // CustomTableWidget2(
        //   title: 'Hedera Consensus Service',
        //   isLoading: isLoading,
        //   isWithPadding: false,
        //   columns: const [
        //     "Sequence Number",
        //     "Message",
        //   ],
        //   rows: bookMessageList.map((bookMessage) {
        //     return [
        //       formatNumber(bookMessage.topicSequenceNumber.toString()),
        //       bookMessage.data,
        //     ];
        //   }).toList(),
        // ),
      );
    });
  }

  Builder receivableBookWidget() {
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTableWidget(
              title: 'Receivable Book',
              isLoading: isLoading,
              isWithPadding: false,
              onExport: () {
                // context
                //     .read<JournalCubit>()
                //     .exportJournal(concensusMessageDataList);
              },
              columns: const [
                // "Sequence Number",
                "Date",
                "Member",
                "Limit Payable",
                "Debit",
                "Credit",
                "Balanced",
              ],
              rows: concensusMessageDataList
                  .map((message) {
                    final cashbon = PodModel.fromJson(message.data);

                    int balance = 0;

                    for (ConcensusMessageDataModel element
                        in concensusMessageDataList) {
                      if (element.topicSequenceNumber <=
                          message.topicSequenceNumber) {
                        final podCheck = PodModel.fromJson(element.data);

                        balance += podCheck.laci?.debit ?? 0;
                        balance -= podCheck.laci?.credit ?? 0;
                      }
                    }

                    return [
                      // formatNumber(message.topicSequenceNumber.toString()),
                      CustomDateUtils.simpleFormatWithTime(cashbon.laci?.date),
                      cashbon.laci?.member.name ?? "",
                      formatAmount(cashbon.laci?.member.limitPayable),
                      formatAmount(cashbon.laci?.debit),
                      formatAmount(cashbon.laci?.credit),
                      formatAmount(balance),
                    ];
                  })
                  .toList()
                  .reversed
                  .toList(),
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    });
  }

  Builder payableBookWidget() {
    return Builder(builder: (context) {
      if (currentJournal == null) return const SizedBox();

      final isLoading = context.select(
          (JournalCubit element) => element.state is JournalMessageLoading);

      List<ConcensusMessageDataModel> memberBookMessageList = [];

      concensusMessageDataList.forEach((bookMessage) {
        final cashbon = PodModel.fromJson(bookMessage.data);
        if (cashbon.laci?.member.email == payableMemberSelected?.email) {
          memberBookMessageList.add(bookMessage);
        }
      });

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              "Select Member",
              style: Styles.commonTextStyle(
                size: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: 10,
              children: (currentJournal?.memberList ?? [])
                  .map((member) => InkWell(
                        onTap: () {
                          setState(() {
                            payableMemberSelected = member;
                          });
                        },
                        child: Chip(
                          backgroundColor: payableMemberSelected == member
                              ? Colors.green
                              : Colors.grey,
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          label: Text(
                            member.name,
                            style: Styles.commonTextStyle(
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            if (payableMemberSelected != null) ...[
              Text(
                "Member : ${payableMemberSelected?.name}",
                style: Styles.commonTextStyle(
                  size: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Payable Limit : ${formatAmount(payableMemberSelected?.limitPayable ?? 0)}",
                style: Styles.commonTextStyle(
                  size: 16,
                ),
              ),
            ],
            const SizedBox(height: 20),
            CustomTableWidget(
              title: 'Payable Book Member',
              isLoading: isLoading,
              isWithPadding: false,
              columns: const [
                // "tes",
                "Date",
                "Debit",
                "Credit",
                "Balanced",
              ],
              rows: memberBookMessageList
                  .map((bookMessage) {
                    final cashbon = PodModel.fromJson(bookMessage.data);
                    int balance = 0;

                    for (ConcensusMessageDataModel element
                        in memberBookMessageList) {
                      if (element.topicSequenceNumber <=
                          bookMessage.topicSequenceNumber) {
                        final check = PodModel.fromJson(element.data);

                        balance += check.laci?.debit ?? 0;
                        balance -= check.laci?.credit ?? 0;
                      }
                    }

                    return [
                      // cashbon.memberBook.email,
                      CustomDateUtils.simpleFormatWithTime(cashbon.laci?.date),
                      formatAmount(cashbon.laci?.debit),
                      formatAmount(cashbon.laci?.credit),
                      formatAmount(balance),
                    ];
                  })
                  .toList()
                  .reversed
                  .toList(),
            ),
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
