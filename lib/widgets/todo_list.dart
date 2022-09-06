import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:toDoo/main.dart';
import 'package:toDoo/widgets/new_todo_item.dart';

import '../models/todo.dart';

class ToDoList extends StatefulWidget {
  final List<TodoItems> userTransactions;
  // final Function deleteTransaction;

  const ToDoList({Key? key, required this.userTransactions}) : super(key: key);

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  @override
  Widget build(BuildContext context) {
    final todoBox = Hive.box('todo_items');

    todoBox.watch(key: todoBox.keys);

    return todoBox.isEmpty
        ? LayoutBuilder(builder: (context, constraint) {
            return Container(
                alignment: Alignment.center,
                height: constraint.maxHeight * 0.3,
                child: const Image(
                  image: AssetImage("assets/images/waiting.png"),
                  fit: BoxFit.scaleDown,
                ));
          })
        : ListView.builder(
            itemCount: todoBox.length,
            itemBuilder: (context, index) {
              final todoItems = todoBox.getAt(index) as TodoItems;

              return Dismissible(
                key: ValueKey(Hive.box('todo_items').keyAt(index)),
                onDismissed: (context) {
                  setState(() {
                    Hive.box('todo_items').deleteAt(index);
                    todoBox.watch();
                    //_userTransactions.removeWhere((element) => element.id == txId);
                  });
                },
                background: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                  color: Theme.of(context).errorColor,
                  child: const Icon(
                    Icons.delete,
                    size: 30,
                    color: Colors.white,
                  ),
                  alignment: Alignment.centerRight,
                ),
                child: Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 6,
                  child: ListTile(
                    title: Text(todoItems.title),
                    subtitle: Row(
                      children: [
                        const Icon(Icons.calendar_month),
                        Text(DateFormat('yMMMMd')
                            .format(todoItems.date)
                            .toString())
                      ],
                    ),
                    trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {

                          setState(() {

                            Hive.box('todo_items').deleteAt(index);
                          });
                        }),
                  ),
                ),
              );
            },
          );
  }

}
