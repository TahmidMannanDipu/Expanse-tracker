import 'package:expense_tracker/models/expense_item.dart';
import 'package:hive/hive.dart';

class HiveDataBase{
  //reference our box
final _myBox =Hive.box("expense_database");
// write data
void saveData(List<ExpenseItem>allExpense){
  List<List<dynamic>> allExpensesFormatted = [];
  for (var expense in allExpense){
    List<dynamic> expenseFormated = [
      expense.name,
      expense.amount,
      expense.dateTime
    ];
    allExpensesFormatted.add(expenseFormated);
  }
  _myBox.put("All_Expenses", allExpensesFormatted);
}
//reading data
List<ExpenseItem> readData() {
  List savedExpenses =_myBox.get("ALL_EXPENSES") ?? [];
  List<ExpenseItem> allExpenses = [];
  for (int i = 0; i <savedExpenses.length; i++) {
    String name = savedExpenses[i][0];
    double amount = savedExpenses[i][1];
    DateTime dateTime = savedExpenses[i][2];

    ExpenseItem expense = ExpenseItem(name: name,
        amount: amount,
        dateTime: dateTime);
    allExpenses.add(expense);
  }
  return allExpenses;
}


}