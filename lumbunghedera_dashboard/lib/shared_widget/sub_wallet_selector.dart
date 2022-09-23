import 'package:hedera_core/model/hedera_sub_wallet.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../core/utils/text_styles.dart';

class SubWalletSelector extends StatelessWidget {
  final HederaSubWallet? activeWallet;
  final List<HederaSubWallet> subWalletList;
  final Function(HederaSubWallet? wallet) onChange;

  const SubWalletSelector({
    super.key,
    required this.activeWallet,
    required this.subWalletList,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(
            color: Theme.of(context).buttonColor,
            width: 1.0,
          ),
          color: Theme.of(context).appBarTheme.backgroundColor,
        ),
        padding: const EdgeInsets.only(left: 10),
        alignment: Alignment.center,
        child: DropdownSearch<HederaSubWallet>(
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
                hintText: "Search Sub Wallet",
                border: const OutlineInputBorder(),
                hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
              ),
            ),
          ),
          dropdownSearchTextStyle: Theme.of(context).primaryTextTheme.bodyText1,
          dropdownSearchDecoration: InputDecoration(
            hintText: "Select Sub Wallet",
            contentPadding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
            border: InputBorder.none,
            hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
          ),
          items: subWalletList.toList(),
          onChanged: onChange,
          itemAsString: (type) => "${type.title} - ${type.accountId}",
          selectedItem: activeWallet,
          validator: (t) => t?.id == null ? "This field is required" : null,
        ),
      ),
    );
  }
}
