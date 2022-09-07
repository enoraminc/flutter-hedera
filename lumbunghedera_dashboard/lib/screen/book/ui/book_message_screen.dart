part of '../book.dart';

class BookMessageScreen extends StatefulWidget {
  const BookMessageScreen({super.key, required this.topicId});
  final String topicId;

  @override
  State<BookMessageScreen> createState() => _BookMessageScreenState();
}

class _BookMessageScreenState extends BaseStateful<BookMessageScreen> {
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
    context.read<BookCubit>().getBookMessageData(widget.topicId);

    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  void initState() {
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
          const SizedBox(height: 20),
          bookInfoWidget(),
          const SizedBox(height: 20),
          // messageListWidget(),
        ],
      ),
    );
  }

  Builder bookInfoWidget() {
    return Builder(builder: (context) {
      final isLoading = context
          .select((BookCubit element) => element.state is BookMessageLoading);

      final bookSelected = context.select((BookCubit element) => element
          .state.bookList
          .firstWhereOrNull((element) => element.topicId == widget.topicId));

      // final subWalletSelected = context.select((SubWalletCubit element) =>
      //     element.state.subWalletList.firstWhereOrNull((element) =>
      //         element.accountId == bookSelected?.subWalletId));

      if (bookSelected == null) return const SizedBox();

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
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            CustomTableWidget(
              title: 'Data',
              isLoading: isLoading,
              isWithPadding: false,
              onExport: () {
                context.read<BookCubit>().exportBook(bookMessageList);
              },
              columns: const [
                "Sequence Number",
                "Date",
                "Member",
                "Limit Payable",
                "Debit",
                "Credit",
                "Balance",
              ],
              rows: bookMessageList.map((bookMessage) {
                final cashbon = CashbonBookItemModel.fromJson(bookMessage.data);
                int balance = 0;

                for (BookMessageDataModel element in bookMessageList) {
                  if (element.topicSequenceNumber <=
                      bookMessage.topicSequenceNumber) {
                    final check = CashbonBookItemModel.fromJson(element.data);

                    balance += check.debit;
                    balance -= check.credit;
                  }
                }

                return [
                  formatNumber(bookMessage.topicSequenceNumber.toString()),
                  CustomDateUtils.simpleFormat(cashbon.date),
                  cashbon.memberBook.name,
                  formatAmount(cashbon.memberBook.limitPayable),
                  formatAmount(cashbon.debit),
                  formatAmount(cashbon.credit),
                  formatAmount(balance),
                ];
              }).toList(),
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
