part of '../book.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends BaseStateful<BookScreen> {
  String? selectedComponent;

  void _selectComponent(String title) {
    if (selectedComponent != title) {
      setState(() => selectedComponent = title);
    }
  }

  Future<void> onRefresh() async {
    context.read<BookCubit>().getBook("");

    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  void initState() {
    onRefresh();
    super.initState();
  }

  @override
  Widget body() {
    return Builder(builder: (context) {
      return Scaffold(
        body: BlocListener<BookCubit, BookState>(
          listener: (context, state) {
            if (state is SetBookSuccess) {
              onRefresh();
            } else if (state is BookFailed) {
              showSnackBar(state.message, isError: true);
            }
          },
          child: BaseCaiScreen(
            mainWidget: Container(
              color: Theme.of(context).backgroundColor,
              width: CustomFunctions.isMobile(context)
                  ? MediaQuery.of(context).size.width
                  : 650,
              height: double.infinity,
              child: Column(
                children: [
                  _bodyHeader(),
                  // tabBarWidget(),
                  Expanded(
                    child: CustomFunctions.isMobile(context)
                        ? _mobileView()
                        : _webView(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _bodyHeader() {
    return Builder(builder: (context) {
      final subWalletSelected = context.select((SubWalletCubit element) =>
          element.state.subWalletList
              .firstWhereOrNull((element) => element.id == ""));
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
                color: Colors.white,
              ),
              SizedBox(
                width: CustomFunctions.isMobile(context) ? 3 : 5,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyText1,
                          text: "Book List",
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style:
                              Theme.of(context).textTheme.bodyText2?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColorLight,
                                  ),
                          text: subWalletSelected?.title ?? "-",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 15.0),
              // createBookButton()
            ],
          ),
        ),
      );
    });
  }

  // Widget createBookButton() {
  //   return Builder(builder: (context) {
  //     final currentUser =
  //         context.select((AuthBloc element) => element.state.currentUser);

  //     // if (!PermissionsUtils.isEditAllowed(
  //     //     user: currentUser, ground: selectedGround)) {
  //     //   return const SizedBox();
  //     // }

  //     if (!(currentUser?.isAdmin() ?? false)) {
  //       return const SizedBox();
  //     }

  //     return InkWell(
  //       onTap: () {
  //         context.push("${Routes.book}/${widget.id}/set");
  //       },
  //       child: Container(
  //         width: 120,
  //         decoration: BoxDecoration(
  //           border: Border.all(
  //             color: Colors.transparent,
  //             style: BorderStyle.solid,
  //             width: 1.0,
  //           ),
  //           color: Colors.orange,
  //           borderRadius: BorderRadius.circular(8),
  //         ),
  //         child: const Center(
  //           child: Text(
  //             "Create Book",
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 16,
  //               fontWeight: FontWeight.w600,
  //               letterSpacing: 1,
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  //   });
  // }

  Widget _webView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _contentList()),
        Expanded(
          flex: 3,
          child: _dataListWidget(),
        )
      ],
    );
  }

  Widget _mobileView() {
    return _dataListWidget();
  }

  Widget _contentList() {
    return Builder(builder: (context) {
      final bookList =
          context.select((BookCubit element) => element.state.bookList);
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            // const Text(
            //   "Components",
            //   style: TextStyle(fontSize: 13),
            // ),
            // const Divider(
            //   color: Colors.grey,
            // ),
            ...bookList
                .map(
                  (e) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: selectedComponent == e.id
                          ? AppColors.primaryColorLight.withOpacity(0.5)
                          : null,
                      border: Border.all(color: Colors.white, width: 0.5),
                    ),
                    child: ListTile(
                      onTap: () => _selectComponent(e.id),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      title: Text(
                        e.title,
                        style: const TextStyle(
                          fontSize: 15,
                          // color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        e.description,
                        style: const TextStyle(
                          fontSize: 12,
                          // color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      );
    });
  }

  Widget _dataListWidget() {
    return Builder(builder: (context) {
      final book = context.select((BookCubit element) => element.state.bookList
          .firstWhereOrNull((element) => element.id == selectedComponent));
      return Container(
        height: double.infinity,
        padding: CustomFunctions.isMobile(context)
            ? const EdgeInsets.all(5)
            : const EdgeInsets.all(10),
        margin: CustomFunctions.isMobile(context)
            ? const EdgeInsets.all(0)
            : const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: CustomFunctions.isMobile(context)
              ? null
              : BorderRadius.circular(12),
          color:
              Theme.of(context).appBarTheme.backgroundColor?.withOpacity(0.5),
        ),
        child: book == null
            ? const Center(
                child: Text(
                  "No item selected",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      book.description,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RoundedButton(
                      text: "Track Explorer",
                      selected: true,
                      selectedColor: Colors.orange,
                      onPressed: () {
                        launchUrlString(
                            "${HederaUtils.getExplorerUrl()}/search-details/topic/${book.id}");
                      },
                    ),
                  ],
                ),
              ),
      );
    });
  }
}
