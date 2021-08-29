import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  Chart(this.recentTransactions);

  final List<Transaction> recentTransactions;

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].dateTime.day == weekDay.day &&
            recentTransactions[i].dateTime.month == weekDay.month &&
            recentTransactions[i].dateTime.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      // print(DateFormat.E().format(weekDay));
      // print(totalSum);

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpenfingForWeek {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(groupedTransactionValues);
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: groupedTransactionValues.map(
          (data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data['day'] as String,
                data['amount'] as double,
                (totalSpenfingForWeek == 0.0
                    ? 0.0
                    : (data['amount'] as double) / totalSpenfingForWeek),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
