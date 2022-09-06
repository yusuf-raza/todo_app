import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../models/todo.dart';

class NewToDoItem extends StatefulWidget {
  // const TransactionForm({Key? key}) : super(key: key);

  final Function addTodo;

  const NewToDoItem(this.addTodo, {Key? key}) : super(key: key);

  @override
  State<NewToDoItem> createState() => _NewToDoItemState();
}

class _NewToDoItemState extends State<NewToDoItem> {
  //final amountInputController = TextEditingController();

  final titleInputController = TextEditingController();

  DateTime? _selectedDate;


  void _submitInputForm() {
    final enteredTitle = titleInputController.text;

    if (enteredTitle.isEmpty || _selectedDate == null) {
      return;
    }
    widget.addTodo(enteredTitle, _selectedDate);
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              right: 10,
              left: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: titleInputController,
                decoration: InputDecoration(
                  label: Text('toDo item'),
                ),
                //to take focus to next field upon pressing submit
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => _submitInputForm(),
              ),
              Container(
                margin: EdgeInsets.all(10),
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_selectedDate == null
                        ? 'no date selected'
                        : "selected date: " +
                            DateFormat('yMMMMd')
                                .format(_selectedDate!)
                                .toString()),
                    TextButton(
                        onPressed: () {
                          _showDatePicker();
                        },
                        child: Text('select date',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )))
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _submitInputForm,
                child: Text("add item"),
              ), //child: Text('add transaction'))
            ],
          ),
        ),
      ),
    );
  }
}
