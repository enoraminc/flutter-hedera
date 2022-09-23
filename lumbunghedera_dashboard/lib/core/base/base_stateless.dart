import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:hedera_core/utils/log.dart';

abstract class BaseStateless extends StatelessWidget {
  const BaseStateless({Key? key}) : super(key: key);

  // /// Access the Navigation Service
  // final NavigationService nav = NavigationService.instance;

  // /// Access app Text Style Theme
  // final TextStyleTheme tTheme = TextStyleTheme.instance;

  // /// Access SVG with this property
  // final SVGDirectory svgDir = SVGDirectory.instance;

  // /// Access messenger service with this property
  // final MessengerService messenger = MessengerService.instance;

  String formatNumber(String s) =>
      NumberFormat.decimalPattern('id').format(num.tryParse(s) ?? 0);

  String formatAmount(num? amount) {
    if (amount != null) {
      NumberFormat rpFormat = NumberFormat.simpleCurrency(locale: 'in_id');
      return rpFormat
          .format(amount)
          .replaceAll(RegExp('Rp'), 'Rp. ')
          .replaceAll(',00', '');
    }
    return 'Rp. 0';
  }

  double stringToNumber(String s) =>
      double.tryParse(s.replaceAll(",", ".").replaceAll(".", "").trim()) ?? 0;

  double decimalStringToNumber(String s) =>
      double.tryParse(s.replaceAll(".", "").replaceAll(",", ".")) ?? 0;

  String decimalNumberToString(num s) => "$s".replaceAll(".", ",");

  /// Print log for debugging with this function
  void setLog(dynamic desc, {String method = "Log"}) {
    Log.setLog(desc, method: method);
  }

  /// Show snackbar with this function
  void showSnackBar(
    BuildContext context,
    String message, {
    Widget? snackbar,
    String? leadingIcon,
    Widget? leading,
    Widget? trailing,
    String? actionText,
    double? bottomPadding = 100.0,
    bool isError = false,
    void Function()? actionCallback,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor:
              isError ? Colors.red : Theme.of(context).colorScheme.secondary,
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // Body Constraints
  Widget bodyConstraints({required Widget child, double maxWidth = 1200}) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  /// Body of the page
  Widget body(BuildContext context);

  void calculateBottomInsets() {}

  @override
  Widget build(BuildContext context) {
    // setStatusBarColorToPrimary();
    return body(context);
  }
}
