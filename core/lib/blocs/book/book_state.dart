part of 'book_cubit.dart';

@immutable
abstract class BookState extends Equatable {
  final List<BookModel> bookList;
  final BookModel? selectedBook;

  const BookState({required this.bookList, required this.selectedBook});

  @override
  List<Object?> get props => [bookList, selectedBook];
}

class BookInitial extends BookState {
  BookInitial() : super(bookList: [], selectedBook: null);
}

class BookLoading extends BookState {
  const BookLoading({
    required super.bookList,
    required super.selectedBook,
  });
}

class SubmitBookLoading extends BookState {
  const SubmitBookLoading({
    required super.bookList,
    required super.selectedBook,
  });
}

class BookMessageLoading extends BookState {
  const BookMessageLoading({
    required super.bookList,
    required super.selectedBook,
  });
}

class SetBookSuccess extends BookState {
  const SetBookSuccess({
    required super.bookList,
    required super.selectedBook,
  });
}

class GetBookSuccess extends BookState {
  const GetBookSuccess({
    required super.bookList,
    required super.selectedBook,
  });
}

class BookFailed extends BookState {
  final String message;
  const BookFailed({
    required this.message,
    required super.bookList,
    required super.selectedBook,
  });
}

class GetBookMessageDataSuccess extends BookState {
  final List<BookMessageDataModel> data;
  const GetBookMessageDataSuccess({
    required this.data,
    required super.bookList,
    required super.selectedBook,
  });
}

class GetBookMessageDataFailed extends BookState {
  final String message;
  const GetBookMessageDataFailed({
    required this.message,
    required super.bookList,
    required super.selectedBook,
  });
}

class DeleteBookSuccess extends BookState {
  const DeleteBookSuccess({
    required super.bookList,
    required super.selectedBook,
  });
}

class DeleteBookFailed extends BookState {
  final String message;
  const DeleteBookFailed({
    required this.message,
    required super.bookList,
    required super.selectedBook,
  });
}

class ExportBookSuccess extends BookState {
  const ExportBookSuccess({
    required super.bookList,
    required super.selectedBook,
  });
}

class ExportBookFailed extends BookState {
  final String message;
  const ExportBookFailed({
    required this.message,
    required super.bookList,
    required super.selectedBook,
  });
}
