import 'package:expense_tracker/components/expense_summary.dart';
import 'package:expense_tracker/data/expense_data.dart';
import 'package:expense_tracker/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Provider.of<ExpenseData>(context, listen: false).prepareDta();
  }

  // Add new expense
  void addNewExpense() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Add new expense"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Expense name
                  TextFormField(
                    controller: newExpenseNameController,
                    cursorColor: Colors.grey[800],
                    decoration: InputDecoration(
                        labelText: 'Expense Name',
                        labelStyle: TextStyle(color: Colors.grey[800]),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.grey,
                        ))),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  // Expense amount
                  TextFormField(
                    controller: newExpenseAmountController,
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.grey[800],
                    decoration: InputDecoration(
                        labelText: 'Amount',
                        labelStyle: TextStyle(color: Colors.grey[800]),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.grey,
                        ))),
                  ),
                ],
              ),
              actions: [
                // Save button
                ElevatedButton(
                  onPressed: save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                // Cancel button
                TextButton(
                    onPressed: cancel,
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.grey[800],
                      ),
                    )),
              ],
            ));
  }

  void save() {
    // Get the name and amount from controllers
    String name = newExpenseNameController.text;
    String amountText = newExpenseAmountController.text;

    if (name.isEmpty || amountText.isEmpty) {
      // Show error message if the fields are empty
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please fill in both fields.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Convert amount to double
    double? amount = double.tryParse(amountText);
    if (amount == null) {
      // Show error if the amount is not a valid number
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please enter a valid number for the amount.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Create a new expense item
    ExpenseItem newExpense = ExpenseItem(
      name: name,
      amount: amount,
      dateTime: DateTime.now(),
    );

    // Add the expense to the provider
    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);

    // Clear the text fields
    newExpenseNameController.clear();
    newExpenseAmountController.clear();

    // Close the dialog
    Navigator.of(context).pop();
  }

  void cancel() {
    // Close the dialog without saving
    Navigator.of(context).pop();
  }

  // delete expense
  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) {
        // Get the list of expenses
        final expenses = value.getAllExpenseList();

        return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Expanse Tracker",
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
              backgroundColor: Colors.grey[800],

            ),
            backgroundColor: Colors.grey[300],
            floatingActionButton: FloatingActionButton(
              onPressed: addNewExpense,
              backgroundColor: Colors.grey[800],
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: ListView(
                children: [
                  //weekly summary
                  ExpenseSummary(startOfWeek: value.startOfWeekDate()),
                  const SizedBox(
                    height: 32,
                  ),
                  //expanse list
                  expenses.isEmpty
                      ? const Center(child: Text('No expenses added yet'))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: expenses.length,
                          itemBuilder: (context, index) {
                            final expense = expenses[index];
                            return Slidable(
                              endActionPane: ActionPane(
                                motion: const StretchMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      deleteExpense(expense);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('${expense.name} deleted'),
                                          action: SnackBarAction(
                                            label: 'Undo',
                                            onPressed: () {
                                              // Undo the delete by re-adding the expense
                                              Provider.of<ExpenseData>(context,
                                                      listen: false)
                                                  .addNewExpense(expense);
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icons.delete,
                                    label: 'Delete',
                                    backgroundColor: Colors.red,
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text(
                                  expense.name,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                subtitle: Text(
                                  DateFormat('dd-MM-yyyy')
                                      .format(expense.dateTime),
                                  style: const TextStyle(fontSize: 14),
                                ),
                                trailing: Text(
                                  '${expense.amount} Tk',
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            );
                          }),
                ],
              ),
            ));
      },
    );
  }
}
