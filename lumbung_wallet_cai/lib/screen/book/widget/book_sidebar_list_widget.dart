part of '../book.dart';

class BookSidebarListWidget extends StatelessWidget {
  const BookSidebarListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      // Sub Wallet
      final isLoading =
          context.select((BookCubit element) => element.state is BookLoading);

      final selectedBook =
          context.select((BookCubit element) => element.state.selectedBook);

      final bookList =
          context.select((BookCubit element) => element.state.bookList);

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

      return ChatItemScreen<BookModel>(
        isCurrentSelected: (BookModel data) => data.id == selectedBook?.id,
        items: bookList,
        itemTitle: (BookModel data) => data.title,
        subTitle: (BookModel data) => data.description,
        subTitle2: (BookModel data) => ContentTagLabelWidget(title: data.type),
        leadingWidget: (BookModel data) => LeadingIconWidget(title: data.title),
        trailingWidget: (BookModel data) => const SizedBox(height: 5, width: 5),
        onTapItem: (BookModel data) {
          context.read<BookCubit>().changeSelectedData(data);

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
