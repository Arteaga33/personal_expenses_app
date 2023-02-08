import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/services.dart';

import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';

void main() {
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown
  // ]); //This forces to only allow landscape
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('build() MyHomePageState');
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        errorColor: Colors.red, //This is already the default
        primarySwatch: Colors.green,
        //accentColor: Colors.amber, //Deprecated.
        fontFamily: 'Quicksand',
        appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        //toolbarTextStyle: TextStyle(fontFamily: 'OpenSans', fontSize: 20)),
      ),
      home: const MyHomePage(title: 'Arteaga Personal Expenses'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
  //There are several methods like initState(); build(); setState(); didUpdateWidget(); build(); dispose();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver { //The with to combine like extend
  final List<Transaction> _userTransactions = [
    /*
    Transaction(id: 'T1', title: 'New Shoes', amount: 30, date: DateTime.now()),
    Transaction(
        id: 'T2', title: 'Weekly Groceries', amount: 70, date: DateTime.now())*/
  ];

  bool _showChart = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    print(state);
  }

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  
  @override
  dispose(){
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList(); //I had to change form iterable to list.
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        //date: DateTime.now()) //This got changed for a selected Date.
        date: chosenDate);

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere(
          (tx) => tx.id == id); //This is instead of () {}. (Shorter syntax)
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    //To show a sheet that appears from below.
    showModalBottomSheet(
      //New issue stuff disapearing. Fixed by making new transaction stateful.
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {}, //To avoid the sheet from closing
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior
              .opaque, //This avoids that is haddled by anyone else.
        ); //Check class 94
      },
    );
  }

  List<Widget> _buildLanscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Row(
        //Cool way to add an if inside a list.
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('ShowChart'),
          Switch.adaptive(
              // The .adaptive knows if it's IOs of android.
              value: _showChart,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              }),
        ],
      ),
      _showChart
          ? SizedBox(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransactions))
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      SizedBox(
          height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              0.3,
          child: Chart(_recentTransactions)),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(
        context); //It's recommended to use like this instead of the long way. Improve performance.

    final isLandscape =
        mediaQuery.orientation == Orientation.landscape; //cool comparison
    //This context if you are confused.
    final appBar = AppBar(
      title: Text(widget.title),
      actions: [
        //To configure the floating buttons. On the app bar.
        IconButton(
            onPressed: () => _startAddNewTransaction(
                context), //This pases an anonymous function thar passes on the the context.
            icon: const Icon(Icons.add))
      ],
    );
    final txListWidget = SizedBox(
        // I can create variables that are Widgets.
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7, //Class 120 dynamic calculating spaces.
        child: TransactionList(_userTransactions, _deleteTransaction));
    final pageBody = SingleChildScrollView(
      //To make it scrollabe. I can set up the scrollable space I want. Alternative ListView needs a height on a previous container.
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isLandscape)
              ..._buildLanscapeContent(mediaQuery, appBar, txListWidget),
            if (!isLandscape)
              ..._buildPortraitContent(mediaQuery, appBar, txListWidget),
          ]), //There is a ternary expresion in here.
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child:
                pageBody, /*I'll skip the cupertino navigation bar for now.*/
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Platform.isIOS
                ? const SizedBox()
                : Container(
                    //To avoid rendering button on IOs
                    margin: const EdgeInsets.all(15),
                    child: FloatingActionButton(
                      child: const Icon(Icons.add),
                      onPressed: () => _startAddNewTransaction(context),
                    ),
                  ),
          );
  }
}
