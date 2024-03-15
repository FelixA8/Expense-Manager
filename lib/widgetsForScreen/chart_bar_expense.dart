import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/models/expense.dart';
import 'package:my_app/widgetsForScreen/chart_bar_widgets.dart';

class ChartBarExpenseWidget extends StatefulWidget {
  const ChartBarExpenseWidget({super.key, required this.transactions});
  final List<Transaction> transactions;

  List<TransactionBucket> get buckets {
    return [
      TransactionBucket.forCategory(transactions, Category.food),
      TransactionBucket.forCategory(transactions, Category.entertainment),
      TransactionBucket.forCategory(transactions, Category.transportation),
      TransactionBucket.forCategory(transactions, Category.others),
    ];
  }

  double get maxTotalExpense {
    double maxTotalExpense = 0;

    for (final bucket in buckets) {
      if (bucket.totalTransaction > maxTotalExpense) {
        maxTotalExpense = bucket.totalTransaction;
      }
    }

    return maxTotalExpense;
  }

  double get totalExpense {
    double maxTotalExpense = 0;

    for (final bucket in buckets) {
      maxTotalExpense += bucket.totalTransaction;
    }
    return maxTotalExpense;
  }

  @override
  State<ChartBarExpenseWidget> createState() => _ChartBarExpenseWidgetState();
}

class _ChartBarExpenseWidgetState extends State<ChartBarExpenseWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      width: double.infinity,
      height: 150,
      child: Column(
        children: [
          Expanded(
            child: widget.totalExpense == 0
                ? Center(
                    child: Text(
                      'No Expense Created',
                      style: GoogleFonts.poppins(
                        color: const Color.fromRGBO(255, 255, 255, 0.65),
                      ),
                    ),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (final i in widget.buckets)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              children: [
                                Text(
                                  '${(i.totalTransaction * 100 / widget.totalExpense).toStringAsFixed(2)} %',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: const Color.fromRGBO(
                                        255, 255, 255, 0.65),
                                  ),
                                ),
                                Text(
                                  i.category.name.toString(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 0.65),
                                      fontSize: 9),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final i in widget.buckets) // alternative to map()
                  ChartBar(
                    fill: i.totalTransaction == 0
                        ? 0
                        : i.totalTransaction / widget.maxTotalExpense,
                  ),
              ],
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
