import 'package:flutter/foundation.dart';

class AppStrings {
  static const String appName = 'Employee Manager';

  // API Base URL with auto-detection for Android Emulator vs Web/Desktop
  static String get apiBaseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000';
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://localhost:3000';
    }
    return 'http://localhost:3000';
  }

  // Titles
  static const String dashboardTitle = 'Dashboard';
  static const String employeeListTitle = 'Employees';
  static const String employeeDetailTitle = 'Employee Details';
  static const String addEmployeeTitle = 'Add Employee';
  static const String editEmployeeTitle = 'Edit Employee';

  // Validation messages
  static const String valNameRequired = 'Full name is required';
  static const String valEmailRequired = 'Email address is required';
  static const String valEmailInvalid = 'Enter a valid email address';
  static const String valMobileRequired = 'Mobile number is required';
  static const String valMobileLength = 'Mobile number must be exactly 10 digits';
  static const String valDepartmentRequired = 'Department is required';
  static const String valDesignationRequired = 'Designation is required';

  // Labels & Messages
  static const String confirmDeleteTitle = 'Delete Employee';
  static const String confirmDeleteMessage = 'Are you sure you want to delete this employee? This action cannot be undone.';
  static const String successAdd = 'Employee added successfully!';
  static const String successUpdate = 'Employee updated successfully!';
  static const String successDelete = 'Employee deleted successfully!';
}
