import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lumbung_common/model/hedera/wallet.dart';

import '../core/utils/text_styles.dart';

class MainWalletSelector extends StatelessWidget {
  final List<HederaWallet> memberWalletList;
  final HederaWallet? activeWallet;
  final  Function(HederaWallet? wallet) onChange;

  const MainWalletSelector({
    super.key,
    required this.memberWalletList,
    required this.activeWallet,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).appBarTheme.backgroundColor,
        ),
        padding: const EdgeInsets.only(left: 10),
        alignment: Alignment.center,
        child: DropdownSearch<HederaWallet>(
          popupProps: PopupProps.dialog(
            dialogProps: DialogProps(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            ),
            showSearchBox: true,
            textStyle: Styles.commonTextStyle(
              size: 18,
              fontWeight: FontWeight.bold,
            ),
            searchFieldProps: TextFieldProps(
              style: Styles.commonTextStyle(
                size: 18,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: "Search User",
                border: const OutlineInputBorder(),
                hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
              ),
            ),
          ),
          dropdownSearchTextStyle: Theme.of(context).primaryTextTheme.bodyText1,
          dropdownSearchDecoration: InputDecoration(
            hintText: "Select User",
            contentPadding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
            border: InputBorder.none,
            hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
          ),
          items: memberWalletList.toList(),
          onChanged: onChange,
          itemAsString: (type) => "${type.displayName} - ${type.email}",
          selectedItem: activeWallet,
        ),
      ),
    );
  }
}
