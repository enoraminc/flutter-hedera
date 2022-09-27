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
  String? selectedTopicId;

  List<ConcensusMessageDataModel> bookMessageList = [];

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
      ],
      child: Builder(builder: (context) {
        final isLoading = context
            .select((JournalCubit element) => element.state is JournalLoading);

        final bookList =
            context.select((JournalCubit element) => element.state.journalList);

        final user =
            context.select((AuthBloc element) => element.state.currentUser);

        return BaseScreen2(
          selectedId: selectedTopicId,
          onRefresh: onRefresh,
          isLoading: isLoading,
          appBar: const CustomAppBar(),
          onBack: () {
            setState(() {
              selectedTopicId = null;
            });
          },
          sidebarChildren: sidebarListWidget(bookList),
          mainChild: bookInfoWidget(),
          onCreateTap: (user?.isAdmin() ?? false)
              ? () => context.push("${Routes.journal}/${Routes.create}")
              : null,
        );
      }),
    );
  }

  List<Widget> sidebarListWidget(List<JournalModel> books) {
    return books
        .map(
          (book) => InkWell(
            onTap: () {
              setState(() {
                selectedTopicId = book.topicId;
              });
              // context.read<JournalCubit>().getJournalMessageData(book.topicId);
              Router.neglect(
                context,
                () => context.go("${Routes.journal}?id=${book.topicId}"),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              margin: const EdgeInsets.only(
                bottom: 10,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
                borderRadius: BorderRadius.circular(5),
                gradient: selectedTopicId == book.topicId
                    ? LinearGradient(
                        stops: const [0.02, 0.02],
                        colors: [
                          Colors.orange,
                          Theme.of(context).appBarTheme.backgroundColor!
                        ],
                      )
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: Styles.commonTextStyle(
                      size: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    book.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Styles.commonTextStyle(
                      size: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Chip(
                    label: Text(
                      book.type,
                      style: Styles.commonTextStyle(
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.orange,
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  Builder bookInfoWidget() {
    return Builder(builder: (context) {
      final isLoading = context.select(
          (JournalCubit element) => element.state is JournalMessageLoading);

      final bookSelected = context.select((JournalCubit element) => element
          .state.journalList
          .firstWhereOrNull((element) => element.topicId == selectedTopicId));

      // final subWalletSelected = context.select((SubWalletCubit element) =>
      //     element.state.subWalletList.firstWhereOrNull((element) =>
      //         element.accountId == bookSelected?.subWalletId));

      if (bookSelected == null) {
        return Center(
          child: Text(
            "No Item Selected",
            textAlign: TextAlign.center,
            style: Styles.commonTextStyle(
              size: 18,
            ),
          ),
        );
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  bookSelected.title,
                  style: Styles.commonTextStyle(
                    size: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Chip(
                label: Text(
                  bookSelected.type,
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
            bookSelected.description,
            style: Styles.commonTextStyle(
              size: 14,
            ),
          ),
          const SizedBox(height: 5),
          const Divider(),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Hedera Consensus Service",
                  style: Styles.commonTextStyle(
                    size: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              RoundedButton(
                text: "View Data",
                selected: true,
                isSmall: true,
                selectedColor: Colors.orange,
                onPressed: () {
                  context.push(
                      "${Routes.journal}/${Routes.concensus}/$selectedTopicId");
                },
              ),
              const SizedBox(width: 10),
              RoundedButton(
                text: "Track Explorer",
                selected: true,
                isSmall: true,
                selectedColor: Colors.orange,
                onPressed: () {
                  launchUrlString(
                      "${HederaUtils.getHederaExplorerUrl()}/search-details/topic/$selectedTopicId");
                },
              ),
            ],
          ),
          // Expanded(
          //   child: CustomTableWidget2(
          //     title: 'Hedera Consensus Service',
          //     isLoading: isLoading,
          //     isWithPadding: false,
          //     buttonList: [],
          //     columns: const [
          //       "Sequence Number",
          //       "Message",
          //     ],
          //     rows: bookMessageList.map((bookMessage) {
          //       return [
          //         formatNumber(bookMessage.topicSequenceNumber.toString()),
          //         bookMessage.data,
          //       ];
          //     }).toList(),
          //   ),
          // ),
          const SizedBox(height: 10),
        ],
      );
    });
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
            bookMessageList = state.data;
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
}
