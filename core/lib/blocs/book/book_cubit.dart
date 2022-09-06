import 'package:bloc/bloc.dart';
import 'package:core/apis/book_api.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../../model/book_model.dart';
import '../../utils/log.dart';

part 'book_state.dart';

class BookCubit extends Cubit<BookState> {
  final BookApi bookApi;
  BookCubit({required this.bookApi}) : super(BookInitial());

  Future<void> setBook(BookModel book) async {
    emit(SubmitBookLoading(
      bookList: state.bookList,
    ));

    await bookApi.setBook(book).then((value) {
      emit(SetBookSuccess(
        bookList: state.bookList,
      ));
    }).catchError((e, s) {
      Log.setLog("$e $s", method: "setSubWallet Bloc");
      emit(
        BookFailed(
          message: e.toString(),
          bookList: state.bookList,
        ),
      );
    });
  }

  Future<void> getBook(String subWalletId) async {
    emit(BookLoading(
      bookList: state.bookList,
    ));

    await bookApi.getBook(subWalletId).then((value) {
      Log.setLog(
        "Total Book : ${value.length}",
        method: "getBook Bloc",
      );
      emit(GetBookSuccess(
        bookList: value,
      ));
    }).catchError((e, s) {
      Log.setLog("$e $s", method: "getBook Bloc");
      emit(
        BookFailed(
          message: e.toString(),
          bookList: state.bookList,
        ),
      );
    });
  }

  Future<void> getBookMessageData(String topicId) async {
    emit(BookMessageLoading(
      bookList: state.bookList,
    ));

    await bookApi.getBookMessageData(topicId).then((value) {
      Log.setLog(
        "Total Book Message : ${value.length}",
        method: "getBookMessageData Bloc",
      );
      emit(GetBookMessageDataSuccess(
        data: value,
        bookList: state.bookList,
      ));
    }).catchError((e, s) {
      Log.setLog("$e $s", method: "getBookMessageData Bloc");
      emit(
        GetBookMessageDataFailed(
          message: e.toString(),
          bookList: state.bookList,
        ),
      );
    });
  }
}
