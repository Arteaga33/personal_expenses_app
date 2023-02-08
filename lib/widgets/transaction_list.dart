import 'package:flutter/material.dart';

import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function rmTx;

  const TransactionList(this.transactions, this.rmTx);

  @override
  Widget build(BuildContext context) {
    print('build() TransactionList');
    return transactions.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(
                  //This works as an spacer, doesnt need/require child.
                  height: 10,
                ),
                SizedBox(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    )),
              ],
            );
          })
        : ListView.builder(
            //This is knonw as a ternary expresion, it works similar to an If i think but simplified. The if ? :
            //Another way to make it scrollable not from main. Better for long list.
            itemBuilder: (ctx, index) {
              return TransactionItem(/*key: /*UniqueKey() changes with state tho*/ValueKey(index),*/transaction: transactions[index], rmTx: rmTx);
              //This part is a bit complex
              /*return Card(
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Theme.of(context).primaryColor,
                          //color: Colors.green, //was changed by the Theme color
                          width: 2,
                        )),
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          '\$ ${transactions[index].amount.toStringAsFixed(2)}', //tx.amount.toString(), Got changed using Sting interpolation.
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Theme.of(context).primaryColor,
                            //color: Colors.green,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            transactions[index].title,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            DateFormat().format(transactions[index].date),
                            style: const TextStyle(color: Colors.grey),
                          ) //The intl package was used here.
                        ],
                      )
                    ],
                  ),
                );*/ //This code got replaced with the alternative of using ListTile Widget.
            },
            itemCount: transactions.length,
            //children: transactions.map((tx) {
            //here we show the card with the text widget.
            //}).toList(), //Instead of using <widgets> it points to the transaction map.
          );
  }
}


