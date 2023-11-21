import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toDoo/widgets/new_todo_item.dart';
import 'package:toDoo/widgets/todo_list.dart';

import 'models/todo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String path;
  if(kIsWeb){
    path = "/assets/db";
  }else{
    final directory = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(directory.path);
  }

  Hive.registerAdapter(TodoItemsAdapter());

  await Hive.openBox('todo_items');

  runApp(MaterialApp(
    home: const MyApp(),
    title: "toDo app",
    theme: ThemeData(
      primarySwatch: Colors.blueGrey,
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<TodoItems> _userTransactions = [];

  void _addNewItem(String todoItem, DateTime chosenDate) {
    final newTodo = TodoItems(
        id: DateTime.now().toString(), title: todoItem, date: chosenDate);

    setState(() {
      //_userTransactions.add(newTodo);
      Hive.box('todo_items').add(newTodo);
    });

    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    void showModal(BuildContext ctx) {
      showModalBottomSheet(
          context: ctx,
          builder: (builderContext) {
            return NewToDoItem(_addNewItem);
          });
    }

    @override
        //declaring app bar in a variable so that
        //we can deduct the height of it from screen size when making app
        //accessible for all screen types
        final appBar = AppBar(
      title: const Text("toDoo app"),
      actions: [
        IconButton(onPressed: () => showModal(context), icon: const Icon(Icons.add))
      ],
    );

    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: appBar,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModal(context);
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
          child: Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.9,
              child:  ToDoList(userTransactions: _userTransactions))),
    );
  }

  @override
  void dispose() {
    super.dispose();
    Hive.close();
  }
}
