import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/services/api_service.dart';

class TodoRepository {
  final ApiService _apiService = ApiService();

  // Get todos
  Future<List<Todo>> fetchTodos() async {
    final todosJson = await _apiService.fetchTodos();

    return todosJson.map<Todo>((json) => Todo.fromJson(json)).toList();
  }

  // Add todo
  Future<Todo> addTodo(String title) async {
    final todoJson = await _apiService.createTodo(title);

    return Todo.fromJson(todoJson);
  }

  // Update todo
  Future<Todo> updateTodo(int id, bool completed) async {
    final todoJson = await _apiService.updateTodo(id, completed);

    return Todo.fromJson(todoJson);
  }

  Future<void> deleteTodo(int id) async {
    await _apiService.deleteTodo(id);
  }
}
