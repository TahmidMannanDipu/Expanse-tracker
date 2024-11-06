import 'package:expense_tracker/bar%20graph/bar_graph.dart';
import 'package:expense_tracker/datetime/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/expense_data.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const ExpenseSummary({super.key, required this.startOfWeek});

  @override
  Widget build(BuildContext context) {
    // Convert each day of the week to a formatted date string
    String saturday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 0)));
    String sunday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 1)));
    String monday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 2)));
    String tuesday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 3)));
    String wednesday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 4)));
    String thursday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 5)));
    String friday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 6)));

    // calculate max amount in bar graph

    double calculateMax(
      ExpenseData value,
      String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      String saturday,
    ) {
      final summary = value.calculateDailyExpenseSummary();
      double? max = 100;
      List<double> values = [
        summary[saturday] ?? 0,
        summary[sunday] ?? 0,
        summary[monday] ?? 0,
        summary[tuesday] ?? 0,
        summary[wednesday] ?? 0,
        summary[thursday] ?? 0,
        summary[friday] ?? 0,
      ];

      values.sort();

      max = values.last * 1.1;
      return max == 0 ? 100 : max;
    }
      // calculate week total
    double calculateWeekTotal (
        ExpenseData value,
        String sunday,
        String monday,
        String tuesday,
        String wednesday,
        String thursday,
        String friday,
        String saturday,
        ){
      final summary = value.calculateDailyExpenseSummary();
      List<double> values = [
        summary[saturday] ?? 0,
        summary[sunday] ?? 0,
        summary[monday] ?? 0,
        summary[tuesday] ?? 0,
        summary[wednesday] ?? 0,
        summary[thursday] ?? 0,
        summary[friday] ?? 0,
      ];
      double total = 0;
      for (int i = 0; i< values.length; i++){
        total += values[i];
      }
      return total;
    }
    return Consumer<ExpenseData>(
      builder: (context, value, child) {
        // Retrieve the expense summary for each day
        final expenseSummary = value.calculateDailyExpenseSummary();

        return Column(
          children: [
            //week total
            Padding(
              padding: const EdgeInsets.only(left: 16.0,bottom: 16),
              child: Row(
                children: [Text("Week Total:${calculateWeekTotal(value,
                    sunday, monday, tuesday, wednesday, thursday, friday, saturday)}",
                style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)],
              ),
            ),
            SizedBox(
              height: 200,
              child: MyBarGraph(
                maxY: calculateMax(value, sunday, monday, tuesday, wednesday,
                    thursday, friday, saturday),
                satAmount: expenseSummary[saturday] ?? 0,
                sunAmount: expenseSummary[sunday] ?? 0,
                monAmount: expenseSummary[monday] ?? 0,
                tueAmount: expenseSummary[tuesday] ?? 0,
                wedAmount: expenseSummary[wednesday] ?? 0,
                thuAmount: expenseSummary[thursday] ?? 0,
                friAmount: expenseSummary[friday] ?? 0,
              ),
            ),
          ],
        );
      },
    );
  }
}
