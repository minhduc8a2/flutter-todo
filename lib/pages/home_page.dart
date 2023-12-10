import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do/data/databasehelper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:to_do/services/todo_task.dart';
import 'package:to_do/util/dialog_box.dart';
import 'package:to_do/util/todo_tile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _controller = TextEditingController();
  List<ToDoTask> toDoList = [];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  void checkBoxChanged(value, int index) async {
    final changedTask = toDoList[index].clone();

    changedTask.completed = !changedTask.completed;
    setState(() {
      toDoList[index].completed = !toDoList[index].completed;
      toDoList[index].updatedAt = DateTime.now().toString();
      DatabaseHelper.sortList(toDoList);
    });

    bool result = await DatabaseHelper.updateTask(changedTask);
    if (result == false) {
      showError();
    }
  }

  void saveNewTask() async {
    ToDoTask newTask = ToDoTask(
        content: _controller.text,
        completed: false,
        updatedAt: DateTime.now().toString());
    setState(() {
      toDoList.add(newTask);
      DatabaseHelper.sortList(toDoList);
    });

    Navigator.of(context).pop();

    bool result = await DatabaseHelper.createTask(newTask);
    if (result == false) {
      showError();
    }
  }

  void deleteTask(index) async {
    ToDoTask deletedTask = toDoList[index].clone();
    setState(() {
      toDoList.removeAt(index);
      DatabaseHelper.sortList(toDoList);
    });

    bool result = await DatabaseHelper.deleteTask(deletedTask);
    if (result == false) {
      showError();
    }
  }

  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        });
  }

  void showError() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 100,
              child: Column(
                children: [
                  const Text("No internet"),
                  const SizedBox(
                    height: 32,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: const Text('Close')),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as List<ToDoTask>?;
    if (data == null) {
      showError();
    } else {
      toDoList = toDoList.isEmpty ? data : toDoList;
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: const Text('Duc\'s to do'),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: toDoList.length,
          itemBuilder: (context, index) {
            return ToDoTile(
              toDoTask: toDoList[index],
              onChanged: (value) => checkBoxChanged(value, index),
              deleteTask: (context) => deleteTask(index),
            );
          }),
    );
  }
}
