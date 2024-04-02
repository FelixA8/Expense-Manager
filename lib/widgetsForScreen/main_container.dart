import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:intl/intl.dart';

class MainContainer extends StatefulWidget {
  const MainContainer(
      {super.key,
      required this.totalBalance,
      required this.totalIncome,
      required this.totalExpense});
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  String getFormattedAccount(double amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0)
        .format(amount);
  }

  String getFormattedAccount2(double amount) {
    return NumberFormat.currency(
            locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0)
        .format(amount);
  }

  @override
  Widget build(BuildContext context) {
    double totalValueBalance = 0;
    Color colorAmount = Colors.white;
    totalValueBalance = widget.totalBalance;
    if (widget.totalBalance > 0) {
      colorAmount = const Color.fromRGBO(31, 119, 0, 1);
    } else if (widget.totalBalance < 0) {
      colorAmount = const Color.fromRGBO(189, 53, 53, 1);
      totalValueBalance = totalValueBalance * -1;
    } else if (widget.totalBalance == 0) {
      colorAmount = const Color.fromRGBO(255, 255, 255, 0.65);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 134,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromRGBO(34, 34, 34, 1),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Balance',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: const Color.fromRGBO(255, 255, 255, 0.65),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5, right: 5),
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
                            getFormattedAccount(totalValueBalance),
                            style: GoogleFonts.poppins(
                              fontSize: 30,
                              color: colorAmount,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 25, bottom: 25, left: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromRGBO(31, 119, 0, 1),
                              ),
                              child: const Icon(FontAwesomeIcons.arrowUp),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                getFormattedAccount2(widget.totalIncome),
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromRGBO(189, 53, 53, 1),
                              ),
                              child: const Icon(FontAwesomeIcons.arrowDown),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                getFormattedAccount2(widget.totalExpense),
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
