import 'dart:convert';
import 'dart:io';
import 'dart:async';
import "package:http/http.dart" as http;
import 'package:todo_app/utils/api_exception';

class ApiService {
  static const String _baseUrl = "https://dummyjson.com";

  // Fetch all todos
  Future<List<dynamic>> fetchTodos() async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/todos"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['todos'];
      }
      // You can handle more specific status codes if needed like 401, etc.
      else if (response.statusCode == 404) {
        throw ApiException(
          'Resource not found',
          type: ApiErrorType.notFound,
          statusCode: response.statusCode,
          response: response.body,
        );
      } else {
        throw ApiException(
          'Server error',
          type: ApiErrorType.server,
          statusCode: response.statusCode,
          response: response.body,
        );
      }
    } on SocketException {
      throw ApiException('No internet connection', type: ApiErrorType.network);
    } on TimeoutException {
      throw ApiException('Request timed out', type: ApiErrorType.network);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Unexpected error occurred',
        type: ApiErrorType.unknown,
      );
    }
  }

  Future<Map<String, dynamic>> createTodo(String todo, int userId) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/todos/add"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"todo": todo, "userId": userId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw ApiException(
          'Failed to create todo',
          type: ApiErrorType.server,
          statusCode: response.statusCode,
          response: response.body,
        );
      }
    } on SocketException {
      throw ApiException('No internet connection', type: ApiErrorType.network);
    } on TimeoutException {
      throw ApiException('Request timed out', type: ApiErrorType.network);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Unexpected error occurred',
        type: ApiErrorType.unknown,
      );
    }
  }

  Future<Map<String, dynamic>> updateTodo(int id, bool completed) async {
    try {
      final response = await http.put(
        Uri.parse("$_baseUrl/todos/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"completed": completed}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ApiException(
          'Failed to update todo',
          type: ApiErrorType.server,
          statusCode: response.statusCode,
          response: response.body,
        );
      }
    } on SocketException {
      throw ApiException('No internet connection', type: ApiErrorType.network);
    } on TimeoutException {
      throw ApiException('Request timed out', type: ApiErrorType.network);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Unexpected error occurred',
        type: ApiErrorType.unknown,
      );
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      final response = await http.delete(Uri.parse("$_baseUrl/todos/$id"));

      if (response.statusCode != 200) {
        throw ApiException(
          'Failed to delete todo',
          type: ApiErrorType.server,
          statusCode: response.statusCode,
          response: response.body,
        );
      }
    } on SocketException {
      throw ApiException('No internet connection', type: ApiErrorType.network);
    } on TimeoutException {
      throw ApiException('Request timed out', type: ApiErrorType.network);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Unexpected error occurred',
        type: ApiErrorType.unknown,
      );
    }
  }
}
