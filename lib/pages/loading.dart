import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:to_do/data/databasehelper.dart';
import 'package:to_do/services/todo_task.dart';
import 'package:http/http.dart' as http;

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Future<bool> hasNetwork() async {
    try {
      final result = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
      if (result.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  void setupWorldTime() async {
    bool result = await hasNetwork();
    debugPrint('${result}');
    if (result == false) {
      if (!context.mounted) return;
      return showDialog(
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
    List<ToDoTask>? toDoList = await DatabaseHelper.getAllTask();
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, "/home", arguments: toDoList);
  }

  @override
  void initState() {
    debugPrint('loading is running...');
    super.initState();

    setupWorldTime();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.yellow,
      body: SafeArea(
          child: SpinKitFadingCircle(
        color: Colors.black,
        size: 50,
      )),
    );
  }
}
