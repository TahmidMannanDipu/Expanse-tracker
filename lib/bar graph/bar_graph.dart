import 'package:expense_tracker/bar%20graph/bar_data.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MyBarGraph extends StatelessWidget {
  final double? maxY;
  final double sunAmount;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thuAmount;
  final double friAmount;
  final double satAmount;

  const MyBarGraph({
    super.key,
    required this.sunAmount,
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thuAmount,
    required this.friAmount,
    required this.satAmount,
    this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
      sunAmount: sunAmount,
      monAmount: monAmount,
      tueAmount: tueAmount,
      wedAmount: wedAmount,
      thuAmount: thuAmount,
      friAmount: friAmount,
      satAmount: satAmount,
    );
    myBarData.initalizedBarData();

    return BarChart(
      BarChartData(
        maxY: maxY,
        minY: 0,
        titlesData: const FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getBottomTitles,
            ),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: myBarData.barData.map((data) =>
            BarChartGroupData(
              x: data.x, // Each day has a unique x-value
              barRods: [
                BarChartRodData(
                  toY: data.y,
                  width: 25,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxY,
                    color: Colors.grey[100],
                  ),
                  color: Colors.grey[800], // Customize bar color
                ),
              ],
            ),
        ).toList(),
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  var style = TextStyle(
    color: Colors.grey[800],
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = Text("Sat", style: style); // Change to Sat for x = 0
      break;
    case 1:
      text = Text("Sun", style: style);
      break;
    case 2:
      text = Text("Mon", style: style);
      break;
    case 3:
      text = Text("Tue", style: style);
      break;
    case 4:
      text = Text("Wed", style: style);
      break;
    case 5:
      text = Text("Thu", style: style);
      break;
    case 6:
      text = Text("Fri", style: style);
      break;
    default:
      text = Text('', style: style);
      break;
  }
  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}

