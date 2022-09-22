part of '../dashboard.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends BaseStateful<DashboardScreen> {
  Future<void> onRefresh() async {
    context.read<SubWalletCubit>().fetchSubWallet();
    context.read<MainWalletCubit>().fetchMainWallet();
    context.read<JournalCubit>().getJournal("");
    context.read<JobCubit>().fetchAllJob();

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
          journalsTableWidget(),
          const SizedBox(height: 20),
          jobTableWidget(),
          const SizedBox(height: 20),
          mainWalletTableWidget(),
          const SizedBox(height: 20),
          subWalletTableWidget(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Builder journalsTableWidget() {
    return Builder(builder: (context) {
      final isLoading = context
          .select((JournalCubit element) => element.state is JournalLoading);
      final books =
          context.select((JournalCubit element) => element.state.journalList);
      return CustomTableWidget(
        title: 'Journal',
        isLoading: isLoading,
        onTap: (String topicId) {
          context.push("${Routes.journal}/?id=$topicId");
        },
        onSeeAllTap: () {
          context.go(Routes.journal);
        },
        columns: const [
          "ID",
          "Title",
          "Description",
        ],
        rows: books
            .take(5)
            .map((book) => [
                  book.topicId,
                  book.title,
                  book.description,
                ])
            .toList(),
      );
    });
  }

  Builder jobTableWidget() {
    return Builder(builder: (context) {
      final isLoading =
          context.select((JobCubit element) => element.state is JobLoading);
      final jobs = context.select((JobCubit element) => element.state.jobList);
      return CustomTableWidget(
        title: 'Job',
        isLoading: isLoading,
        onTap: (String topicId) {
          context.push("${Routes.job}/?id=$topicId");
        },
        onSeeAllTap: () {
          context.go(Routes.job);
        },
        columns: const [
          "ID",
          "Title",
          "Description",
          "Type",
        ],
        rows: jobs
            .take(5)
            .map((job) => [
                  job.id,
                  job.title,
                  job.description,
                  job.type,
                ])
            .toList(),
      );
    });
  }

  Builder mainWalletTableWidget() {
    return Builder(builder: (context) {
      final isLoading = context.select(
          (MainWalletCubit element) => element.state is MemberWalletLoading);
      final walletList = context
          .select((MainWalletCubit element) => element.state.mainWalletList);
      return CustomTableWidget(
        title: 'Main Wallet',
        isLoading: isLoading,
        onSeeAllTap: () {
          context.go("${Routes.wallet}/${Routes.mainWallet}");
        },
        onTap: (String id) {
          context.go("${Routes.wallet}/${Routes.mainWallet}?id=$id");
        },
        columns: const [
          "ID",
          "Name",
          "Email",
        ],
        rows: walletList
            .take(5)
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
        onSeeAllTap: () {
          context.go("${Routes.wallet}/${Routes.subWallet}");
        },
        onTap: (String id) {
          context.go("${Routes.wallet}/${Routes.subWallet}?id=$id");
        },
        columns: const [
          "ID",
          "Name",
          "Description",
          "Users",
        ],
        rows: subWalletList
            .take(5)
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
            final isLoading = context.select(
                (JournalCubit element) => element.state is JournalLoading);
            final value = context.select(
                (JournalCubit element) => element.state.journalList.length);
            return BoxContentWidget(
              icon: FontAwesomeIcons.book,
              title: "Journal",
              value: formatNumber(value.toString()),
              isLoading: isLoading,
            );
          }),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Builder(builder: (context) {
            final isLoading = context
                .select((JobCubit element) => element.state is JobLoading);
            final value = context
                .select((JobCubit element) => element.state.jobList.length);
            return BoxContentWidget(
              icon: Icons.work_history_rounded,
              title: "Job",
              value: formatNumber(value.toString()),
              isLoading: isLoading,
            );
          }),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Builder(builder: (context) {
            final isLoading = context.select((MainWalletCubit element) =>
                element.state is MemberWalletLoading);
            final value = context.select((MainWalletCubit element) =>
                element.state.mainWalletList.length);
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
