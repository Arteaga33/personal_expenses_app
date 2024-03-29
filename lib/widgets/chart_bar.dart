//Ctrl+Shift+P to use visual studio command panel
//Dart developer tools useful to see the widget tree.
import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctOfTotal;

  const ChartBar(this.label, this.spendingAmount, this.spendingPctOfTotal, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('build() ChartBar');
    return LayoutBuilder(builder: ((context, constraints){
      return Column(
      children: [
        SizedBox(
          height: constraints.maxHeight * 0.125,
            child: FittedBox(
                child: Text('-\$${spendingAmount.toStringAsFixed(0)}'))),
        SizedBox(
          height: constraints.maxHeight * 0.025,
        ),
        SizedBox(
          height: constraints.maxHeight * 0.7,
          width: 10,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 1.0),
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                heightFactor: spendingPctOfTotal,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: constraints.maxHeight * 0.025,
        ),
        SizedBox(
          height: constraints.maxHeight * 0.125,
          child: FittedBox(child: Text(label))),
      ],
    );
    })); 
  }
}
