part of 'book_cubit.dart';

@immutable
abstract class BookState extends Equatable {
  final List<BookModel> bookList;

  const BookState({required this.bookList});

  @override
  List<Object?> get props => [bookList];
}

class BookInitial extends BookState {
  BookInitial() : super(bookList: []);
}

class BookLoading extends BookState {
  const BookLoading({required super.bookList});
}

class SubmitBookLoading extends BookState {
  const SubmitBookLoading({required super.bookList});
}

class SetBookSuccess extends BookState {
  const SetBookSuccess({required super.bookList});
}

class GetBookSuccess extends BookState {
  const GetBookSuccess({required super.bookList});
}

class BookFailed extends BookState {
  final String message;
  const BookFailed({required this.message, required super.bookList});
}
