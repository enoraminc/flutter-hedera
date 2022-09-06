import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:lumbunghedera_dashboard/shared_widget/rounded_button.dart';

import '../core/utils/custom_function.dart';
import '../core/utils/text_styles.dart';

class CustomTableWidget extends StatelessWidget {
  const CustomTableWidget({
    Key? key,
    required this.title,
    required this.columns,
    required this.rows,
    required this.isLoading,
    this.onSort,
    this.onTap,
    this.onSeeAllTap,
    this.isWithPadding = true,
  }) : super(key: key);

  final String title;

  final List<String> columns;
  final List<List<String>> rows;
  final bool isLoading;
  final Function(int colIndex)? onSort;
  final Function(String id)? onTap;
  final Function()? onSeeAllTap;
  final bool isWithPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isWithPadding ? 10 : 0),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (isWithPadding) const SizedBox(width: 20),
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
              if (onSeeAllTap != null) ...[
                RoundedButton(
                  text: "See All",
                  selected: true,
                  isSmall: true,
                  selectedColor: Colors.orange,
                  onPressed: () {
                    onSeeAllTap?.call();
                  },
                ),
                if (isWithPadding) const SizedBox(width: 20),
              ],
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
                    showCheckboxColumn: false, // <-- this is important
                    columns: columns
                        .map(
                          (item) => DataColumn(
                              label: Text(
                                item,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyText1,
                              ),
                              onSort: (colIndex, _) {
                                onSort?.call(colIndex);
                              }),
                        )
                        .toList(),
                    rows: rows.map((items) {
                      return DataRow(
                        onSelectChanged: (newValue) {
                          onTap?.call(items.first);
                        },
                        cells: items
                            .map(
                              (item) => DataCell(
                                Text(
                                  item,
                                  style: Styles.commonTextStyle(
                                    size: 16,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
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
