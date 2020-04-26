import 'package:flutter/material.dart';

import './models/transaction.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses', 
      home: MyHomePage(), 
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(fontFamily: 'OpenSans', fontSize: 18, fontWeight: FontWeight.bold),
            button: TextStyle(color: Colors.white),  
          ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(fontFamily: 'OpenSans', fontSize: 20, fontWeight: FontWeight.bold)
          )
        )      
      ),
      debugShowCheckedModeBanner: false,
      
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Transaction> _userTransactions = [
    // Transaction(id: '1', title: 'New Shoe', amount: 60, date: DateTime.now()),
    // Transaction(
    //     id: '2',
    //     title: 'Weekly groceries',
    //     amount: 54.99,
    //     date: DateTime.now()), 
    // Transaction(
    //     id: '3', title: 'Phone bill', amount: 19.99, date: DateTime.now()),
    // Transaction(
    //     id: '4', title: 'Internet', amount: 29.99, date: DateTime.now()),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx){
      return tx.date.isAfter(DateTime.now().subtract(Duration(days:7)));
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime chosenDate){
    final newTx = Transaction(
      title: title, 
      amount: amount, 
      date: chosenDate,
      id: DateTime.now().toString(),
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id){
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
    
  }

  void _startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(context: ctx, builder: (_){
      return NewTransaction(_addNewTransaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Personal Expenses',
          style: TextStyle(
            fontFamily: 'OpenSans'
          ),
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add,), onPressed:()=>_startAddNewTransaction(context),),
        ],
      ),
      body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Chart(_recentTransactions),
                  TransactionList(_userTransactions, _deleteTransaction),
                ],
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=>_startAddNewTransaction(context),
      ),      
    );
  }
}
