import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:to_do/services/todo_task.dart';

class DatabaseHelper {
  static int point(ToDoTask a) {
    if (a.completed) {
      return 0;
    } else {
      return 1;
    }
  }

  static void sortList(List<ToDoTask> list) {
    list.sort((a, b) {
      int first =
          DateTime.parse(b.updatedAt).compareTo(DateTime.parse(a.updatedAt));
      int second = point(b).compareTo(point(a)) * 2;
      return second + first;
    });
  }

  static Future<List<ToDoTask>?> getAllTask() async {
    try {
      String url = 'https://todoapi.dukelee.click/api/todo';
      var uri = Uri.parse(url);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map;
        final result = (json['data'] as List).cast<Map<String, dynamic>>();

        final toDoList =
            result.map<ToDoTask>((json) => ToDoTask.fromJson(json)).toList();
        sortList(toDoList);

        return toDoList;
      }
    } catch (error) {}

    return null;
  }

  static Future<bool> createTask(ToDoTask task) async {
    try {
      String url = 'https://todoapi.dukelee.click/api/todo';
      var uri = Uri.parse(url);
      final body = {
        'content': task.content,
        'completed': task.completed,
      };
      final response = await http.post(uri, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map;
        String message = json['message'] as String;

        return message == 'true' ? true : false;
      }
    } catch (error) {}

    return false;
  }

  static Future<bool> updateTask(ToDoTask task) async {
    try {
      String url = 'https://todoapi.dukelee.click/api/todo';
      var uri = Uri.parse(url);
      final body = {
        'todoId': task.id,
        'content': task.content,
        'completed': task.completed,
      };
      final response = await http.put(uri, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map;
        String message = json['message'] as String;
        return message == 'true' ? true : false;
      }
    } catch (error) {}

    return false;
  }

  static Future<bool> deleteTask(ToDoTask task) async {
    try {
      String url = 'https://todoapi.dukelee.click/api/todo?todoId=${task.id}';
      var uri = Uri.parse(url);
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map;
        String message = json['message'] as String;
        return message == 'true' ? true : false;
      }
    } catch (error) {}

    return false;
  }
}
