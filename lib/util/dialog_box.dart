import 'package:flutter/material.dart';
import 'package:to_do/services/todo_task.dart';

class DialogBox extends StatelessWidget {
  TextEditingController controller;
  VoidCallback onSave;
  VoidCallback onCancel;
  int index;
  DialogBox({
    super.key,
    this.index = -1,
    required this.controller,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow,
      content: Container(
          height: 120,
          child: Column(
            children: [
              TextField(
                  cursorColor: Colors.black,
                  autofocus: true,
                  style: TextStyle(decoration: TextDecoration.none),
                  controller: controller,
                  decoration:
                      InputDecoration(focusedBorder: UnderlineInputBorder())),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: onCancel,
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  TextButton(
                      onPressed: onSave,
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      )),
                ],
              )
            ],
          )),
    );
  }
}
