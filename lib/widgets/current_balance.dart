import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class CurrentBalance extends StatelessWidget {
  final double balance = 330000;

  const CurrentBalance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Center(
            child: Text('\$$balance',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green))),
      ),
    );
  }
}
