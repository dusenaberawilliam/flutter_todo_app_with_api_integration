import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/services/api_service.dart';

class TodoRepository {
  final ApiService _apiService;

  TodoRepository(this._apiService);

  // Get todos
  Future<List<Todo>> fetchTodos() async {
    try {
      final todosJson = await _apiService.fetchTodos();
      final todos = todosJson.map<Todo>((json) => Todo.fromJson(json)).toList();
      return todos;
    } catch (e) {
      rethrow;
    }
  }

  // Add todo
  Future<Todo> addTodo(String title, int userId) async {
    try {
      final todoJson = await _apiService.createTodo(title, userId);
      return Todo.fromJson(todoJson);
    } catch (e) {
      rethrow;
    }
  }

  // Update todo
  Future<Todo> updateTodo(int id, bool completed) async {
    try {
      final todoJson = await _apiService.updateTodo(id, completed);
      return Todo.fromJson(todoJson);
    } catch (e) {
      rethrow;
    }
  }

  // Delete todo
  Future<void> deleteTodo(int id) async {
    try {
      await _apiService.deleteTodo(id);
    } catch (e) {
      rethrow;
    }
  }
}
