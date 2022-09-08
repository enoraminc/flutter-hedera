part of '../book.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({
    super.key,
    required this.id,
  });

  final String id;
  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends BaseStateful<BookScreen> {
  String? selectedTopicId;

  List<BookMessageDataModel> bookMessageList = [
    // Dummy Data For Testing
    // BookMessageDataModel(
    //   data:
    //       "{\"sequenceNumber\":0,\"bookId\":\"book_VoJfvpyzyTrfQIEREX7mDjIn2ETs\",\"subWalletId\":\"subWallet_jxMtIEfTZcEDDKMIA4z0RO6N3dAT\",\"date\":1662352450040,\"memberBook\":{\"name\":\"Oen Enoram\",\"email\":\"oen@enoram.com\",\"limitPayable\":100000},\"debit\":100000,\"credit\":0}",
    //   topicSequenceNumber: 4,
    // ),
    // BookMessageDataModel(
    //   data:
    //       "{\"sequenceNumber\":0,\"bookId\":\"book_VoJfvpyzyTrfQIEREX7mDjIn2ETs\",\"subWalletId\":\"subWallet_jxMtIEfTZcEDDKMIA4z0RO6N3dAT\",\"date\":1662352450040,\"memberBook\":{\"name\":\"Oen Enoram\",\"email\":\"oen@enoram.com\",\"limitPayable\":100000},\"debit\":0,\"credit\":50000}",
    //   topicSequenceNumber: 3,
    // ),
    // BookMessageDataModel(
    //   data:
    //       "{\"sequenceNumber\":0,\"bookId\":\"book_VoJfvpyzyTrfQIEREX7mDjIn2ETs\",\"subWalletId\":\"subWallet_jxMtIEfTZcEDDKMIA4z0RO6N3dAT\",\"date\":1662352450040,\"memberBook\":{\"name\":\"Oen Enoram\",\"email\":\"oen@enoram.com\",\"limitPayable\":100000},\"debit\":0,\"credit\":50000}",
    //   topicSequenceNumber: 2,
    // ),
    // BookMessageDataModel(
    //   data:
    //       "{\"sequenceNumber\":0,\"bookId\":\"book_VoJfvpyzyTrfQIEREX7mDjIn2ETs\",\"subWalletId\":\"subWallet_jxMtIEfTZcEDDKMIA4z0RO6N3dAT\",\"date\":1662352450040,\"memberBook\":{\"name\":\"Oen Enoram\",\"email\":\"oen@enoram.com\",\"limitPayable\":100000},\"debit\":200000,\"credit\":0}",
    //   topicSequenceNumber: 1,
    // )
  ];

  Future<void> onRefresh() async {
    context.read<BookCubit>().getBook("");

    if (selectedTopicId?.isNotEmpty ?? false) {
      context.read<BookCubit>().getBookMessageData(selectedTopicId!);
    }

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
        bookListener(),
      ],
      child: Builder(builder: (context) {
        final isLoading =
            context.select((BookCubit element) => element.state is BookLoading);

        final bookList =
            context.select((BookCubit element) => element.state.bookList);

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
        );
      }),
    );
  }

  List<Widget> sidebarListWidget(List<BookModel> books) {
    return books
        .map(
          (book) => InkWell(
            onTap: () {
              setState(() {
                selectedTopicId = book.topicId;
              });
              context.read<BookCubit>().getBookMessageData(book.topicId);
              Router.neglect(
                context,
                () => context.go("${Routes.book}?id=${book.topicId}"),
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
      final isLoading = context
          .select((BookCubit element) => element.state is BookMessageLoading);

      final bookSelected = context.select((BookCubit element) => element
          .state.bookList
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
          Expanded(
            child: CustomTableWidget2(
              title: 'Hedera Consensus Service',
              isLoading: isLoading,
              isWithPadding: false,
              buttonList: [
                RoundedButton(
                  text: "Convert Raw Data",
                  selected: true,
                  isSmall: true,
                  selectedColor: Colors.orange,
                  onPressed: () {
                    context.push(
                        "${Routes.book}/${Routes.convertBook}/$selectedTopicId");
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
              columns: const [
                "Sequence Number",
                "Message",
              ],
              rows: bookMessageList.map((bookMessage) {
                return [
                  formatNumber(bookMessage.topicSequenceNumber.toString()),
                  bookMessage.data,
                ];
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
        ],
      );
    });
  }

  BlocListener<BookCubit, BookState> bookListener() {
    return BlocListener<BookCubit, BookState>(
      listener: (context, state) {
        if (state is SubmitBookLoading) {
          loading = LoadingUtil.build(context);
          loading?.show();
        } else {
          loading?.dismiss();
        }
        // Log.setLog(state.toString(), method: "LoginScreen");

        if (state is GetBookMessageDataFailed) {
          showSnackBar(state.message, isError: true);
        }
        if (state is GetBookMessageDataSuccess) {
          setState(() {
            bookMessageList = state.data;
          });
        }
        if (state is ExportBookFailed) {
          showSnackBar(state.message, isError: true);
        }
      },
    );
  }
}
