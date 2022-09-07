import 'package:bloc/bloc.dart';
import 'package:core/apis/book_api.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../../model/book_model.dart';
import '../../utils/excel_utils.dart';
import '../../utils/log.dart';

part 'book_state.dart';

class BookCubit extends Cubit<BookState> {
  final BookApi bookApi;
  BookCubit({required this.bookApi}) : super(BookInitial());

  Future<void> changeSelectedData(BookModel? book) async {
    emit(GetBookSuccess(
      bookList: state.bookList,
      selectedBook: book,
    ));
  }

  Future<void> setBook(BookModel book) async {
    emit(SubmitBookLoading(
      bookList: state.bookList,
      selectedBook: state.selectedBook,
    ));

    await bookApi.setBook(book).then((value) {
      emit(SetBookSuccess(
        bookList: state.bookList,
        selectedBook: value,
      ));
    }).catchError((e, s) {
      Log.setLog("$e $s", method: "setSubWallet Bloc");
      emit(
        BookFailed(
          message: e.toString(),
          bookList: state.bookList,
          selectedBook: state.selectedBook,
        ),
      );
    });
  }

  Future<void> getBook(String subWalletId) async {
    emit(BookLoading(
      bookList: state.bookList,
      selectedBook: state.selectedBook,
    ));

    await bookApi.getBook(subWalletId).then((value) {
      Log.setLog(
        "Total Book : ${value.length}",
        method: "getBook Bloc",
      );
      emit(GetBookSuccess(
        bookList: value,
        selectedBook: state.selectedBook,
      ));
    }).catchError((e, s) {
      Log.setLog("$e $s", method: "getBook Bloc");
      emit(
        BookFailed(
          message: e.toString(),
          bookList: state.bookList,
          selectedBook: state.selectedBook,
        ),
      );
    });
  }

  Future<void> deleteBook() async {
    emit(SubmitBookLoading(
      bookList: state.bookList,
      selectedBook: state.selectedBook,
    ));

    if (state.selectedBook == null) {
      emit(BookFailed(
        message: "Book Not Found",
        bookList: state.bookList,
        selectedBook: state.selectedBook,
      ));
      return;
    }

    final book = state.selectedBook!.copyWith(state: BookModel.deletedState);

    await bookApi.setBook(book).then((value) {
      emit(SetBookSuccess(
        bookList: state.bookList,
        selectedBook: null,
      ));
    }).catchError((e, s) {
      Log.setLog("$e $s", method: "setSubWallet Bloc");
      emit(
        BookFailed(
          message: e.toString(),
          bookList: state.bookList,
          selectedBook: state.selectedBook,
        ),
      );
    });
  }

  Future<void> getBookMessageData(String topicId) async {
    emit(BookMessageLoading(
      bookList: state.bookList,
      selectedBook: state.selectedBook,
    ));

    await bookApi.getBookMessageData(topicId).then((value) {
      Log.setLog(
        "Total Book Message : ${value.length}",
        method: "getBookMessageData Bloc",
      );
      emit(GetBookMessageDataSuccess(
        data: value,
        bookList: state.bookList,
        selectedBook: state.selectedBook,
      ));
    }).catchError((e, s) {
      Log.setLog("$e $s", method: "getBookMessageData Bloc");
      emit(
        GetBookMessageDataFailed(
          message: e.toString(),
          bookList: state.bookList,
          selectedBook: state.selectedBook,
        ),
      );
    });
  }

  Future<void> exportBook(List<BookMessageDataModel> dataList) async {
    emit(SubmitBookLoading(
      bookList: state.bookList,
      selectedBook: state.selectedBook,
    ));
    try {
      await ExcelUtils.generateCashbonExcel(dataList);

      await Future.delayed(const Duration(milliseconds: 500));

      emit(SetBookSuccess(
        bookList: state.bookList,
        selectedBook: state.selectedBook,
      ));
    } catch (e, s) {
      Log.setLog("$e $s", method: "setSubWallet Bloc");
      emit(
        BookFailed(
          message: e.toString(),
          bookList: state.bookList,
          selectedBook: state.selectedBook,
        ),
      );
    }
  }
}
