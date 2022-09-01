import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../core/utils/text_formatter.dart';
import '../core/utils/text_styles.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.text = "",
    this.additionalText = "",
    this.isDecimal = false,
    this.isNumber = false,
    this.readOnly = false,
    this.digitOnly = false,
    this.isPercentage = false,
    this.hint,
    this.onChanged,
    this.maxLines,
    this.suffix,
    this.prefix,
    required this.validator,
  }) : super(key: key);

  final TextEditingController controller;
  final TextInputType keyboardType;
  final String text;
  final String additionalText;
  final bool isDecimal;
  final bool isNumber;
  final bool readOnly;
  final bool digitOnly;
  final bool isPercentage;
  final String? hint;
  final Function(String t)? onChanged;
  final int? maxLines;
  final Widget? suffix;
  final Widget? prefix;

  final String? Function(String? t)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: Styles.commonTextStyle(
                  size: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              additionalText,
              style: Styles.commonTextStyle(
                size: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: Border.all(
              color: Theme.of(context).buttonColor,
              width: 1.0,
            ),
          ),
          padding: const EdgeInsets.only(left: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              prefix != null ? prefix! : const SizedBox(),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  readOnly: readOnly,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    // labelText: "$text...",
                    hintText: hint ?? "Masukkan $text..",

                    hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                    // suffixIcon: suffix,
                  ),
                  cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                  style: Theme.of(context).primaryTextTheme.bodyText1,
                  maxLines: maxLines,
                  inputFormatters: [
                    if (isDecimal) ThousandsFormatter(allowFraction: true),
                    if (isNumber) ThousandsFormatter(),
                    if (digitOnly) FilteringTextInputFormatter.digitsOnly,
                    if (isPercentage)
                      FilteringTextInputFormatter.allow(
                          RegExp(r'(^\d*\.?\d{0,2})')),
                    UpperCaseTextFormatter(),
                  ],
                  autofocus: false,
                  onChanged: onChanged,
                  validator: validator,
                ),
              ),
              suffix != null ? suffix! : const SizedBox(),
              SizedBox(width: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    String value = newValue.text;

    if (value.contains(".") &&
        value.substring(value.indexOf(".") + 1).length > decimalRange) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == ".") {
      truncated = "0.";

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
    } else if (value.contains(".")) {
      String tempValue = value.substring(value.indexOf(".") + 1);
      if (tempValue.contains(".")) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      }
      if (value.indexOf(".") == 0) {
        truncated = "0" + truncated;
        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }
    }
    if (value.contains(" ") || value.contains("-")) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    }

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
