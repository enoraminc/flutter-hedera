import 'package:lumbung_common/base/base_repository.dart';

import 'package:lumbung_common/model/hedera/concensus_model.dart';
import 'package:lumbung_common/model/hedera/journal_model.dart';
import 'package:lumbung_common/model/hedera/log_model.dart';
import 'package:lumbung_common/model/hedera/cashbon_journal_model.dart';

abstract class JournalApi extends BaseRepository {
  Future<JournalModel> setJournal(JournalModel book);
  Future<List<JournalModel>> getJournal({String? subWalletId});

  Future<CashbonJournalItemModel> submitCashbonMember({
    required String bookId,
    required int amount,
    required String type,
  });
}
