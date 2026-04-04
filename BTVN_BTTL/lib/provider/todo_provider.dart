import 'package:flutter/material.dart';
import '../database/todo_db_helper.dart';
import '../model/todo.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  Future<void> loadTodos() async {
    _todos = await TodoDatabaseHelper().getTodos();
    notifyListeners();
  }

  Future<void> addTodo(Todo todo) async {
    await TodoDatabaseHelper().insertTodo(todo);
    await loadTodos();
  }

  Future<void> deleteTodo(int id) async {
    await TodoDatabaseHelper().deleteTodo(id);
    await loadTodos();
  }

  Future<void> toggleDone(Todo todo) async {
    todo.isDone = !todo.isDone;
    await TodoDatabaseHelper().updateTodo(todo);
    await loadTodos();
  }
}