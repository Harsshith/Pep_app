import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import '../../models/employee_model.dart';
import '../../providers/employee_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class EditEmployeeScreen extends StatefulWidget {
  final Employee employee;

  const EditEmployeeScreen({super.key, required this.employee});

  @override
  State<EditEmployeeScreen> createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String? _selectedDepartment;
  String _selectedStatus = 'Active';
  DateTime _selectedDate = DateTime.now();

  final List<String> _departments = ['Engineering', 'HR', 'Marketing', 'Sales', 'Finance', 'Support'];
  final List<String> _statuses = ['Active', 'Inactive'];

  @override
  void initState() {
    super.initState();
    // Prefill fields
    _nameController.text = widget.employee.fullName;
    _emailController.text = widget.employee.email;
    _mobileController.text = widget.employee.mobileNumber;
    _designationController.text = widget.employee.designation;
    _dateController.text = widget.employee.joiningDate;
    
    _selectedDepartment = widget.employee.department;
    _selectedStatus = widget.employee.status;
    
    try {
      _selectedDate = DateTime.parse(widget.employee.joiningDate);
    } catch (_) {
      _selectedDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _designationController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDepartment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.valDepartmentRequired),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final provider = Provider.of<EmployeeProvider>(context, listen: false);
    
    final employeeData = {
      'fullName': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'mobileNumber': _mobileController.text.trim(),
      'department': _selectedDepartment,
      'designation': _designationController.text.trim(),
      'joiningDate': _dateController.text,
      'status': _selectedStatus,
    };

    final success = await provider.updateEmployee(widget.employee.id, employeeData);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? AppStrings.successUpdate : (provider.errorMessage ?? 'Failed to update employee')),
          backgroundColor: success ? AppColors.success : AppColors.error,
        ),
      );
      if (success) {
        Navigator.pop(context, true); // Return true to signal that list needs refreshing
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.editEmployeeTitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<EmployeeProvider>(
        builder: (context, provider, child) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Modify the employee details below.',
                      style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 24),
                    
                    // Full Name
                    CustomTextField(
                      labelText: 'Full Name',
                      hintText: 'Enter full name',
                      controller: _nameController,
                      prefixIcon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppStrings.valNameRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email Address
                    CustomTextField(
                      labelText: 'Email Address',
                      hintText: 'name@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppStrings.valEmailRequired;
                        }
                        final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                        if (!regex.hasMatch(value.trim())) {
                          return AppStrings.valEmailInvalid;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Mobile Number
                    CustomTextField(
                      labelText: 'Mobile Number',
                      hintText: '10-digit number',
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icons.phone_android_outlined,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppStrings.valMobileRequired;
                        }
                        final regex = RegExp(r'^\d{10}$');
                        if (!regex.hasMatch(value.trim())) {
                          return AppStrings.valMobileLength;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Department Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedDepartment,
                      decoration: const InputDecoration(
                        labelText: 'Department',
                        prefixIcon: Icon(Icons.business_outlined, color: AppColors.textSecondary, size: 22),
                      ),
                      hint: const Text('Select Department'),
                      items: _departments.map((dept) {
                        return DropdownMenuItem<String>(
                          value: dept,
                          child: Text(dept),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null) {
                          return AppStrings.valDepartmentRequired;
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _selectedDepartment = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Designation
                    CustomTextField(
                      labelText: 'Designation',
                      hintText: 'e.g. Senior Software Engineer',
                      controller: _designationController,
                      prefixIcon: Icons.badge_outlined,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppStrings.valDesignationRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Joining Date (Date Picker)
                    CustomTextField(
                      labelText: 'Joining Date',
                      controller: _dateController,
                      readOnly: true,
                      prefixIcon: Icons.date_range_outlined,
                      onTap: () => _selectDate(context),
                      suffixIcon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),

                    // Status Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        prefixIcon: Icon(Icons.info_outline, color: AppColors.textSecondary, size: 22),
                      ),
                      items: _statuses.map((status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedStatus = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    CustomButton(
                      text: 'Save Changes',
                      isLoading: provider.isLoading,
                      onPressed: _submitForm,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
