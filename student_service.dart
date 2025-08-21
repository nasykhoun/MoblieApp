import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'logged_user_model.dart';
import 'student_model.dart';

class StudentService {
  static Future<bool> register(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    final String url = "http://10.0.2.2:8000/register";
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": confirmPassword,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception("Error status code: " + response.statusCode.toString());
      }
    } catch (e) {
      throw Exception("Network error: " + e.toString());
    }
  }

  static Future<StudentModel> read(String token) async {
    final String url = "http://10.0.2.2:8000/students";
    try {
      http.Response response = await http.get(
        headers: {"Authorization": "Bearer $token"},
        Uri.parse(url),
      );
      if (response.statusCode == 200) {
        return compute(studentModelFromJson, response.body);
      } else {
        throw Exception("Error status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Network error: ${e.toString()}");
    }
  }

  static Future<bool> insert(Datum item, String token) async {
    final String url = "http://10.0.2.2:8000/students";
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(item.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception("Error status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Network error: ${e.toString()}");
    }
  }

  static Future<bool> update(Datum item, String token) async {
    final String url = "http://10.0.2.2:8000/students/${item.sid}";
    try {
      http.Response response = await http.put(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(item.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception("Error status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Network error: ${e.toString()}");
    }
  }

  static Future<bool> delete(int id, String token) async {
    final String url = "http://10.0.2.2:8000/students/$id";
    try {
      http.Response response = await http.delete(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception("Error status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Network error: ${e.toString()}");
    }
  }

  static Future<LoggedUserModel> login(String email, String password) async {
    final String url = "http://10.0.2.2:8000/login";
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "password": password}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint(response.body);
        return loggedUserModelFromJson(response.body);
      } else {
        throw Exception("Error status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Network error: ${e.toString()}");
    }
  }

  static Future<String> logout(String token) async {
    final String url = "http://10.0.2.2:8000/logout";
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint(response.body);
        return response.body;
      } else {
        throw Exception("Error status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Network error: ${e.toString()}");
    }
  }
}
