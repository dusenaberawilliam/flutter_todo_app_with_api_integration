import 'dart:convert';
import "package:http/http.dart" as http;

class ApiService {
  static const String _baseUrl = "https://dummyjson.com";

  Future<List<dynamic>> fetchTodos() async {
    final response = await http.get(Uri.parse("$_baseUrl/todos"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["todos"];
    } else {
      throw Exception("Failed to get todos");
    }
  }

  Future<Map<String, dynamic>> createTodo(String todo) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/todos/add"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"todo": todo, "completed": false, "userId": 5}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to create todo");
    }
  }

  Future<Map<String, dynamic>> updateTodo(int id, bool completed) async {
    final response = await http.put(
      Uri.parse("$_baseUrl/todos/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"completed": completed}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to create todo");
    }
  }

  Future<void> deleteTodo(int id) async {
    final response = await http.delete(Uri.parse("$_baseUrl/todos/$id"));

    if (response.statusCode != 200) throw Exception("Failed to delete todo");
  }
}
