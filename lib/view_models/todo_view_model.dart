import 'package:flutter/material.dart';
import 'package:todo_app/models/todo_model.dart';
import '../repositories/todo_repository.dart';

class TodoViewModel extends ChangeNotifier {
  TodoViewModel();

  final TodoRepository _repository = TodoRepository();

  List<Todo> _todos = [];
  bool _isLoading = false;

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;

  // Get todos
  Future<void> fetchTodos() async {
    _isLoading = true;
    notifyListeners();

    try {
      _todos = await _repository.fetchTodos();
    } catch (e) {
      debugPrint(e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add todo
  Future<void> addTodo(String title) async {
    try {
      final todo = await _repository.addTodo(title);
      debugPrint("Here is added todo: $todo");
      _todos.insert(0, todo);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Updated todo
  Future<void> updateTodo(int id, bool completed) async {
    try {
      final updated = await _repository.updateTodo(id, !completed);

      final index = _todos.indexWhere((e) => e.id == id);
      _todos[index] = updated;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Delete todo
  Future<void> deleteTodo(int id) async {
    try {
      await _repository.deleteTodo(id);
      _todos.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
