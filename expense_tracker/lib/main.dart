import 'dart:io';

// import 'package:flutter/services.dart';

import '/widgets/chart.dart';
import 'widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import 'models/transaction.dart';
import 'widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';

void main() {
  //* ----------------- controlling device orientation -----------------
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //* ----------------- theme-data -----------------
      theme: ThemeData(
        primarySwatch: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
        ),
      ),
      debugShowCheckedModeBanner: false,

      home: HomePage(),
    );
  }
}

//* ----------------- homepage widget -----------------
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //* ----------------- transaction-list -----------------
  final List<Transaction> _transactions = [
    // Transaction(
    //   id: '001',
    //   title: 'shoes',
    //   amount: 29.99,
    //   dateTime: DateTime.now(),
    // ),
    // Transaction(
    //   id: '002',
    //   title: 'shirts',
    //   amount: 10.99,
    //   dateTime: DateTime.now(),
    // ),
  ];

  bool _isShowingChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tx) {
      return tx.dateTime.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransactions(
      String txTitle, double txAmount, DateTime txDateTime) {
    final tx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      dateTime: txDateTime,
    );

    setState(() {
      _transactions.add(tx);
    });
  }

  void startNewTransaction(context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return NewTrsanction(_addNewTransactions);
      },
    );
  }

  void deleteTransactions(id) {
    setState(() {
      _transactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Expense Tracker'),
      //* ----------------- app buttons -----------------
      actions: [
        IconButton(
          onPressed: () => startNewTransaction(context),
          icon: Icon(
            Icons.add,
          ),
        )
      ],
    );
    var landscapeOrientation =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (landscapeOrientation)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Show Chart only'),
                  //* ----------------- swicth -----------------
                  Switch.adaptive(
                      value: _isShowingChart,
                      activeColor: Theme.of(context).accentColor,
                      onChanged: (value) {
                        setState(() {
                          _isShowingChart = value;
                        });
                      }),
                ],
              ),
            //* ----------------- chart container -----------------
            if (!landscapeOrientation)
              Container(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.3,
                child: Chart(_recentTransactions),
              ),
            if (!landscapeOrientation)
              Container(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.7,
                child: TransactionList(_transactions, deleteTransactions),
              ),
            if (landscapeOrientation)
              _isShowingChart
                  ? Container(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.7,
                      child: Chart(_recentTransactions),
                    )
                  :
                  //* ----------------- user-transaction -----------------
                  Container(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.7,
                      child: TransactionList(_transactions, deleteTransactions),
                    ),
          ],
        ),
      ),
      //* ----------------- floating action button -----------------
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => startNewTransaction(context),
            ),
    );
  }
}
