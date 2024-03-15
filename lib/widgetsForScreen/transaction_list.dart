import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/expense.dart';
import 'package:my_app/screens/edit_transaction_screen.dart';
import 'package:string_extensions/string_extensions.dart';

class TransactionList extends StatefulWidget {
  const TransactionList(
      {super.key,
      required this.transations,
      required this.onRemoveTransaction,
      required this.onEditTransaction});
  final List<Transaction> transations;
  final void Function(Transaction) onRemoveTransaction;
  final void Function(Transaction, double, Category) onEditTransaction;

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  String getFormattedAccount(double amount) {
    return NumberFormat.currency(
            locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0)
        .format(amount);
  }

  @override
  Widget build(BuildContext context) {
    double totalSpendingPerDay = 0;

    return ListView.builder(
      itemCount: widget.transations.length,
      itemBuilder: (context, index) {
        Color defineColor = const Color.fromRGBO(189, 53, 53, 1);
        Color defineAmountColor = const Color.fromRGBO(189, 53, 53, 1);

        String? defineCategory = widget.transations[index].category
            .toString()
            .split(".")
            .last
            .capitalize;

        if (widget.transations[index].category == Category.income) {
          defineColor = const Color.fromRGBO(31, 119, 0, 1);
        }

        Widget showDate() {
          final getTodaysDate = DateTime.now();
          if (index == widget.transations.length) {
            return const SizedBox(
              height: 0,
            );
          }
          if (index == 0 &&
              DateFormat('d').format(widget.transations[index].date) ==
                  DateFormat('d').format(getTodaysDate)) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                width: double.infinity,
                height: 20,
                child: Row(
                  children: [
                    Text('Today'),
                  ],
                ),
              ),
            );
          } else if (index == 0 &&
              DateFormat('d').format(widget.transations[index].date) !=
                  DateFormat('d').format(getTodaysDate)) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                width: double.infinity,
                height: 20,
                child: Row(
                  children: [
                    Text(DateFormat('dd/MM/yyyy')
                        .format(widget.transations[index].date)),
                  ],
                ),
              ),
            );
          }
          if (index != 0 &&
              DateFormat('d').format(widget.transations[index].date) !=
                  DateFormat('d').format(widget.transations[index - 1].date)) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                width: double.infinity,
                height: 20,
                child: Row(
                  children: [
                    Text(DateFormat('dd/MM/yyyy')
                        .format(widget.transations[index].date)),
                  ],
                ),
              ),
            );
          }
          return const SizedBox(
            height: 0,
          );
        }

        Widget showAmount() {
          if (index == widget.transations.length - 1) {
            double temp = totalSpendingPerDay;
            totalSpendingPerDay = 0;
            if (temp < 0) {
              defineAmountColor = const Color.fromRGBO(189, 53, 53, 1);
              temp *= -1;
            } else if (temp > 0) {
              defineAmountColor = const Color.fromRGBO(31, 119, 0, 1);
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Row(
                children: [
                  Spacer(),
                  Text(
                    getFormattedAccount(temp),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: defineAmountColor,
                    ),
                  ),
                ],
              ),
            );
          }
          if (index != 0 &&
              DateFormat('d').format(widget.transations[index].date) !=
                  DateFormat('d').format(widget.transations[index + 1].date)) {
            double temp = totalSpendingPerDay;
            totalSpendingPerDay = 0;
            if (temp < 0) {
              defineAmountColor = const Color.fromRGBO(189, 53, 53, 1);
              temp *= -1;
            } else if (temp > 0) {
              defineAmountColor = const Color.fromRGBO(31, 119, 0, 1);
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Row(
                children: [
                  Spacer(),
                  Text(
                    getFormattedAccount(temp),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: defineAmountColor,
                    ),
                  ),
                ],
              ),
            );
          }
          return SizedBox(
            height: 0,
          );
        }

        void setTransaction(DateTime editedDate, double editedAmount,
            String editedTitle, Category editedCategory) {
          Category beforeCateg = widget.transations[index].category;
          double beforeAmount = widget.transations[index].amount;
          widget.transations[index].date = editedDate;
          widget.transations[index].amount = editedAmount;
          widget.transations[index].title = editedTitle;
          widget.transations[index].category = editedCategory;
          widget.onEditTransaction(
              widget.transations[index], beforeAmount, beforeCateg);
        }

        if (widget.transations[index].category == Category.income) {
          totalSpendingPerDay += widget.transations[index].amount;
        } else {
          totalSpendingPerDay -= widget.transations[index].amount;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: [
              showDate(),
              Dismissible(
                confirmDismiss: (DismissDirection direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return EditTransactionScreen(
                              setTransaction: setTransaction,
                              preAmount: widget.transations[index].amount,
                              preCategory: widget.transations[index].category,
                              preSelectedDate: widget.transations[index].date,
                              preTitle: widget.transations[index].title);
                        },
                      ),
                    );
                  } else {
                    widget.onRemoveTransaction(widget.transations[index]);
                    return true;
                  }
                  return false;
                },
                background: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit,
                          color: Colors.green,
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Edit',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          FontAwesomeIcons.trash,
                          color: Colors.red,
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Delete',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                key: ValueKey(widget.transations[index]),
                child: Card(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    height: 54,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromRGBO(30, 30, 30, 1),
                          defineColor
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('d')
                                .format(widget.transations[index].date),
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 2),
                            child: Text(
                                '/${DateFormat('MM/yyyy').format(widget.transations[index].date)}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 5, bottom: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.transations[index].title,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  defineCategory!,
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 0.65)),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5, right: 5),
                            child: Text(
                              'Rp',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color:
                                    const Color.fromRGBO(255, 255, 255, 0.65),
                              ),
                            ),
                          ),
                          Text(
                            widget.transations[index].getFormattedAccount,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              showAmount(),
            ],
          ),
        );
      },
    );
  }
}
