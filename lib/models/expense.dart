import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const uuid = Uuid();

final formatter = DateFormat().add_yMd();

enum Category {
  food,
  entertainment,
  transportation,
  others,
  income,
}

class Transaction {
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category.toString(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      title: json['title'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      category:
          Category.values.firstWhere((c) => c.toString() == json['category']),
    );
  }

  Transaction(
      {required this.title,
      required this.amount,
      required this.date,
      required this.category})
      : id = uuid.v4();
  String id;
  String title;
  double amount;
  DateTime date;
  Category category;

  String get getFormattedDate {
    return formatter.format(date);
  }

  String get getFormattedAccount {
    return NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0)
        .format(amount);
  }
}

class TransactionBucket {
  const TransactionBucket({required this.category, required this.transactions});
  TransactionBucket.forCategory(List<Transaction> allTransaction, this.category)
      : transactions = allTransaction
            .where((transactions) => transactions.category == category)
            .toList(); //utility/custom constructor
  final Category category;
  final List<Transaction> transactions;

  double get totalTransaction {
    double sum = 0;

    for (final i in transactions) {
      sum += i.amount;
    }
    return sum;
  }
}
