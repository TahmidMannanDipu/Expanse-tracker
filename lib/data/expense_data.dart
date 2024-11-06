import 'package:expense_tracker/data/hive_database.dart';
import 'package:expense_tracker/datetime/date_time_helper.dart';
import 'package:expense_tracker/models/expense_item.dart';
import 'package:flutter/cupertino.dart';

class ExpenseData extends ChangeNotifier{
  // list of all expense
  List<ExpenseItem>overallExpenseList = [];

  // get expense list
  List<ExpenseItem>getAllExpenseList (){
    return overallExpenseList;
  }
  //prepare data to display
  final db =HiveDataBase();
  void prepareDta(){
    if(db.readData().isNotEmpty){
      overallExpenseList = db.readData();
    }
  }

  // add new expense
  void addNewExpense(ExpenseItem newExpense){
    overallExpenseList.add(newExpense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }
  //delete expense
  void deleteExpense(ExpenseItem expense){
    overallExpenseList.remove(expense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // get weekday(mon, tue) from a dateTime object
  String getDayName(DateTime dateTime){
    switch(dateTime.weekday){
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 7:
        return "Sunday";

        default: return "";
    }
  }
  // get the date for start of the week (saturday)

DateTime startOfWeekDate(){
    DateTime? startOfWeek;
    //get todays date
  DateTime today =DateTime.now();
  // go backwards from today to find sunday
  for(int i =0; i<7;i++){
    if (getDayName(today.subtract(Duration(days: i)))=='Saturday'){
      startOfWeek = today.subtract(Duration(days: i));
    }
  }
  return startOfWeek!;
}

  /*convert overall list of expense into a daily expense summary
  e.g.
  overallExpenseList =
  [
  [food,30/01/2024,$10],
  [other,30/01/2024,$70],
  ]
  Daily Expense Summary. =

  [

  [10/2/2024,$100],
  [11/2/2024,$200],
  ]

  */

Map<String, double> calculateDailyExpenseSummary (){
  Map<String,double> dailyExpenseSummary = {
    // date(ddmmyyyy) : amount total for day
  };
  for (var expense in overallExpenseList){
    String date = convertDateTimeToString(expense.dateTime);
    double amount = expense.amount;
    if (dailyExpenseSummary.containsKey(date)){
      double currentAmount = dailyExpenseSummary[date]!;
      currentAmount += amount;
      dailyExpenseSummary[date] = currentAmount;
    }
    else {
      dailyExpenseSummary.addAll({date: amount});
    }

  }
  return  dailyExpenseSummary;
}
}