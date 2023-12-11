import 'dart:convert';
import '../utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:todo2/screens/add_page.dart';
import 'package:http/http.dart' as http;
import 'package:todo2/widget/todo_card.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List todoList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todo List'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.assignment),
              ),
              Tab(
                icon: Icon(Icons.done),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey[700],
          onPressed: navigateToAddPage,
          child: Icon(
            Icons.assignment_add,
            color: Colors.white,
          ),
        ),
        body: TabBarView(children: [
          Visibility(
            visible: !isLoading,
            replacement: const Center(child: CircularProgressIndicator()),
            child: RefreshIndicator(
              onRefresh: getAllData,
              child: Visibility(
                visible: todoList.isNotEmpty,
                replacement: Center(
                  child: Text(
                    'No Todo item',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
                    itemCount: todoList
                        .where((element) => !(element['completed'] as bool))
                        .length,
                    itemBuilder: (context, index) {
                      final item = todoList
                          .where((element) => !(element['completed'] as bool))
                          .toList()[index] as Map;
                      final id = item['_id'];
                      return ToDoCard(
                          markCompleted: markCompleted,
                          index: index,
                          item: item,
                          navigateToEditPage: navigateToEditPage,
                          deleteById: deleteById);
                    }),
              ),
            ),
          ),
          Visibility(
            visible: !isLoading,
            replacement: const Center(child: CircularProgressIndicator()),
            child: RefreshIndicator(
              onRefresh: getAllData,
              child: Visibility(
                visible: todoList.isNotEmpty,
                replacement: Center(
                  child: Text(
                    'No Todo item',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
                    itemCount: todoList
                        .where((element) => (element['completed'] as bool))
                        .length,
                    itemBuilder: (context, index) {
                      final item = todoList
                          .where((element) => (element['completed'] as bool))
                          .toList()[index] as Map;

                      final id = item['_id'];
                      return ToDoCard(
                          markCompleted: markCompleted,
                          index: index,
                          item: item,
                          navigateToEditPage: navigateToEditPage,
                          deleteById: deleteById);
                    }),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> navigateToEditPage(Map item) async {
    final route =
        MaterialPageRoute(builder: (context) => AddTodoPage(todo: item));
    await Navigator.push(context, route);
    getAllData();
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(builder: (context) => const AddTodoPage());
    await Navigator.push(context, route);
    getAllData();
  }

  Future<void> getAllData() async {
    setState(() {
      isLoading = true;
    });

    try {
      String url = 'https://todoapi.dukelee.click/api/todo';
      var uri = Uri.parse(url);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map;
        final result = json['data'] as List;
        result.sort((a, b) {
          return DateTime.parse(b['updatedAt'] as String)
              .compareTo(DateTime.parse(a['updatedAt'] as String));
        });
        setState(() {
          todoList = result;
        });
      } else {
        showMessage(context, 'Failed to get todo list', false);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteById(String id) async {
    try {
      String url = 'https://todoapi.dukelee.click/api/todo?todoId=$id';
      var uri = Uri.parse(url);
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map;
        final result = json['message'] as String;

        if (result == 'true') {
          final filteredList =
              todoList.where((item) => item['_id'] != id).toList();
          setState(() {
            todoList = filteredList;
          });
        }
      } else {
        showMessage(context, 'Failed to delete todo list', false);
      }
    } catch (e) {
      debugPrint(e.toString());
      showMessage(context, 'Failed to delete todo list', false);
    }
  }

  Future<void> markCompleted(Map item) async {
    final body = {
      // "title": title,
      'todoId': item['_id'],
      "content": utf8.decode((item['content'] as String).codeUnits),
      "completed": !item['completed']
    };
    try {
      final response = await http.put(
          Uri.parse('https://todoapi.dukelee.click/api/todo'),
          body: jsonEncode(body));
      if (response.statusCode == 200) {
      } else {
        showMessage(context, 'Failed to mark completed', false);
      }
    } catch (e) {
      debugPrint(e.toString());
      showMessage(context, 'Failed to mark completed', false);
    }
    getAllData();
  }
}
