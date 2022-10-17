part of '../journal.dart';

class CashbonPayableWidget extends BaseStateless {
  CashbonPayableWidget({
    Key? key,
    required this.currentJournal,
    required this.concensusMessageDataList,
  }) : super(key: key);

  final JournalModel? currentJournal;
  final List<ConcensusMessageDataModel> concensusMessageDataList;

  final ValueNotifier<MemberModel?> payableMemberSelectedNotifier =
      ValueNotifier(null);

  @override
  Widget body(BuildContext context) {
    return Builder(builder: (context) {
      if (currentJournal == null) return const SizedBox();

      final isLoading = context.select(
          (JournalCubit element) => element.state is JournalMessageLoading);

      List<ConcensusMessageDataModel> memberBookMessageList = [];

      return ValueListenableBuilder<MemberModel?>(
          valueListenable: payableMemberSelectedNotifier,
          builder: (context, memberNotifier, _) {
            concensusMessageDataList.forEach((bookMessage) {
              final cashbon = PodModel.fromJson(bookMessage.data);
              if (cashbon.laci?.member.email == memberNotifier?.email) {
                memberBookMessageList.add(bookMessage);
              }
            });

            final memberList = CashbonAdditionalDataModel.fromMap(
                    currentJournal?.additionalData ?? {})
                .memberList;

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
                    children: (memberList)
                        .map((member) => InkWell(
                              onTap: () {
                                payableMemberSelectedNotifier.value = member;
                              },
                              child: Chip(
                                backgroundColor:
                                    memberNotifier?.email == member.email
                                        ? Colors.green
                                        : Colors.grey,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 10,
                                ),
                                label: Text(
                                  member.email,
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
                  if (memberNotifier != null) ...[
                    Text(
                      "Member : ${memberNotifier.name}",
                      style: Styles.commonTextStyle(
                        size: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Payable Limit : ${formatAmount(memberNotifier.limitPayable)}",
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
                            CustomDateUtils.simpleFormatWithTime(
                                cashbon.laci?.date),
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
    });
  }
}

class ReceivableCashbonJournalWidget extends BaseStateless {
  const ReceivableCashbonJournalWidget({
    super.key,
    required this.concensusMessageDataList,
  });

  final List<ConcensusMessageDataModel> concensusMessageDataList;
  @override
  Widget body(BuildContext context) {
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
              // onExport: () {
              // context
              //     .read<JournalCubit>()
              //     .exportJournal(concensusMessageDataList);
              // },
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
}
