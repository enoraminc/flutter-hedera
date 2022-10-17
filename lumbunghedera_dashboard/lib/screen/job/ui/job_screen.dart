part of '../job.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({
    super.key,
    required this.id,
  });

  final String id;
  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends BaseStateful<JobScreen> {
  String? selectedTopicId;

  List<ConcensusMessageDataModel> jobMessageList = [];

  Future<void> onRefresh() async {
    context.read<JobCubit>().fetchAllJob();

    // if (selectedTopicId?.isNotEmpty ?? false) {
    //   context.read<JobCubit>().getJobMessageData(selectedTopicId!);
    // }

    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  void initState() {
    selectedTopicId = widget.id;
    onRefresh();
    super.initState();
  }

  @override
  Widget body() {
    return MultiBlocListener(
      listeners: [
        jobListener(),
      ],
      child: Builder(builder: (context) {
        final isLoading =
            context.select((JobCubit element) => element.state is JobLoading);

        final jobList =
            context.select((JobCubit element) => element.state.jobList);

        final user =
            context.select((AuthBloc element) => element.state.currentUser);

        return BaseScreen2(
          selectedId: selectedTopicId,
          onRefresh: onRefresh,
          isLoading: isLoading,
          appBar: const CustomAppBar(),
          bottomNavBar: const SizedBox(),
          onBack: () {
            setState(() {
              selectedTopicId = null;
            });
          },
          sidebarChildren: sidebarListWidget(jobList),
          mainChild: jobInfoWidget(),
          onCreateTap:
              // (user?.isAdmin() ?? false)
              //     ? () => context.push("${Routes.journal}/${Routes.create}")
              //     :
              null,
        );
      }),
    );
  }

  List<Widget> sidebarListWidget(List<JobModel> jobs) {
    return jobs
        .map(
          (job) => InkWell(
            onTap: () {
              setState(() {
                selectedTopicId = job.id;
              });
              context.read<JobCubit>().getJobMessageData(job.id);
              Router.neglect(
                context,
                () => context.go("${Routes.job}?id=${job.id}"),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              margin: const EdgeInsets.only(
                bottom: 10,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
                borderRadius: BorderRadius.circular(5),
                gradient: selectedTopicId == job.id
                    ? LinearGradient(
                        stops: const [0.02, 0.02],
                        colors: [
                          Colors.orange,
                          Theme.of(context).appBarTheme.backgroundColor!
                        ],
                      )
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.title,
                    style: Styles.commonTextStyle(
                      size: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    job.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Styles.commonTextStyle(
                      size: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Chip(
                    label: Text(
                      job.type,
                      style: Styles.commonTextStyle(
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.orange,
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  Builder jobInfoWidget() {
    return Builder(builder: (context) {
      final isLoading = context
          .select((JobCubit element) => element.state is JobMessageLoading);

      final jobSelected = context.select((JobCubit element) => element
          .state.jobList
          .firstWhereOrNull((element) => element.id == selectedTopicId));

      if (jobSelected == null) {
        return Center(
          child: Text(
            "No Item Selected",
            textAlign: TextAlign.center,
            style: Styles.commonTextStyle(
              size: 18,
            ),
          ),
        );
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  jobSelected.title,
                  style: Styles.commonTextStyle(
                    size: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Chip(
                label: Text(
                  jobSelected.type,
                  style: Styles.commonTextStyle(
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            jobSelected.description,
            style: Styles.commonTextStyle(
              size: 14,
            ),
          ),
          const SizedBox(height: 5),
          const Divider(),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Hedera Consensus Service",
                  style: Styles.commonTextStyle(
                    size: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              RoundedButton(
                text: "View Data",
                selected: true,
                isSmall: true,
                selectedColor: Colors.orange,
                onPressed: () {
                  context.push(
                      "${Routes.job}/${Routes.concensus}/$selectedTopicId");
                },
              ),
              const SizedBox(width: 10),
              RoundedButton(
                text: "Track Explorer",
                selected: true,
                isSmall: true,
                selectedColor: Colors.orange,
                onPressed: () {
                  launchUrlString(
                      "${HederaUtils.getHederaExplorerUrl()}/search-details/topic/$selectedTopicId");
                },
              ),
            ],
          ),
          // Expanded(
          //   child: CustomTableWidget2(
          //     title: 'Hedera Consensus Service',
          //     isLoading: isLoading,
          //     isWithPadding: false,
          //     buttonList: [],
          //     columns: const [
          //       "Sequence Number",
          //       "Message",
          //     ],
          //     rows: jobMessageList.map((message) {
          //       return [
          //         formatNumber(message.topicSequenceNumber.toString()),
          //         message.data,
          //       ];
          //     }).toList(),
          //   ),
          // ),
          const SizedBox(height: 10),
        ],
      );
    });
  }

  BlocListener<JobCubit, JobState> jobListener() {
    return BlocListener<JobCubit, JobState>(
      listener: (context, state) {
        if (state is SubmitJobLoading) {
          loading = LoadingUtil.build(context);
          loading?.show();
        } else {
          loading?.dismiss();
        }
        // Log.setLog(state.toString(), method: "LoginScreen");

        if (state is GetJobMessageDataFailed) {
          showSnackBar(state.message, isError: true);
        }
        if (state is GetJobMessageDataSuccess) {
          setState(() {
            jobMessageList = state.data;
          });
        }

        // if (state is SetJobSuccess) {
        //   onRefresh();
        // } else
        if (state is JobFailed) {
          showSnackBar(state.message, isError: true);
        }
      },
    );
  }
}
