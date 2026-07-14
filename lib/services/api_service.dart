import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/strings.dart';
import '../models/employee_model.dart';

class ApiService {
  final String baseUrl = AppStrings.apiBaseUrl;

  // Helper for status code checks
  void _checkResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      String errorMessage = 'Request failed with status ${response.statusCode}';
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body.containsKey('message')) {
          errorMessage = body['message'];
        }
      } catch (_) {}
      throw Exception(errorMessage);
    }
  }

  Future<List<Employee>> getEmployees({
    String? search,
    String? department,
    String? status,
  }) async {
    // Construct query parameters
    final queryParams = <String, String>{};
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (department != null && department.isNotEmpty && department != 'All') {
      queryParams['department'] = department;
    }
    if (status != null && status.isNotEmpty && status != 'All') {
      queryParams['status'] = status;
    }

    final uri = Uri.parse('$baseUrl/employees').replace(queryParameters: queryParams);
    
    try {
      final response = await http.get(uri);
      _checkResponse(response);
      
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Employee.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch employees: ${e.toString()}');
    }
  }

  Future<Employee> getEmployee(String id) async {
    final uri = Uri.parse('$baseUrl/employees/$id');
    try {
      final response = await http.get(uri);
      _checkResponse(response);

      final Map<String, dynamic> data = jsonDecode(response.body);
      return Employee.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch employee details: ${e.toString()}');
    }
  }

  Future<Employee> addEmployee(Map<String, dynamic> employeeData) async {
    final uri = Uri.parse('$baseUrl/employees');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(employeeData),
      );
      _checkResponse(response);

      final Map<String, dynamic> data = jsonDecode(response.body);
      return Employee.fromJson(data);
    } catch (e) {
      throw Exception('Failed to add employee: ${e.toString()}');
    }
  }

  Future<Employee> updateEmployee(String id, Map<String, dynamic> employeeData) async {
    final uri = Uri.parse('$baseUrl/employees/$id');
    try {
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(employeeData),
      );
      _checkResponse(response);

      final Map<String, dynamic> data = jsonDecode(response.body);
      return Employee.fromJson(data);
    } catch (e) {
      throw Exception('Failed to update employee: ${e.toString()}');
    }
  }

  Future<void> deleteEmployee(String id) async {
    final uri = Uri.parse('$baseUrl/employees/$id');
    try {
      final response = await http.delete(uri);
      _checkResponse(response);
    } catch (e) {
      throw Exception('Failed to delete employee: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getDashboard() async {
    final uri = Uri.parse('$baseUrl/dashboard');
    try {
      final response = await http.get(uri);
      _checkResponse(response);

      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to fetch dashboard data: ${e.toString()}');
    }
  }
}
