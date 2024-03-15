import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/expense.dart';
import 'package:my_app/widgetsForScreen/chart_bar_expense.dart';
import 'package:my_app/widgetsForScreen/doughnut_chart.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen(
      {super.key,
      required this.transaction,
      required this.totalExpense,
      required this.totalIncome});
  final List<Transaction> transaction;
  final double totalIncome;
  final double totalExpense;
  @override
  State<StatsScreen> createState() => _StatsScreenState();

  List<TransactionBucket> get buckets {
    return [
      TransactionBucket.forCategory(transaction, Category.food),
      TransactionBucket.forCategory(transaction, Category.entertainment),
      TransactionBucket.forCategory(transaction, Category.transportation),
      TransactionBucket.forCategory(transaction, Category.others),
    ];
  }
}

class _StatsScreenState extends State<StatsScreen> {
  String getFormattedAccount2(double amount) {
    return NumberFormat.currency(
            locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0)
        .format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats'),
        backgroundColor: Colors.black,
      ),
      body: widget.transaction.isEmpty
          ? Center(
              child: Text(
                'Oops, you don’t have any transactions',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: const Color.fromRGBO(255, 255, 255, 1),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  DoughnutChart(
                    totalExpense: widget.totalExpense,
                    totalIncome: widget.totalIncome,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 56,
                        height: 22,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromRGBO(189, 53, 53, 1),
                        ),
                        child: Text(
                          'Expense',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: const Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(getFormattedAccount2(widget.totalExpense)),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 56,
                        height: 22,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromRGBO(31, 119, 0, 1),
                        ),
                        child: Text(
                          'Income',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: const Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(getFormattedAccount2(widget.totalIncome)),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromRGBO(189, 53, 53, 1),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 300,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 32,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            color: Color.fromRGBO(189, 53, 53, 1),
                          ),
                          child: Text(
                            'Expense Stats',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: const Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                        ),
                        ChartBarExpenseWidget(transactions: widget.transaction),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.food_bank,
                                color: Color.fromRGBO(189, 53, 53, 1),
                                size: 30,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getFormattedAccount2(
                                          widget.buckets[0].totalTransaction),
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 1),
                                      ),
                                    ),
                                    Text(
                                      'Food',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 0.65),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                FontAwesomeIcons.motorcycle,
                                color: Color.fromRGBO(189, 53, 53, 1),
                                size: 25,
                              ),
                              const SizedBox(
                                width: 17,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getFormattedAccount2(
                                          widget.buckets[2].totalTransaction),
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 1),
                                      ),
                                    ),
                                    Text(
                                      'Transportation',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 0.65),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                FontAwesomeIcons.mask,
                                color: Color.fromRGBO(189, 53, 53, 1),
                                size: 23,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getFormattedAccount2(
                                          widget.buckets[1].totalTransaction),
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 1),
                                      ),
                                    ),
                                    Text(
                                      'Entertainment',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 0.65),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                FontAwesomeIcons.circleNotch,
                                color: Color.fromRGBO(189, 53, 53, 1),
                                size: 25,
                              ),
                              const SizedBox(
                                width: 17,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getFormattedAccount2(
                                          widget.buckets[3].totalTransaction),
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 1),
                                      ),
                                    ),
                                    Text(
                                      'Others',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 0.65),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
