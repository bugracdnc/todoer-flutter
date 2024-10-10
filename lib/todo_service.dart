import 'dart:convert';
import 'package:http/http.dart' as http;
import 'todo_model.dart';

class TodoService {
  final String apiUrl = 'http://192.168.0.107:8654/api/v1/todoer';
  final String token;

  TodoService(this.token);

  Future<List<Todo>> fetchTodos() async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((todo) => Todo.fromJson(todo)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<void> addTodo(Todo todo) async {
    await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(todo.toJson()),
    );
  }

  Future<void> updateTodo(Todo todo) async {
    await http.put(
      Uri.parse('$apiUrl/${todo.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(todo.toJson()),
    );
  }

  Future<void> deleteTodo(String id) async {
    await http.delete(
      Uri.parse('$apiUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }
}
