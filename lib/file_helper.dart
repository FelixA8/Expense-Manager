import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:my_app/models/expense.dart'; // Import your Transaction model

class FileHelper {
  static Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/transactions.json');
  }

  static Future<void> saveTransactions(List<Transaction> transactions) async {
    final file = await _localFile;
    final transactionList = transactions.map((tx) => tx.toJson()).toList();
    final jsonString = jsonEncode(transactionList);
    await file.writeAsString(jsonString);
  }

  static Future<List<Transaction>> loadTransactions() async {
    try {
      final file = await _localFile;
      final jsonString = await file.readAsString();
      final transactionList = jsonDecode(jsonString) as List<dynamic>;
      return transactionList.map((tx) => Transaction.fromJson(tx)).toList();
    } catch (e) {
      return []; // Return an empty list if there's an error
    }
  }
}
