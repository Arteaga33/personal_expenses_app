import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      //print(DateFormat.E()
      //    .format(weekDay)
      //    .substring(0, 1)); //This was making the error.
      //print(totalSum);

      return {
        'day': DateFormat.E().format(weekDay).toString(),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  Chart(this.recentTransactions){
    print('Constructor Chart');
  }

  @override
  Widget build(BuildContext context) {
    print('build() Chart');
    //print(groupedTransactionValues);
    return Card(
        elevation: 6,
        margin: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionValues.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                    data['day'] as String,
                    data['amount'] as double,
                    totalSpending == 0.0 ? 0.0 : (data['amount'] as double) /
                        totalSpending),
              ); //Ternary expresion if to check for 0/0
            }).toList(),
          ),
        ),
      );
  }
}
