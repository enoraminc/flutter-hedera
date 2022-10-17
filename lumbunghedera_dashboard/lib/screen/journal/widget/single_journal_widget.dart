part of '../journal.dart';

class SingleJournalWidget extends StatelessWidget {
  const SingleJournalWidget(
      {super.key,
      required this.journal,
      required this.onTap,
      required this.isSelected});

  final JournalModel journal;
  final Function() onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
          gradient: isSelected
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
              journal.title,
              style: Styles.commonTextStyle(
                size: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              journal.description,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: Styles.commonTextStyle(
                size: 14,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              runSpacing: 10,
              spacing: 10,
              children: [
                Chip(
                  label: Text(
                    journal.type,
                    style: Styles.commonTextStyle(
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.orange,
                ),
                Chip(
                  label: Text(
                    journal.state,
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
      ),
    );
  }
}
