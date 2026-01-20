import 'package:flutter/material.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/utils/api_exception';
import '../repositories/todo_repository.dart';

class TodoViewModel extends ChangeNotifier {
  final TodoRepository _repository;

  TodoViewModel(this._repository);

  List<Todo> _todos = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isOperatingTodo = false;

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isOperatingTodo => _isOperatingTodo;

  // Get todos
  Future<void> fetchTodos() async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _todos = await _repository.fetchTodos();
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add todo
  Future<void> addTodo(String title, int userId) async {
    if (_isOperatingTodo) return;
    _isOperatingTodo = true;
    notifyListeners();

    try {
      final todo = await _repository.addTodo(title, userId);
      _todos.insert(0, todo);
      notifyListeners();
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Failed to add todo';
    } finally {
      _isOperatingTodo = false;
      notifyListeners();
    }
  }

  // Updated todo
  Future<void> updateTodo(int id, bool completed) async {
    if (_isOperatingTodo) return;
    _isOperatingTodo = true;
    notifyListeners();

    try {
      final updated = await _repository.updateTodo(id, !completed);

      final index = _todos.indexWhere((e) => e.id == id);
      _todos[index] = updated;
      notifyListeners();
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Failed to update todo';
    } finally {
      _isOperatingTodo = false;
      notifyListeners();
    }
  }

  // Delete todo
  Future<void> deleteTodo(int id) async {
    if (_isOperatingTodo) return;
    _isOperatingTodo = true;
    notifyListeners();

    try {
      await _repository.deleteTodo(id);
      _todos.removeWhere((e) => e.id == id);
      notifyListeners();
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } finally {
      _isOperatingTodo = false;
      notifyListeners();
    }
  }
}
