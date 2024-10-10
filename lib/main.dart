
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'todo_service.dart';
import 'todo_model.dart';
import 'auth_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const TodoApp(),
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
      ),
    );
  }
}

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  late TodoService todoService;
  late List<Todo> todos;
  String newTodo = '';
  bool showCompleted = true;

  @override
  void initState() {
    super.initState();
    // You can initialize your token here by logging in the user
    _loginAndGetTodos();
  }

  void _loginAndGetTodos() async {
    AuthService authService = AuthService();
    String? token = await authService.login();
    if (token != null) {
      todoService = TodoService(token);
      _fetchTodos();
    }
  }

  void _fetchTodos() async {
    todos = await todoService.fetchTodos();
    setState(() {});
  }

  void _addTodo() async {
    if (newTodo.isNotEmpty) {
      var uuid = const Uuid();
      final todo = Todo(
        id: uuid.v4().toString(),
        todo: newTodo,
        done: false,
        createdDate: DateTime.now(),
        updateDate: DateTime.now(),
        userId: uuid.v4().toString(),
      );
      await todoService.addTodo(todo);
      _fetchTodos();  // Reload todos
      newTodo = '';
      setState(() {});
    }
  }

  void _toggleTodoCompletion(Todo todo) async {
    todo.done = !todo.done;
    await todoService.updateTodo(todo);
    _fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'New Todo',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => newTodo = value,
            ),
          ),
          ElevatedButton(
            onPressed: _addTodo,
            child: const Text('Add'),
          ),
          SwitchListTile(
            title: const Text('Show Completed'),
            value: showCompleted,
            onChanged: (value) => setState(() => showCompleted = value),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                if (!showCompleted && todo.done) return const SizedBox.shrink();
                return ListTile(
                  title: Text(
                    todo.todo,
                    style: TextStyle(
                      decoration: todo.done
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  trailing: Checkbox(
                    value: todo.done,
                    onChanged: (_) => _toggleTodoCompletion(todo),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
