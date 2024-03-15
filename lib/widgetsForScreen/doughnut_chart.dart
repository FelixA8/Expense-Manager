import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DoughnutChart extends StatefulWidget {
  const DoughnutChart(
      {super.key, required this.totalExpense, required this.totalIncome});
  final double totalIncome;
  final double totalExpense;

  @override
  State<DoughnutChart> createState() => _DoughnutChartState();
}

class _DoughnutChartState extends State<DoughnutChart> {
  @override
  Widget build(BuildContext context) {
    double totalIncomePercentage =
        widget.totalIncome * 100 / (widget.totalExpense + widget.totalIncome);
    String inString = totalIncomePercentage.toStringAsFixed(2);
    double onIncome = double.parse(inString);
    double totalExpensePercentage = 100 - onIncome;
    inString = totalExpensePercentage.toStringAsFixed(2);
    double onExpense = double.parse(inString);
    final List<ChartData> chartData = [
      ChartData(
        'Expense',
        onExpense,
        const Color.fromRGBO(189, 53, 53, 1),
      ),
      ChartData(
        'Income',
        onIncome,
        const Color.fromRGBO(31, 119, 0, 1),
      ),
    ];
    return SfCircularChart(
      borderWidth: 4,
      series: <CircularSeries>[
        // Renders doughnut chart
        DoughnutSeries<ChartData, String>(
          dataSource: chartData,
          pointColorMapper: (ChartData data, _) => data.color,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          innerRadius: '70%',
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
            textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          explode: true,
          // First segment will be exploded on initial rendering
          explodeIndex: 1,
          explodeAll: true,
        ),
      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
