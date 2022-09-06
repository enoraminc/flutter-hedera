part of '../dashboard.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends BaseStateful<DashboardScreen> {
  Future<void> onRefresh() async {
    context.read<SubWalletCubit>().getSubWallet();
    context.read<MemberWalletCubit>().fetchAllMemberWallet();
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
    return MultiBlocListener(
      listeners: [
        authListener(),
      ],
      child: BaseScreen(
        onRefresh: onRefresh,
        appBar: const CustomAppBar(),
        children: [
          const SizedBox(height: 20),
          mainInfoWidget(),
          const SizedBox(height: 20),
          booksTableWidget(),
          const SizedBox(height: 20),
          mainWalletTableWidget(),
          const SizedBox(height: 20),
          subWalletTableWidget(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Builder booksTableWidget() {
    return Builder(builder: (context) {
      final isLoading =
          context.select((BookCubit element) => element.state is BookLoading);
      final books =
          context.select((BookCubit element) => element.state.bookList);
      return CustomTableWidget(
        title: 'Books',
        isLoading: isLoading,
        onTap: (String topicId) {
          context.push("${Routes.book}/$topicId");
        },
        columns: const [
          "ID",
          "Title",
          "Description",
        ],
        rows: books
            // .take(5)
            .map((book) => [
                  book.topicId,
                  book.title,
                  book.description,
                ])
            .toList(),
      );
    });
  }

  Builder mainWalletTableWidget() {
    return Builder(builder: (context) {
      final isLoading = context.select(
          (MemberWalletCubit element) => element.state is MemberWalletLoading);
      final walletList = context.select(
          (MemberWalletCubit element) => element.state.memberWalletList);
      return CustomTableWidget(
        title: 'Main Wallet',
        isLoading: isLoading,
        columns: const [
          "ID",
          "Name",
          "Email",
        ],
        rows: walletList
            // .take(5)
            .map((wallet) => [
                  wallet.accountId,
                  wallet.displayName,
                  wallet.email,
                ])
            .toList(),
      );
    });
  }

  Builder subWalletTableWidget() {
    return Builder(builder: (context) {
      final isLoading = context.select(
          (SubWalletCubit element) => element.state is SubWalletLoading);
      final subWalletList = context
          .select((SubWalletCubit element) => element.state.subWalletList);

      return CustomTableWidget(
        title: 'Sub Wallet',
        isLoading: isLoading,
        columns: const [
          "ID",
          "Name",
          "Description",
          "Users",
        ],
        rows: subWalletList
            // .take(5)
            .map((wallet) => [
                  wallet.accountId,
                  wallet.title,
                  wallet.description,
                  wallet.users.fold(
                      "",
                      (previousValue, element) => (previousValue.isEmpty)
                          ? element
                          : "$previousValue, $element")
                ])
            .toList(),
      );
    });
  }

  Row mainInfoWidget() {
    return Row(
      children: [
        Expanded(
          child: Builder(builder: (context) {
            final isLoading = context
                .select((BookCubit element) => element.state is BookLoading);
            final value = context
                .select((BookCubit element) => element.state.bookList.length);
            return BoxContentWidget(
              icon: FontAwesomeIcons.book,
              title: "Books",
              value: formatNumber(value.toString()),
              isLoading: isLoading,
            );
          }),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Builder(builder: (context) {
            final isLoading = context.select((MemberWalletCubit element) =>
                element.state is MemberWalletLoading);
            final value = context.select((MemberWalletCubit element) =>
                element.state.memberWalletList.length);
            return BoxContentWidget(
              icon: FontAwesomeIcons.wallet,
              title: "Main Wallet",
              value: formatNumber(value.toString()),
              isLoading: isLoading,
            );
          }),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Builder(builder: (context) {
            final isLoading = context.select(
                (SubWalletCubit element) => element.state is SubWalletLoading);
            final value = context.select(
                (SubWalletCubit element) => element.state.subWalletList.length);

            return BoxContentWidget(
              icon: FontAwesomeIcons.wallet,
              title: "Sub Wallet",
              value: formatNumber(value.toString()),
              isLoading: isLoading,
            );
          }),
        ),
      ],
    );
  }

  BlocListener<AuthBloc, AuthState> authListener() {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          loading = LoadingUtil.build(context);
          loading?.show();
        } else {
          loading?.dismiss();
        }
        // Log.setLog(state.toString(), method: "LoginScreen");
        if (state is LogoutSuccess) {
          Router.neglect(
            context,
            () => context.go(
              Routes.login,
            ),
          );
        }

        if (state is LogoutFailure) {
          showSnackBar(state.error ?? "", isError: true);
        }
      },
    );
  }
}
