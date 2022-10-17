part of '../journal.dart';

class VoteConcensusWidget extends BaseStateless {
  const VoteConcensusWidget({
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
              title: 'Vote Table',
              isLoading: isLoading,
              isWithPadding: false,
              columns: const [
                // "Sequence Number",
                "Name",
                "Email",
                "Note",
                "Voted At",
              ],
              rows: concensusMessageDataList
                  .map((message) {
                    final vote = VoteJournalItemModel.fromJson(message.data);

                    return [
                      vote.memberVote.name,
                      vote.memberVote.email,
                      vote.note,
                      CustomDateUtils.simpleFormatWithTime(vote.votedAt),
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
