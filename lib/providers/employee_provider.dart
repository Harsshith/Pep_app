import 'package:flutter/material.dart';
import '../models/employee_model.dart';
import '../services/api_service.dart';

class EmployeeProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Employee> _employees = [];
  Map<String, dynamic> _dashboardStats = {
    'totalEmployees': 0,
    'activeEmployees': 0,
    'inactiveEmployees': 0,
  };
  bool _isLoading = false;
  String? _errorMessage;

  // Filters state
  String _searchQuery = '';
  String _selectedDepartment = 'All';
  String _selectedStatus = 'All';

  // Getters
  List<Employee> get employees => _employees;
  Map<String, dynamic> get dashboardStats => _dashboardStats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  String get searchQuery => _searchQuery;
  String get selectedDepartment => _selectedDepartment;
  String get selectedStatus => _selectedStatus;

  // Setters with notifyListeners for instant UI update if needed
  void updateSearchQuery(String query) {
    _searchQuery = query;
    fetchEmployees();
  }

  void updateDepartment(String department) {
    _selectedDepartment = department;
    fetchEmployees();
  }

  void updateStatus(String status) {
    _selectedStatus = status;
    fetchEmployees();
  }

  // Clear filters
  void clearFilters() {
    _searchQuery = '';
    _selectedDepartment = 'All';
    _selectedStatus = 'All';
    fetchEmployees();
  }

  // Action methods
  Future<void> fetchEmployees() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _employees = await _apiService.getEmployees(
        search: _searchQuery,
        department: _selectedDepartment,
        status: _selectedStatus,
      );
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDashboard() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _dashboardStats = await _apiService.getDashboard();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addEmployee(Map<String, dynamic> employeeData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.addEmployee(employeeData);
      // Refresh local lists
      await fetchDashboard();
      await fetchEmployees();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateEmployee(String id, Map<String, dynamic> employeeData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.updateEmployee(id, employeeData);
      await fetchDashboard();
      await fetchEmployees();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteEmployee(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.deleteEmployee(id);
      await fetchDashboard();
      await fetchEmployees();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
