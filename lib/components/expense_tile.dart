import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ExpenseTile extends StatelessWidget {
 const ExpenseTile(
      {super.key, required this.name, required this.amount, required this.dateTime,
        required this.deleteTapped});

  final String name;
  final double amount;
  final DateTime dateTime;
  final void Function(BuildContext)? deleteTapped;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(motion: const StretchMotion(),
          children: [
            SlidableAction(onPressed: deleteTapped,
            icon: Icons.delete,)
          ]),
      child: ListTile(
        title: Text(name),
        subtitle: Text(DateFormat('dd-MM-yyyy').format(dateTime)),
        trailing: Text("$amount"),
      ),
    );
  }
}

