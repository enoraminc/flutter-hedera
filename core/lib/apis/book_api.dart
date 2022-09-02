import 'package:lumbung_common/base/base_repository.dart';

import '../model/book_model.dart';
import '../model/log_model.dart';

abstract class BookApi extends BaseRepository {
  Future<BookModel> setBook(BookModel book);
  Future<List<BookModel>> getBook(String subWalletId);
}
