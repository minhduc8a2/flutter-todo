import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/snack_bar.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController contentController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final content = utf8.decode((todo['content'] as String).codeUnits);
      contentController.text = utf8.decode(content.codeUnits);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: contentController,
            decoration: const InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(isEdit ? 'Update' : 'Submit'),
              ))
        ],
      ),
    );
  }

  Future<void> submitData() async {
    final content = contentController.text;
    final body = {
      // "title": title,
      "content": content,
      "completed": false
    };
    try {
      final response = await http.post(
          Uri.parse('https://todoapi.dukelee.click/api/todo'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body));
      if (response.statusCode == 200) {
        contentController.text = '';
        showMessage(context, 'Todo created', true);
      } else {
        showMessage(context, 'Failed to create', false);
      }
    } catch (e) {
      debugPrint(e.toString());
      showMessage(context, 'Failed to create', false);
    }
  }

  Future<void> updateData() async {
    final content = contentController.text;
    final body = {
      // "title": title,
      'todoId': widget.todo?['_id'],
      "content": content,
      "completed": widget.todo?['completed']
    };
    try {
      final response = await http.put(
          Uri.parse('https://todoapi.dukelee.click/api/todo'),
          body: jsonEncode(body));
      if (response.statusCode == 200) {
        showMessage(context, 'Todo updated', true);
      } else {
        showMessage(context, 'Failed to update', false);
      }
    } catch (e) {
      debugPrint(e.toString());
      showMessage(context, 'Failed to update', false);
    }
  }
}
