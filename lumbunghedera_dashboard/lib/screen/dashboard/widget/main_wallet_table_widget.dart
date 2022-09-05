part of '../dashboard.dart';

class CustomTableWidget extends StatelessWidget {
  const CustomTableWidget({
    Key? key,
    required this.title,
    required this.columns,
    required this.rows,
    required this.isLoading,
    this.onSort,
  }) : super(key: key);

  final String title;

  final List<String> columns;
  final List<List<String>> rows;
  final bool isLoading;
  final Function(int colIndex)? onSort;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: Styles.commonTextStyle(
                    size: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              RoundedButton(
                text: "See All",
                selected: true,
                isSmall: true,
                selectedColor: Colors.orange,
                onPressed: () {},
              ),
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 10),
          isLoading
              ? FadeShimmer(
                  height: 300,
                  width: double.infinity,
                  radius: 4,
                  fadeTheme: CustomFunctions.isDarkTheme(context)
                      ? FadeTheme.dark
                      : FadeTheme.light,
                )
              : SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    columns: columns
                        .map(
                          (item) => DataColumn(
                              label: Text(item),
                              onSort: (colIndex, _) {
                                onSort?.call(colIndex);
                              }),
                        )
                        .toList(),
                    rows: rows.map((items) {
                      return DataRow(
                        cells: items
                            .map(
                              (item) => DataCell(
                                Text(item),
                              ),
                            )
                            .toList(),
                      );
                    }).toList(),
                  ),
                ),
        ],
      ),
    );
  }
}
