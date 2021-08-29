import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transaction;
  final Function deleteTransaction;

  TransactionList(this.transaction, this.deleteTransaction);
  @override
  Widget build(BuildContext context) {
    return (transaction.isEmpty)
        ? Image.asset(
            'assets/images/waiting.png',
            fit: BoxFit.cover,
          )
        : ListView.builder(
            itemCount: transaction.length,
            itemBuilder: (ctx, index) {
              return Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        //* ----------------- amount container -----------------
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          margin: const EdgeInsets.only(
                            top: 5,
                            bottom: 5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Text(
                            '${transaction[index].amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //* ----------------- item name -----------------
                            Text(
                              transaction[index].title,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            //* ----------------- item date -----------------
                            Text(DateFormat()
                                .add_yMd()
                                .add_jm()
                                .format(transaction[index].dateTime)),
                          ],
                        ),
                      ],
                    ),
                    //* ----------------- delete button -----------------
                    IconButton(
                      onPressed: () {
                        deleteTransaction(transaction[index].id);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).errorColor,
                      ),
                    )
                  ],
                ),
              );
            },
          );
  }
}
