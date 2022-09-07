part of '../book.dart';

class CreateBookScreen extends StatefulWidget {
  const CreateBookScreen({super.key});

  @override
  State<CreateBookScreen> createState() => _CreateBookScreenState();
}

class _CreateBookScreenState extends BaseStateful<CreateBookScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController limitController = TextEditingController();

  List<MemberBook> memberBookList = [];

  HederaWallet? activeWallet;
  List<HederaWallet> walletSelectedList = [];
  HederaSubWallet? subWalletSelected;

  String bookType = BookModel.cashbonType;

  void onSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // HederaWallet? wallet =
    //     context.read<MemberWalletCubit>().state.selectedWallet ??
    //         HederaWallet.empty();

    final book = BookModel(
      id: "",
      topicId: "",
      subWalletId: subWalletSelected?.id ?? "-",
      title: titleController.text,
      description: descriptionController.text,
      memberBookList: memberBookList,
      network: "",
      type: bookType,
      state: BookModel.activeState,
    );

    context.read<BookCubit>().setBook(book);
  }

  @override
  Widget body() {
    return BlocListener<BookCubit, BookState>(
      listener: (context, state) {
        if (state is SubmitBookLoading) {
          loading = LoadingUtil.build(context);
          loading?.show();
        } else {
          loading?.dismiss();
        }

        if (state is SetBookSuccess) {
          context.pop();
        } else if (state is BookFailed) {
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
                setSubWalletWidget(),
                const SizedBox(height: 15),
                titleField(),
                const SizedBox(height: 15),
                descriptionField(),
                const SizedBox(height: 15),
                bookTypeField(),
                const SizedBox(height: 15),
                setLimitMemberWidget(),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget titleField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: CustomTextFormField(
        controller: titleController,
        text: "Title",
        keyboardType: TextInputType.text,
        hint: "title..",
        onChanged: (value) {},
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Title field is required';
          }

          return null;
        },
      ),
    );
  }

  Widget descriptionField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: CustomTextFormField(
        controller: descriptionController,
        text: "Description",
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        hint: "description..",
        onChanged: (value) {},
        validator: (value) {
          return null;
        },
      ),
    );
  }

  Widget bookTypeField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: BookTypeSelectorWidget(
        onChange: (String? type) {
          setState(() {
            if (type?.isNotEmpty ?? false) {
              bookType = type ?? "";
            }
          });
        },
        selectedType: bookType,
      ),
    );
  }

  Builder setSubWalletWidget() {
    return Builder(
      builder: (context) {
        final subWalletList = context
            .select((SubWalletCubit element) => element.state.subWalletList);

        final isLoading = context.select(
            (SubWalletCubit element) => element.state is SubWalletLoading);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Set Sub Wallet",
                style: Styles.commonTextStyle(
                  size: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (isLoading)
                FadeShimmer(
                  height: 50,
                  width: double.infinity,
                  radius: 4,
                  fadeTheme: CustomFunctions.isDarkTheme(context)
                      ? FadeTheme.dark
                      : FadeTheme.light,
                )
              else
                SubWalletSelector(
                  activeWallet: subWalletSelected,
                  subWalletList: subWalletList
                      .where((element) => element.id != subWalletSelected?.id)
                      .toList(),
                  onChange: (wallet) {
                    setState(() {
                      subWalletSelected = wallet;
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Builder setLimitMemberWidget() {
    return Builder(
      builder: (context) {
        // final memberWalletList = context.select(
        //     (MemberWalletCubit element) => element.state.memberWalletList);

        // final isLoading = context.select((MemberWalletCubit element) =>
        //     element.state is MemberWalletLoading);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Set Limit Payable Member",
                style: Styles.commonTextStyle(
                  size: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // if (isLoading)
              //   FadeShimmer(
              //     height: 50,
              //     width: double.infinity,
              //     radius: 4,
              //     fadeTheme: CustomFunctions.isDarkTheme(context)
              //         ? FadeTheme.dark
              //         : FadeTheme.light,
              //   )
              // else
              Row(
                children: [
                  Expanded(
                    child: MainWalletSelector(
                      activeWallet: activeWallet,
                      memberWalletList: (subWalletSelected?.userList ?? [])
                          .map((e) => HederaWallet.empty().copyWith(
                                email: e.email,
                                displayName: e.name,
                                profileImage: e.avatarUrl,
                              ))
                          .where((element) => !walletSelectedList
                              .map((e) => e.email)
                              .toList()
                              .contains(element.email))
                          .toList(),
                      onChange: (wallet) {
                        setState(() {
                          activeWallet = wallet;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextFormField(
                      controller: limitController,
                      text: "Limit",
                      keyboardType: TextInputType.number,
                      hint: "Limit..",
                      fieldOnly: true,
                      onChanged: (value) {},
                      validator: (value) {
                        return null;
                      },
                      isNumber: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  RoundedButton(
                    text: "",
                    selected: true,
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    selectedColor: Colors.orange,
                    onPressed: () {
                      setState(() {
                        if (activeWallet != null) {
                          walletSelectedList.add(activeWallet!);
                          memberBookList.add(
                            MemberBook(
                                email: activeWallet?.email ?? "",
                                name: activeWallet?.displayName ?? "",
                                limitPayable: int.tryParse(limitController.text
                                        .replaceAll(".", "")) ??
                                    0),
                          );
                        }
                        activeWallet = null;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Limit Payable Member List",
                style: Styles.commonTextStyle(
                  size: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (memberBookList.isEmpty)
                Center(
                  child: Text(
                    "Limit Payable Member List is Empty",
                    textAlign: TextAlign.center,
                    style: Styles.commonTextStyle(
                      size: 16,
                    ),
                  ),
                ),
              ...memberBookList
                  .map(
                    (book) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context).buttonColor,
                          width: 1.0,
                        ),
                      ),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            height: 20,
                            width: 5,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "${book.name} - ${book.email}",
                              style: Styles.commonTextStyle(
                                size: 18,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              formatAmount(book.limitPayable),
                              style: Styles.commonTextStyle(
                                size: 18,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              setState(() {
                                walletSelectedList.removeWhere(
                                    (element) => element.email == book.email);
                                memberBookList.removeWhere(
                                    (element) => element.email == book.email);
                              });
                            },
                            child: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        );
      },
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
                      text: "Create Book",
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15.0),
              SizedBox(
                height: 50,
                width: 100,
                child: RoundedButton(
                  text: "Save",
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
