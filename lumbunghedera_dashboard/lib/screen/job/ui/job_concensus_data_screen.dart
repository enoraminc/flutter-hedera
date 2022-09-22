part of '../job.dart';

enum ViewData {
  pretty("Pretty Data"),
  raw("Raw Data");

  final String label;

  const ViewData(this.label);

  @override
  String toString() => label;
}

class JobConcensusDataScreen extends StatefulWidget {
  const JobConcensusDataScreen({super.key, required this.topicId});
  final String topicId;

  @override
  State<JobConcensusDataScreen> createState() => _JobConcensusDataScreenState();
}

class _JobConcensusDataScreenState
    extends BaseStateful<JobConcensusDataScreen> {
  JobModel? currentJob;

  ViewData viewData = ViewData.pretty;

  List<ConcensusMessageDataModel> concensusMessageDataList = [];

  Future<void> onRefresh() async {
    context.read<JobCubit>().getJobMessageData(widget.topicId);

    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  void initState() {
    currentJob = context
        .read<JobCubit>()
        .state
        .jobList
        .firstWhereOrNull((element) => element.id == widget.topicId);

    onRefresh();
    super.initState();
  }

  @override
  Widget body() {
    return MultiBlocListener(
      listeners: [
        jobListener(),
      ],
      child: DefaultTabController(
        length: 2,
        child: BaseScreen(
          onRefresh: onRefresh,
          appBar: _appBar(),
          children: [
            const SizedBox(height: 10),
            jobInfoWidget(),
            const SizedBox(height: 10),
            if (viewData == ViewData.pretty) ...[
              prettyJobTableWidget(),
              const SizedBox(height: 20),
            ] else ...[
              rawTableWidget(),
              const SizedBox(height: 20),
            ],

            // messageListWidget(),
          ],
        ),
      ),
    );
  }

  Widget jobInfoWidget() {
    return Builder(builder: (context) {
      if (currentJob == null) return const SizedBox();

      return Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    currentJob?.title ?? "-",
                    style: Styles.commonTextStyle(
                      size: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Chip(
                  label: Text(
                    currentJob?.type ?? "-",
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
              currentJob?.description ?? "-",
              style: Styles.commonTextStyle(
                size: 14,
              ),
            ),
            const SizedBox(height: 10),
            TabBar(
              indicatorColor: Colors.orange,
              tabs: [
                Tab(
                  text: ViewData.pretty.toString(),
                ),
                Tab(
                  text: ViewData.raw.toString(),
                ),
              ],
              onTap: (index) {
                if (index == 0) {
                  setState(() {
                    viewData = ViewData.pretty;
                  });
                } else if (index == 1) {
                  setState(() {
                    viewData = ViewData.raw;
                  });
                }
              },
            ),
          ],
        ),
      );
    });
  }

  Widget rawTableWidget() {
    return Builder(builder: (context) {
      final isLoading = context
          .select((JobCubit element) => element.state is JobMessageLoading);
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              children: const [
                Expanded(
                  flex: 1,
                  child: Text("Sequence Number"),
                ),
                Expanded(
                  flex: 5,
                  child: Text("Message"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (isLoading)
              FadeShimmer(
                height: 300,
                width: double.infinity,
                radius: 4,
                fadeTheme: CustomFunctions.isDarkTheme(context)
                    ? FadeTheme.dark
                    : FadeTheme.light,
              )
            else
              ...concensusMessageDataList.map((bookMessage) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          formatNumber(
                              bookMessage.topicSequenceNumber.toString()),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                          bookMessage.data,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            const SizedBox(height: 10),
          ],
        ),
      );
    });
  }

  Builder prettyJobTableWidget() {
    return Builder(builder: (context) {
      final isLoading = context
          .select((JobCubit element) => element.state is JobMessageLoading);
      

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTableWidget(
              title: 'Job Wallet',
              isLoading: isLoading,
              isWithPadding: false,
              rowHeight: 120,
              columns: const [
                // "Sequence Number",
                "ID",
                "Created At",
                "Executed At",
                "State",
                "Message",
                "Data",
              ],
              rows: concensusMessageDataList.map((messageData) {
                final jobReq = JobRequestModel.fromJson(messageData.data);

                return [
                  jobReq.id.toString(),
                  CustomDateUtils.simpleFormatWithTime(jobReq.createdAt),
                  CustomDateUtils.simpleFormatWithTime(jobReq.executeAt),
                  jobReq.state,
                  jobReq.message,
                  jobReq.data.toString(),
                ];
              }).toList(),
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    });
  }

  Widget _appBar() {
    return const CustomSecondAppBar(
      title: "Job Concensus Data ",
    );
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
            concensusMessageDataList = state.data;
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
