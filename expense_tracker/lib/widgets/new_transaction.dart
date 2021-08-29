import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTrsanction extends StatefulWidget {
  NewTrsanction(this.addNewTransaction);

  //* ----------------- variables -----------------
  final Function addNewTransaction;

  @override
  _NewTrsanctionState createState() => _NewTrsanctionState();
}

class _NewTrsanctionState extends State<NewTrsanction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime? dateTime;

  void addTransaction() {
    if (titleController.text.isEmpty ||
        double.parse(amountController.text) < 0 ||
        dateTime == null) {
      return;
    }

    widget.addNewTransaction(
      titleController.text,
      double.parse(amountController.text),
      dateTime,
    );

    Navigator.of(context).pop();
  }

  void presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((value) {
      setState(() {
        dateTime = value;
      });
      print(dateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            //* ----------------- title-textfield -----------------
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: titleController,
              keyboardType: TextInputType.name,
            ),
            //* ----------------- amount-textfield -----------------
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: amountController,
              keyboardType: TextInputType.datetime,
              onSubmitted: (_) {
                addTransaction();
              },
            ),
            //* ----------------- date textfield and button -----------------
            SizedBox(height: 10),
            Row(
              children: [
                Text(dateTime == null
                    ? 'No Date chosen'
                    : DateFormat().add_yMd().add_jm().format(dateTime!)),
                TextButton(
                  onPressed: () {
                    presentDatePicker();
                  },
                  child: Text(
                    'Choose Date',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            //* ----------------- add-transaction-button -----------------
            TextButton(
              onPressed: () {
                addTransaction();
              },
              child: Text(
                'Add Transaction',
                style: TextStyle(
                  color: Colors.purple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
