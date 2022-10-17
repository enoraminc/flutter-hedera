part of '../wallet.dart';

class SubWalletTypeSelectorWidget extends StatelessWidget {
  final String? selectedType;
  final Function(String? type) onChange;

  const SubWalletTypeSelectorWidget({
    super.key,
    required this.selectedType,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sub Wallet Type",
          style: Styles.commonTextStyle(
            size: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonHideUnderline(
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).appBarTheme.backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 1.0,
              ),
            ),
            padding: const EdgeInsets.only(left: 10),
            alignment: Alignment.center,
            child: DropdownSearch<String>(
              popupProps: PopupProps.dialog(
                dialogProps: DialogProps(
                  backgroundColor:
                      Theme.of(context).appBarTheme.backgroundColor,
                ),
                showSearchBox: false,
                textStyle: Theme.of(context).primaryTextTheme.bodyText1,
                itemBuilder: (context, item, isSelected) => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.grey.withOpacity(.4),
                    ),
                  ),
                  child: Text(
                    item,
                    style: Styles.commonTextStyle(
                      size: 16,
                    ),
                  ),
                ),
              ),
              dropdownBuilder: (context, item) => Text(
                item ?? "Select Type",
                style: Styles.commonTextStyle(
                  size: 16,
                ),
              ),
              dropdownSearchTextStyle:
                  Theme.of(context).primaryTextTheme.bodyText1,
              dropdownSearchDecoration: InputDecoration(
                hintText: "Select Sub Wallet Type",
                contentPadding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
                border: InputBorder.none,
                hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
              ),
              items: HederaSubWallet.typeList.toList(),
              onChanged: onChange,
              itemAsString: (type) => type,
              selectedItem: selectedType,
              validator: (t) =>
                  (t?.isEmpty ?? false) ? "This field is required" : null,
            ),
          ),
        ),
      ],
    );
  }
}
