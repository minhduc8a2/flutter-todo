import 'dart:convert';

class ToDoTask {
  String id;
  String content;
  bool completed;
  String updatedAt;

  ToDoTask(
      {required this.content,
      required this.completed,
      required this.updatedAt,
      this.id = ""});
  factory ToDoTask.fromJson(Map<String, dynamic> json) => ToDoTask(
        content: utf8.decode((json["content"] as String).codeUnits),
        completed: json["completed"] as bool,
        updatedAt: json["updatedAt"] as String,
        id: json["_id"],
      );

  ToDoTask clone() => ToDoTask(
      content: content, completed: completed, updatedAt: updatedAt, id: id);
  Map<String, dynamic> toJson() => {
        "content": content,
        "completed": completed.toString(),
        "updatedAt": updatedAt,
      };
}
