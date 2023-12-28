import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx, {Key? key}) : super(key: key) {
    print('Constructor NewTransaction Widget');
  }

  @override
  _NewTransactionState/*State<NewTransaction>*/ createState() {
    print('CreateState NewTransaction Widget');
    return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleControler = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  _NewTransactionState(){
    print('Construtor NewTransaction State');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('Own initializations. initState()');
  }

  @override
  void didUpdateWidget(covariant NewTransaction oldWidget) {
    // TODO: implement didUpdateWidget
    print('didUpdateWidget()');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print('dispose()');
    super.dispose();
  }

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = _titleControler.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return; //In here th code below is not run if true.
    }

    widget.addTx(
        //This widget.something was added by flutter when refactoring to get the addTx from upside.
        _titleControler.text,
        double.parse(
          _amountController.text,
        ),
        _selectedDate);
    Navigator.of(context).pop(); //Closes the sheet when it's done/summited.
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    }); //This is Future it allows to do something after the user picked a date.
    //print('...'); //The .then doesnt block the code from running in the method.
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: _titleControler,
                onSubmitted: (_) => _submitData(),
                //onChanged: (value) {
                //titleInput = value;
                //},
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) =>
                    _submitData(), //Anonymus function that pases a value. The value "_"is never used.
                //onChanged: (value2) => amountInput = value2, //There is an alternative way to do it. Class 85.
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'No Date Chosen!'
                          : 'Picked Date: ${DateFormat.yMMMMEEEEd().format(_selectedDate as DateTime)}'),
                    ),
                    TextButton(
                        onPressed: _presentDatePicker,
                        child: const Text(
                          'Choose Date',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    //print(title.text);
                    //print(_amountController.text);
                    _submitData();
                  },
                  child: const Text(
                    'Add Transaction',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
            ]),
      ),
    );
  }
}
