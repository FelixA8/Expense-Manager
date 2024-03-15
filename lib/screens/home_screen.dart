import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/file_helper.dart';
import 'package:my_app/models/dummy_models.dart';
import 'package:my_app/screens/add_transaction_screen.dart';
import 'package:my_app/screens/stats_screen.dart';
import 'package:my_app/widgetsForScreen/main_container.dart';
import 'package:my_app/widgetsForScreen/transaction_list.dart';
import 'package:my_app/models/expense.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? inputDate;
  double? inputAmount;
  String? inputTitle;
  Category? inputCategory;

  double totalBalance = 0;
  double totalIncome = 0;
  double totalExpense = 0;

  void getInputtedTransaction(
      DateTime date, double amount, String title, Category category) {
    inputDate = date;
    inputAmount = amount;
    inputTitle = title;
    inputCategory = category;
    addTransaction();
  }

  void addTransaction() {
    saveData();
    setState(() {
      registeredTransaction.add(Transaction(
          title: inputTitle!,
          amount: inputAmount!,
          date: inputDate!,
          category: inputCategory!));
      if (inputCategory == Category.income) {
        totalBalance += inputAmount!;
        totalIncome += inputAmount!;
      } else {
        totalBalance -= inputAmount!;
        totalExpense += inputAmount!;
      }
    });
  }

  void editTransaction(
      Transaction transaction, double beforeAmount, Category beforeCategory) {
    print(transaction.amount);
    print(beforeAmount);
    setState(
      () {
        //many exceptions
        if (transaction.category != beforeCategory) {
          if (transaction.category == Category.income &&
              beforeCategory != Category.income) {
            totalIncome += transaction.amount;
            totalExpense -= beforeAmount;
            totalBalance = totalIncome - totalExpense;
          } else if (transaction.category != Category.income &&
              beforeCategory == Category.income) {
            totalIncome -= beforeAmount;
            totalExpense += transaction.amount;
            totalBalance = totalIncome - totalExpense;
          } else if (transaction.category != Category.income &&
              beforeCategory != Category.income) {
            totalExpense += transaction.amount - beforeAmount;
            totalBalance = totalIncome - totalExpense;
          } else if (transaction.category == Category.income &&
              beforeCategory == Category.income) {
            totalIncome += transaction.amount - beforeAmount;
            totalBalance = totalIncome - totalExpense;
          }
        } else if (transaction.category == beforeCategory) {
          if (transaction.category == Category.income) {
            totalIncome += transaction.amount - beforeAmount;
            totalBalance = totalIncome - totalExpense;
          } else {
            totalExpense += transaction.amount - beforeAmount;
            totalBalance = totalIncome - totalExpense;
          }
        }
        saveData();
      },
    );
  }

  void removeTransaction(Transaction transaction) {
    setState(() {
      if (transaction.category == Category.income) {
        totalBalance -= transaction.amount;
        totalIncome -= transaction.amount;
      } else {
        totalBalance += transaction.amount;
        totalExpense -= transaction.amount;
      }
      registeredTransaction.remove(transaction);
    });
    saveData();
  }

  void setInitialBalance() {
    for (var i in registeredTransaction) {
      if (i.category == Category.income) {
        totalBalance += i.amount;
        totalIncome += i.amount;
      } else {
        totalBalance -= i.amount;
        totalExpense += i.amount;
      }
    }
  }

  void loadData() async {
    List<Transaction> loadedTransactions = await FileHelper.loadTransactions();
    setState(() {
      registeredTransaction = loadedTransactions;
      setInitialBalance();
    });
  }

  void saveData() async {
    await FileHelper.saveTransactions(registeredTransaction);
  }

  @override
  void initState() {
    super.initState();
    loadData();
    for (final i in registeredTransaction) {
      if (i.category == Category.income) {
        totalBalance += i.amount;
        totalIncome += i.amount;
      } else {
        totalBalance -= i.amount;
        totalExpense += i.amount;
      }
    }
  }

  Widget goToMainContainerScreen() {
    return MainContainer(
      totalBalance: totalBalance,
      totalExpense: totalExpense,
      totalIncome: totalIncome,
    );
  }

  @override
  Widget build(BuildContext context) {
    //sort the data.
    final sortedTransaction = registeredTransaction
        .map((tranasction) => tranasction)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    registeredTransaction = sortedTransaction;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ExpenseManager',
          style: GoogleFonts.getFont('Poppins'),
        ),
        backgroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddTransactionScreen(getTransaction: getInputtedTransaction),
            ),
          );
        },
        backgroundColor: Colors.white,
        child: Icon(FontAwesomeIcons.plus),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 352,
              height: 30,
            ),
            goToMainContainerScreen(),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'History',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return StatsScreen(
                            transaction: registeredTransaction,
                            totalExpense: totalExpense,
                            totalIncome: totalIncome,
                          );
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.black,
                    side: const BorderSide(width: 1, color: Colors.white),
                  ),
                  child: const Text('Stats'),
                ),
              ],
            ),
            Expanded(
              child: registeredTransaction.isEmpty
                  ? Center(
                      child: Text(
                        'No Expenses has been made, make an Transaction',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        child: TransactionList(
                          transations: registeredTransaction,
                          onEditTransaction: editTransaction,
                          onRemoveTransaction: removeTransaction,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
