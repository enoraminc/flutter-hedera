import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:lumbunghedera_dashboard/shared_widget/rounded_button.dart';

import '../core/utils/custom_function.dart';
import '../core/utils/text_styles.dart';
import 'package:data_table_2/data_table_2.dart';

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
    this.onExport,
    this.isWithPadding = true,
    this.rowHeight,
  }) : super(key: key);

  final String title;

  final List<String> columns;
  final List<List<String>> rows;
  final bool isLoading;
  final Function(int colIndex)? onSort;
  final Function(String id)? onTap;
  final Function()? onSeeAllTap;
  final bool isWithPadding;
  final Function()? onExport;
  final double? rowHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isWithPadding ? 10 : 0),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      width: double.infinity,
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
              if (onExport != null) ...[
                const SizedBox(width: 10),
                RoundedButton(
                  text: "Export",
                  selected: true,
                  isSmall: true,
                  selectedColor: Colors.orange,
                  onPressed: () {
                    onExport?.call();
                  },
                ),
              ],
              if (onSeeAllTap != null) ...[
                const SizedBox(width: 10),
                RoundedButton(
                  text: "See All",
                  selected: true,
                  isSmall: true,
                  selectedColor: Colors.orange,
                  onPressed: () {
                    onSeeAllTap?.call();
                  },
                ),
              ],
              if (isWithPadding) const SizedBox(width: 20),
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
                    dataRowHeight: rowHeight,
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

class CustomTableWidget2 extends StatelessWidget {
  const CustomTableWidget2({
    Key? key,
    required this.title,
    required this.columns,
    required this.rows,
    required this.isLoading,
    this.onSort,
    this.onTap,
    this.isWithPadding = true,
    this.buttonList = const [],
    this.specificRowHeight = 150,
  }) : super(key: key);

  final String title;

  final List<String> columns;
  final List<List<String>> rows;
  final bool isLoading;
  final Function(int colIndex)? onSort;
  final Function(String id)? onTap;
  final bool isWithPadding;
  final List<Widget> buttonList;
  final double specificRowHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isWithPadding ? 10 : 0),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      width: double.infinity,
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
              if (buttonList.isNotEmpty) ...buttonList,
              if (isWithPadding) const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 10),
          isLoading
              ? Expanded(
                  child: FadeShimmer(
                    height: double.infinity,
                    width: double.infinity,
                    radius: 4,
                    fadeTheme: CustomFunctions.isDarkTheme(context)
                        ? FadeTheme.dark
                        : FadeTheme.light,
                  ),
                )
              : Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: DataTable2(
                      showCheckboxColumn: false, // <-- this is important
                      columnSpacing: 12,
                      horizontalMargin: 12,
                      minWidth: 600,
                      columns: columns
                          .map(
                            (item) => DataColumn2(
                                fixedWidth: item == columns.first ? 180 : null,
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
                        return DataRow2(
                          onSelectChanged: (newValue) {
                            onTap?.call(items.first);
                          },
                          specificRowHeight: specificRowHeight,
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
                ),
        ],
      ),
    );
  }
}
