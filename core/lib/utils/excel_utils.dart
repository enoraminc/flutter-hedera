import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:core/model/book_model.dart';
import 'package:core/model/cashbon_book_model.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/src/intl/date_format.dart';
import 'package:lumbung_common/model/kedai_pos_token.dart';
import 'package:lumbung_common/model/menu_item_pos.dart';
import 'package:lumbung_common/model/order_pos_token.dart';
import 'package:lumbung_common/model/rab_kedai_token.dart';
import 'package:lumbung_common/utils/log.dart';
import 'package:intl/intl.dart';

import 'date_utils.dart';

class ExcelUtils {
  static String formatAmount(num? amount) {
    if (amount != null) {
      NumberFormat rpFormat = NumberFormat.simpleCurrency(locale: 'in_id');
      return rpFormat
          .format(amount)
          .replaceAll(RegExp('Rp'), 'Rp. ')
          .replaceAll(',00', '');
    }
    return 'Rp. 0';
  }

  static Future<Uint8List>? generateCashbonExcel(
      List<BookMessageDataModel> bookMessageList) async {
    try {
      final byteData =
          await rootBundle.load('assets/excel/export-cashbon-book.xlsx');

      Uint8List bytes = byteData.buffer.asUint8List();

      var excel = Excel.decodeBytes(bytes);

      if (excel.tables.keys.isEmpty) {
        Log.setLog("Excel file is not valid");
        throw Exception("Excel file is not valid");
      }

      if (excel.sheets.keys.isEmpty) {
        Log.setLog("Sheet is empty");
        throw Exception("Sheet is empty");
      }

      final key = excel.sheets.keys.first;

      final Sheet sheet = excel.sheets[key]!;

      sheet.headerFooter = HeaderFooter();

      for (int i = 0; i < 15; i++) {
        sheet.setColAutoFit(i);
      }

      CellStyle cellStyle = CellStyle(
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center,
        textWrapping: TextWrapping.WrapText,
      );

      Log.setLog("Convert ${bookMessageList.length} Cashbook");
      for (int i = 0; i < bookMessageList.length; i++) {
        final bookMessage = bookMessageList[i];

        final cashbon = CashbonBookItemModel.fromJson(bookMessage.data);
        int balance = 0;

        for (BookMessageDataModel element in bookMessageList) {
          if (element.topicSequenceNumber <= bookMessage.topicSequenceNumber) {
            final check = CashbonBookItemModel.fromJson(element.data);

            balance += check.debit;
            balance -= check.credit;
          }
        }

        final rowIndex = i + 1;

        sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
          ..value = CustomDateUtils.simpleFormat(cashbon.date)
          ..cellStyle = cellStyle;

        sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
          ..value = cashbon.memberBook.name
          ..cellStyle = cellStyle;

        sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
          ..value = formatAmount(cashbon.memberBook.limitPayable)
          ..cellStyle = cellStyle;

        sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
          ..value = formatAmount(cashbon.debit)
          ..cellStyle = cellStyle;

        sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
          ..value = formatAmount(cashbon.credit)
          ..cellStyle = cellStyle;

        sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
          ..value = formatAmount(balance)
          ..cellStyle = cellStyle;
      }

      excel.save(
          fileName:
              "Export-Cashbon-Book-${DateTime.now().toIso8601String()}.xlsx");

      // excel.encode();

      List<int> result = [];

      Log.setLog("Success encode excel");

      // if (data.isEmpty) {
      //   Log.setLog("Failed to export excel");
      //   throw Exception("Failed to export excel");
      // }

      return Uint8List.fromList(result);
    } catch (e) {
      rethrow;
    }
  }
}
