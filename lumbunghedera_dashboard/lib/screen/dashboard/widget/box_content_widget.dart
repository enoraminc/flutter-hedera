part of '../dashboard.dart';

class BoxContentWidget extends StatelessWidget {
  const BoxContentWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.isLoading,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String value;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon),
              const SizedBox(width: 10),
              Text(
                title,
                style: Styles.commonTextStyle(
                  size: 16,
                  // fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          isLoading
              ? FadeShimmer(
                  height: 15,
                  width: double.infinity,
                  radius: 4,
                  fadeTheme: CustomFunctions.isDarkTheme(context)
                      ? FadeTheme.dark
                      : FadeTheme.light,
                )
              : Text(
                  value,
                  style: Styles.commonTextStyle(
                    size: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
        ],
      ),
    );
  }
}
