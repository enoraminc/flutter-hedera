import 'package:flutter/material.dart';

import '../core/utils/pallete.dart';
import '../core/utils/text_styles.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final bool selected;
  final Color? selectedColor;
  final Color unselectedColor;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isRounded;
  final bool isSmall;

  const RoundedButton({
    Key? key,
    required this.text,
    this.selected = false,
    this.selectedColor,
    this.unselectedColor = Colors.grey,
    this.isRounded = false,
    this.isSmall = false,
    this.onPressed,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MaterialColor? color = generateMaterialColor(
        selectedColor ?? Theme.of(context).colorScheme.secondary);

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        primary: color.shade700,
        backgroundColor: selected ? color.shade500 : Palette.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isRounded ? 100 : 10.0),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: isSmall ? 10 : 16),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
            ],
            if (icon != null && text.isNotEmpty) const SizedBox(width: 10),
            Text(
              text,
              style: Styles.commonTextStyle(
                color: selected ? Palette.white : Palette.textColor,
                fontWeight: FontWeight.bold,
                size: isSmall ? 16 : 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
