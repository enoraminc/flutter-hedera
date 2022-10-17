part of '../journal.dart';

class DetailJournalWidget extends StatelessWidget {
  const DetailJournalWidget({super.key, required this.selectedId});

  final String selectedId;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final isLoading = context.select(
          (JournalCubit element) => element.state is JournalMessageLoading);

      final journalSelected = context.select((JournalCubit element) => element
          .state.journalList
          .firstWhereOrNull((element) => element.topicId == selectedId));

      // final subWalletSelected = context.select((SubWalletCubit element) =>
      //     element.state.subWalletList.firstWhereOrNull((element) =>
      //         element.accountId == bookSelected?.subWalletId));

      if (journalSelected == null) {
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
                  journalSelected.title,
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
                      journalSelected.type,
                      style: Styles.commonTextStyle(
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.orange,
                  ),
                  Chip(
                    label: Text(
                      journalSelected.state,
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
            journalSelected.description,
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
              if (journalSelected.isActive()) ...[
                if (journalSelected.isVoteType()) ...[
                  RoundedButton(
                    text: "Submit Vote",
                    selected: true,
                    isSmall: true,
                    selectedColor: Colors.orange,
                    onPressed: () {
                      context.read<VoteCubit>().submitVoteMember(
                            journalId: journalSelected.id,
                            note: "",
                          );
                    },
                  ),
                  const SizedBox(width: 10),
                ],
                RoundedButton(
                  text: "View Data",
                  selected: true,
                  isSmall: true,
                  selectedColor: Colors.orange,
                  onPressed: () {
                    context.push(
                        "${Routes.journal}/${Routes.concensus}/$selectedId");
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
                        "${HederaUtils.getHederaExplorerUrl()}/search-details/topic/$selectedId");
                  },
                ),
              ],
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
          const Divider(),
          const SizedBox(height: 10),
          if (journalSelected.isVoteType()) ...[
            Builder(builder: (context) {
              final participants = VoteAdditionalDataModel.fromMap(
                      journalSelected.additionalData)
                  .participant;
              return JournalMemberListWidget(
                title: "Participants",
                memberList: participants
                    .map((e) => User(
                          displayName: e,
                        ))
                    .toList(),
              );
            }),
          ],
          if (journalSelected.isCashbonType()) ...[
            Builder(builder: (context) {
              final memberList = CashbonAdditionalDataModel.fromMap(
                      journalSelected.additionalData)
                  .memberList;
              return JournalMemberListWidget(
                title: "Member List",
                memberList: memberList
                    .map((e) => User(
                          displayName: e.name,
                          email: e.email,
                        ))
                    .toList(),
              );
            }),
          ],
        ],
      );
    });
  }
}
