part of '../journal.dart';

class GoalConcensusWidget extends BaseStateless {
  const GoalConcensusWidget({
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
              title: 'Goal Table',
              isLoading: isLoading,
              isWithPadding: false,
              columns: const [
                "Email",
                "Username",
                "WA Number",
                "Business Name",
                "Social Media",
                "Location",
                "Business Age",
                "Revenue",
                "Margin",
                "Timestamp"
              ],
              rows: concensusMessageDataList
                  .map((message) {
                    final goal = GoalJournalItemModel.fromJson(message.data);

                    return [
                      goal.email,
                      goal.username,
                      goal.waNumber,
                      goal.bName,
                      goal.bSocialMedia,
                      goal.bLocation,
                      goal.bAge,
                      goal.revenue,
                      goal.margin,
                      CustomDateUtils.simpleFormatWithTime(goal.createdAt),
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
