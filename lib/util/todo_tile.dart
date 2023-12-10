import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do/services/todo_task.dart';

class ToDoTile extends StatelessWidget {
  final ToDoTask toDoTask;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteTask;

  ToDoTile({
    super.key,
    required this.toDoTask,
    required this.onChanged,
    required this.deleteTask,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25.0, 25, 25, 0),
      child: Slidable(
          endActionPane: ActionPane(
            motion: StretchMotion(),
            children: [
              SlidableAction(
                onPressed: deleteTask,
                icon: Icons.delete,
                backgroundColor: Colors.red.shade300,
                borderRadius: BorderRadius.circular(16),
              )
            ],
          ),
          child: Card(
            color: Colors.yellow,
            elevation: 6,
            shape: RoundedRectangleBorder(
              //<-- SEE HERE
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              onTap: () {},
              title: Text(
                toDoTask.content,
              ),
              leading: Checkbox(
                value: toDoTask.completed,
                onChanged: onChanged,
                activeColor: Colors.black,
              ),
              minVerticalPadding: 32,
            ),
          )),
    );
  }
}
