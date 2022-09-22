part of '../book.dart';

class BookSidebarListWidget extends StatelessWidget {
  const BookSidebarListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      // Sub Wallet
      final isLoading = context
          .select((JournalCubit element) => element.state is JournalLoading);

      final selectedBook = context
          .select((JournalCubit element) => element.state.selectedJournal);

      final bookList =
          context.select((JournalCubit element) => element.state.journalList);

      if (isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (bookList.isEmpty) {
        return const Center(
          child: Text('Item is Empty'),
        );
      }

      return ChatItemScreen<JournalModel>(
        isCurrentSelected: (JournalModel data) => data.id == selectedBook?.id,
        items: bookList,
        itemTitle: (JournalModel data) => data.title,
        subTitle: (JournalModel data) => data.description,
        subTitle2: (JournalModel data) =>
            ContentTagLabelWidget(title: data.type),
        leadingWidget: (JournalModel data) =>
            LeadingIconWidget(title: data.title),
        trailingWidget: (JournalModel data) =>
            const SizedBox(height: 5, width: 5),
        onTapItem: (JournalModel data) {
          context.read<JournalCubit>().changeSelectedData(data);

          context
              .read<ChatMessageBloc>()
              .add(LoadChatMessages(path: data.id, locale: ""));

          if (CustomFunctions.isMobile(context)) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const BookChatScreen();
                },
              ),
            );
          }
        },
      );
    });
  }
}
