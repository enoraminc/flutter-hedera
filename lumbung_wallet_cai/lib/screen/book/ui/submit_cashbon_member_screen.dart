part of '../book.dart';

class SubmitCashbonMemberScreen extends StatefulWidget {
  const SubmitCashbonMemberScreen({
    super.key,
    required this.bookId,
  });
  final String bookId;

  @override
  State<SubmitCashbonMemberScreen> createState() =>
      _SubmitCashbonMemberScreenState();
}

class _SubmitCashbonMemberScreenState
    extends BaseStateful<SubmitCashbonMemberScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController amountController = TextEditingController();

  HederaWallet? selectedWallet;

  String type = "Credit";

  void onSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<JournalCubit>().submitCashbonMember(
          type: type,
          amount: int.tryParse(amountController.text.replaceAll(".", "")) ?? 0,
        );
  }

  @override
  Widget body() {
    return BlocListener<JournalCubit, JournalState>(
      listener: (context, state) {
        if (state is SubmitJournalLoading) {
          loading = LoadingUtil.build(context);
          loading?.show();
        } else {
          loading?.dismiss();
        }

        if (state is SetJournalSuccess) {
          context.pop();
        } else if (state is JournalFailed) {
          showSnackBar(state.message, isError: true);
        }
      },
      child: BaseCaiScreen(
        mainWidget: Form(
          key: _formKey,
          child: Container(
            color: Theme.of(context).backgroundColor,
            width: CustomFunctions.isMobile(context)
                ? MediaQuery.of(context).size.width
                : 650,
            child: ListView(
              physics: const ClampingScrollPhysics(),
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bodyHeader(),
                const SizedBox(height: 15),
                // walletSelector(),
                // const SizedBox(height: 15),
                cashbonTypeField(),
                const SizedBox(height: 15),
                amountField(),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget amountField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: CustomTextFormField(
        controller: amountController,
        text: "Amount",
        keyboardType: TextInputType.number,
        hint: "Amount..",
        isNumber: true,
        onChanged: (value) {},
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Amount field is required';
          }

          return null;
        },
      ),
    );
  }

  Widget walletSelector() {
    return Builder(builder: (context) {
      final book = context
          .select((JournalCubit element) => element.state.selectedJournal);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Member",
              style: Styles.commonTextStyle(
                size: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            MainWalletSelector(
              activeWallet: selectedWallet,
              memberWalletList: (book?.memberList ?? [])
                  .map((e) => HederaWallet.empty().copyWith(
                        email: e.email,
                        displayName: e.name,
                        profileImage: "",
                      ))
                  .toList(),
              onChange: (wallet) {
                setState(() {
                  selectedWallet = wallet;
                });
              },
            ),
          ],
        ),
      );
    });
  }

  Widget cashbonTypeField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Type",
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
                  color: Theme.of(context).buttonColor,
                  width: 1.0,
                ),
              ),
              padding: const EdgeInsets.only(left: 10),
              alignment: Alignment.center,
              child: DropdownSearch<String>(
                popupProps: PopupProps.menu(
                  menuProps: MenuProps(
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
                  ),
                  showSearchBox: false,
                  textStyle: Theme.of(context).primaryTextTheme.bodyText1,
                ),
                dropdownSearchTextStyle:
                    Theme.of(context).primaryTextTheme.bodyText1,
                dropdownSearchDecoration: InputDecoration(
                  hintText: "Select Type",
                  contentPadding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
                  border: InputBorder.none,
                  hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                ),
                items: const ["Credit", "Debit"],
                onChanged: (String? t) {
                  setState(() {
                    type = t ?? "";
                  });
                },
                itemAsString: (type) => type,
                selectedItem: type,
                validator: (t) =>
                    (t?.isEmpty ?? false) ? "This field is required" : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bodyHeader() {
    return Builder(builder: (context) {
      return Container(
        height: 56.0,
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          border: Border(
            right: BorderSide(
              width: 1,
              color: Theme.of(context).appBarTheme.backgroundColor!,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
                color: Theme.of(context).textSelectionTheme.cursorColor,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      text: "Submit Cashbon Member",
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15.0),
              SizedBox(
                height: 50,
                width: 100,
                child: RoundedButton(
                  text: "Submit",
                  onPressed: onSave,
                  selected: true,
                  selectedColor: Colors.orange,
                  isSmall: true,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
