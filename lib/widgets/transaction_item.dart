import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.rmTx,
  }) : super(key: key);

  final Transaction transaction;
  final Function rmTx;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  /*
  Color? _bgColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    const availableColors = [Colors.lime, Colors.yellow, Colors.green];
    _bgColor = availableColors[Random().nextInt(3)];
  }*/

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          //backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
              padding: const EdgeInsets.all(5),
              child: FittedBox(
                  child: Text('\$${widget.transaction.amount}'))),
        ), //A wiget that is position at the begining oSf the ListTile.
        title: Text(widget.transaction.title,
            style: Theme.of(context).textTheme.headline6),
        subtitle: Text(DateFormat.yMMMMEEEEd()
            .add_Hm()
            .format(widget.transaction.date)),
        trailing: MediaQuery.of(context).size.width > 360
            ? TextButton.icon(
                icon:  Icon(Icons.delete, color: Theme.of(context).errorColor),
                label: const Text('Delete'),
                onPressed: () => widget.rmTx(widget.transaction.id),
              )
            : IconButton(
                onPressed: () => widget.rmTx(widget.transaction
                    .id), // If I need to pass arguments to a function.
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor),
      ),
    );
  }
}