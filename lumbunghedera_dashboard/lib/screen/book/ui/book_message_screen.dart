part of '../book.dart';

class BookMessageScreen extends StatefulWidget {
  const BookMessageScreen({super.key, required this.topicId});
  final String topicId;

  @override
  State<BookMessageScreen> createState() => _BookMessageScreenState();
}

class _BookMessageScreenState extends BaseStateful<BookMessageScreen> {
  BookModel? currentBook;
  MemberBook? payableMemberSelected;

  List<BookMessageDataModel> bookMessageList = [
    // Dummy Data For Testing
    // BookMessageDataModel(
    //   data:
    //       "{\"sequenceNumber\":4,\"bookId\":\"book_VoJfvpyzyTrfQIEREX7mDjIn2ETs\",\"subWalletId\":\"subWallet_jxMtIEfTZcEDDKMIA4z0RO6N3dAT\",\"date\":1662352450040,\"memberBook\":{\"name\":\"Oen Enoram\",\"email\":\"oen@enoram.com\",\"limitPayable\":100000},\"debit\":100000,\"credit\":0}",
    //   topicSequenceNumber: 4,
    // ),
    // BookMessageDataModel(
    //   data:
    //       "{\"sequenceNumber\":3,\"bookId\":\"book_VoJfvpyzyTrfQIEREX7mDjIn2ETs\",\"subWalletId\":\"subWallet_jxMtIEfTZcEDDKMIA4z0RO6N3dAT\",\"date\":1662352450040,\"memberBook\":{\"name\":\"Oen Enoram\",\"email\":\"oen@enoram.com\",\"limitPayable\":100000},\"debit\":0,\"credit\":50000}",
    //   topicSequenceNumber: 3,
    // ),
    // BookMessageDataModel(
    //   data:
    //       "{\"sequenceNumber\":2,\"bookId\":\"book_VoJfvpyzyTrfQIEREX7mDjIn2ETs\",\"subWalletId\":\"subWallet_jxMtIEfTZcEDDKMIA4z0RO6N3dAT\",\"date\":1662352450040,\"memberBook\":{\"name\":\"Oen Enoram\",\"email\":\"oen@enoram.com\",\"limitPayable\":100000},\"debit\":0,\"credit\":50000}",
    //   topicSequenceNumber: 2,
    // ),
    // BookMessageDataModel(
    //   data:
    //       "{\"sequenceNumber\":1,\"bookId\":\"book_VoJfvpyzyTrfQIEREX7mDjIn2ETs\",\"subWalletId\":\"subWallet_jxMtIEfTZcEDDKMIA4z0RO6N3dAT\",\"date\":1662352450040,\"memberBook\":{\"name\":\"Oen Enoram\",\"email\":\"oen@enoram.com\",\"limitPayable\":100000},\"debit\":200000,\"credit\":0}",
    //   topicSequenceNumber: 1,
    // )
  ];

  Future<void> onRefresh() async {
    context.read<BookCubit>().getBookMessageData(widget.topicId);

    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  void initState() {
    currentBook = context
        .read<BookCubit>()
        .state
        .bookList
        .firstWhereOrNull((element) => element.topicId == widget.topicId);

    payableMemberSelected = currentBook?.memberBookList.first;

    onRefresh();
    super.initState();
  }

  @override
  Widget body() {
    return MultiBlocListener(
      listeners: [
        bookListener(),
      ],
      child: BaseScreen(
        onRefresh: onRefresh,
        appBar: const CustomAppBar(),
        children: [
          const SizedBox(height: 10),
          bookInfoWidget(),
          const SizedBox(height: 10),
          payableBookWidget(),
          const SizedBox(height: 10),
          receivableBookWidget(),
          const SizedBox(height: 20),
          // messageListWidget(),
        ],
      ),
    );
  }

  Widget bookInfoWidget() {
    return Builder(builder: (context) {
      if (currentBook == null) return const SizedBox();

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
            Row(
              children: [
                Expanded(
                  child: Text(
                    currentBook?.title ?? "-",
                    style: Styles.commonTextStyle(
                      size: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Chip(
                  label: Text(
                    currentBook?.type ?? "-",
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
              currentBook?.description ?? "-",
              style: Styles.commonTextStyle(
                size: 14,
              ),
            ),
          ],
        ),
      );
    });
  }

  Builder receivableBookWidget() {
    return Builder(builder: (context) {
      final isLoading = context
          .select((BookCubit element) => element.state is BookMessageLoading);

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
                context.read<BookCubit>().exportBook(bookMessageList);
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
              rows: bookMessageList
                  .map((bookMessage) {
                    final cashbon =
                        CashbonBookItemModel.fromJson(bookMessage.data);
                    int balance = 0;

                    for (BookMessageDataModel element in bookMessageList) {
                      if (element.topicSequenceNumber <=
                          bookMessage.topicSequenceNumber) {
                        final check =
                            CashbonBookItemModel.fromJson(element.data);

                        balance += check.debit;
                        balance -= check.credit;
                      }
                    }

                    return [
                      // formatNumber(bookMessage.topicSequenceNumber.toString()),
                      CustomDateUtils.simpleFormat(cashbon.date),
                      cashbon.memberBook.name,
                      formatAmount(cashbon.memberBook.limitPayable),
                      formatAmount(cashbon.debit),
                      formatAmount(cashbon.credit),
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
      if (currentBook == null) return const SizedBox();

      final isLoading = context
          .select((BookCubit element) => element.state is BookMessageLoading);

      List<CashbonBookItemModel> cashbonBookList = [];

      bookMessageList.forEach((bookMessage) {
        final cashbon = CashbonBookItemModel.fromJson(bookMessage.data);
        if (cashbon.memberBook.email == payableMemberSelected?.email) {
          cashbonBookList.add(cashbon);
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
              children: (currentBook?.memberBookList ?? [])
                  .map((member) => InkWell(
                        onTap: () {
                          setState(() {
                            payableMemberSelected = member;
                          });
                        },
                        child: Chip(
                          backgroundColor: payableMemberSelected == member
                              ? Colors.orange
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
                "Payable Limit : ${formatAmount(cashbonBookList.lastOrNull?.memberBook.limitPayable ?? 0)}",
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
                "Credit",
                "Debit",
                "Balanced",
              ],
              rows: cashbonBookList
                  .map((cashbon) {
                    int balance = 0;

                    for (var element in cashbonBookList) {
                      if (element.sequenceNumber <= cashbon.sequenceNumber) {
                        balance += element.debit;
                        balance -= element.credit;
                      }
                    }

                    return [
                      // cashbon.memberBook.email,
                      CustomDateUtils.simpleFormat(cashbon.date),
                      formatAmount(cashbon.debit),
                      formatAmount(cashbon.credit),
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
