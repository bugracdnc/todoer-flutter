// ignore: unused_import
import 'package:uuid/uuid.dart';

class Todo {
  final String id;
  String todo;
  bool done;
  final DateTime createdDate;
  final DateTime updateDate;
  final String userId;

  Todo({
    required this.id,
    required this.todo,
    required this.done,
    required this.createdDate,
    required this.updateDate,
    required this.userId,
  });

  // Parse JSON to Todo
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      todo: json['todo'],
      done: json['done'],
      createdDate: DateTime.parse(json['createdDate']),
      updateDate: DateTime.parse(json['updateDate']),
      userId: json['user_id'],
    );
  }

  // Convert Todo to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todo': todo,
      'done': done,
      'createdDate': createdDate.toIso8601String(),
      'updateDate': updateDate.toIso8601String(),
      'userId': userId,
    };
  }
}
