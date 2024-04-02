import 'package:my_app/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key, required this.getTransaction});
  final void Function(DateTime, double, String, Category) getTransaction;

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

enum Type {
  expense,
  income,
  none,
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  Color selectedColorIncome = const Color.fromRGBO(31, 119, 0, 1);
  Color selectedColorExpense = const Color.fromRGBO(189, 53, 53, 1);
  Category? setCategory;
  DateTime selectedDate = DateTime.now();
  Type currentType = Type.none;

  DateTime? _enteredDate;
  double _enteredAmount = 0;
  String _enteredTitle = '';
  Category? _enteredCategory;

  void _saveItem() {
    if (currentType == Type.none) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Please Set the Type of Transactions',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      );
    } else if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.getTransaction(
          _enteredDate!, _enteredAmount, _enteredTitle, _enteredCategory!);
      Navigator.pop(context);
    }
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    // ignore: use_build_context_synchronously
    final pickedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    //this line will be executed once pickedDate is avaiable
    setState(() {
      selectedDate = DateTime(
          pickedDate!.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime!.hour,
          pickedTime.minute,
          DateTime.now().second);
    });
  }

  void _onTapExpense() {
    setState(() {
      if (currentType == Type.none) {
        selectedColorExpense = const Color.fromRGBO(189, 53, 53, 0.5);
      } else if (currentType != Type.none && currentType == Type.income) {
        selectedColorExpense = const Color.fromRGBO(189, 53, 53, 0.5);
        selectedColorIncome = const Color.fromRGBO(31, 119, 0, 1);
      }
      setCategory = null;
      currentType = Type.expense;
    });
  }

  void _onTapIncome() {
    setState(() {
      if (currentType == Type.none) {
        selectedColorIncome = const Color.fromRGBO(31, 119, 0, 0.5);
      } else if (currentType != Type.none && currentType == Type.expense) {
        selectedColorIncome = const Color.fromRGBO(31, 119, 0, 0.5);
        selectedColorExpense = const Color.fromRGBO(189, 53, 53, 1);
      }
      setCategory = null;
      currentType = Type.income;
    });
  }

  Widget _setExpenseDropDown() {
    return DropdownButtonFormField(
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(top: 10, left: 8),
        labelText: 'Category',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.black,
      ),
      dropdownColor: Colors.black,
      style: GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.white,
      ),
      items: Category.values
          .map(
            (category) => DropdownMenuItem(
              value: category,
              child: Text(category.name.toString()),
            ),
          )
          .where((category) => category.value != Category.income)
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please choose a Category';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          _enteredCategory = value;
        });
      },
    );
  }

  Widget _setIncomeDropDown() {
    return TextFormField(
      keyboardType: TextInputType.none,
      decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(top: 10, left: 8),
          labelText: 'Category',
          border: OutlineInputBorder()),
      initialValue: 'Income',
      style: GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.white,
      ),
      onSaved: (newValue) {
        _enteredCategory = Category.income;
      },
    );
  }

  Widget _setDropDown() {
    return currentType == Type.income
        ? _setIncomeDropDown()
        : _setExpenseDropDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Transaction',
          style: GoogleFonts.getFont('Poppins'),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                key: Key(
                    selectedDate.toString()), //change the shown initial value
                onTap: _presentDatePicker,
                keyboardType: TextInputType.none,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(top: 10, left: 8),
                    labelText: 'Input Date',
                    border: OutlineInputBorder()),
                initialValue:
                    DateFormat('dd/MM/yyyy').add_jm().format(selectedDate),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                ),
                onSaved: (newValue) {
                  _enteredDate = selectedDate;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(top: 10, left: 8),
                  labelText: 'Amount',
                  prefix: Text('Rp. '),
                  border: OutlineInputBorder(),
                ),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null ||
                      int.tryParse(value)! <= 0) {
                    return 'Please input correct amount and format';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _enteredAmount = double.parse(newValue!);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(top: 10, left: 8),
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 && value.trim().length > 15) {
                    return 'Please input the text (the range must be between 1 - 15 letters)';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _enteredTitle = newValue!;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              _setDropDown(),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _onTapIncome,
                      child: Container(
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: selectedColorIncome,
                        ),
                        child: Center(
                          child: Text(
                            'Income',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: _onTapExpense,
                      child: Container(
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: selectedColorExpense,
                        ),
                        child: Center(
                          child: Text(
                            'Expense',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: _saveItem,
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromRGBO(31, 119, 0, 1),
                  ),
                  child: Center(
                    child: Text(
                      'Save',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
