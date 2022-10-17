part of '../journal.dart';

class JournalMemberListWidget extends StatelessWidget {
  const JournalMemberListWidget({
    Key? key,
    required this.memberList,
    this.title = "Member List",
  }) : super(key: key);

  final List<User> memberList;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Styles.commonTextStyle(
            size: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ...memberList
            .map(
              (member) => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey.withOpacity(.4),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.displayName ?? "-",
                      style: Styles.commonTextStyle(
                        size: 18,
                      ),
                    ),
                    const SizedBox(height: 5),
                    if (member.email != null)
                      Text(
                        member.email ?? "-",
                        style: Styles.commonTextStyle(
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                  ],
                ),
              ),
            )
            .toList(),
        const SizedBox(height: 10),
      ],
    );
  }
}
