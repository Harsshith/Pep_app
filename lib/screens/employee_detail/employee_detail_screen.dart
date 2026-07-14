import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import '../../models/employee_model.dart';
import '../../services/api_service.dart';
import '../../widgets/loading_widget.dart';
import '../edit_employee/edit_employee_screen.dart';
import '../../providers/employee_provider.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final String employeeId;

  const EmployeeDetailScreen({super.key, required this.employeeId});

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  final ApiService _apiService = ApiService();
  Employee? _employee;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEmployeeDetails();
  }

  Future<void> _loadEmployeeDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final employee = await _apiService.getEmployee(widget.employeeId);
      setState(() {
        _employee = employee;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    if (_employee == null) return;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.error),
            SizedBox(width: 8),
            Text(AppStrings.confirmDeleteTitle),
          ],
        ),
        content: Text('${AppStrings.confirmDeleteMessage}\n\nEmployee: ${_employee!.fullName}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              Navigator.pop(ctx); // Close dialog
              final success = await Provider.of<EmployeeProvider>(context, listen: false)
                  .deleteEmployee(_employee!.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? AppStrings.successDelete : 'Failed to delete employee'),
                    backgroundColor: success ? AppColors.success : AppColors.error,
                  ),
                );
                if (success) {
                  Navigator.pop(context); // Return to list screen
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.employeeDetailTitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: _employee != null
            ? [
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditEmployeeScreen(employee: _employee!),
                      ),
                    );
                    if (updated == true) {
                      _loadEmployeeDetails();
                    }
                  },
                  tooltip: 'Edit Employee',
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: AppColors.error,
                  onPressed: () => _showDeleteConfirmation(context),
                  tooltip: 'Delete Employee',
                ),
              ]
            : null,
      ),
      body: _isLoading
          ? const LoadingWidget(message: 'Fetching details...')
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 60, color: AppColors.error),
                        const SizedBox(height: 16),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _loadEmployeeDetails,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : _employee == null
                  ? const Center(child: Text('Employee details not available.'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Profile Header Card
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 36,
                                    backgroundColor: AppColors.primary,
                                    child: Text(
                                      _employee!.fullName.substring(0, 1).toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _employee!.fullName,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _employee!.designation,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        // Status badge
                                        _StatusBadge(status: _employee!.status),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Contact Details Section
                          _DetailSectionTitle(title: 'Contact Information'),
                          Card(
                            child: Column(
                              children: [
                                _DetailTile(
                                  icon: Icons.email_outlined,
                                  label: 'Email Address',
                                  value: _employee!.email,
                                ),
                                const Divider(color: AppColors.border, height: 1),
                                _DetailTile(
                                  icon: Icons.phone_android_outlined,
                                  label: 'Mobile Number',
                                  value: _employee!.mobileNumber,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Work Details Section
                          _DetailSectionTitle(title: 'Employment Information'),
                          Card(
                            child: Column(
                              children: [
                                _DetailTile(
                                  icon: Icons.business_outlined,
                                  label: 'Department',
                                  value: _employee!.department,
                                ),
                                const Divider(color: AppColors.border, height: 1),
                                _DetailTile(
                                  icon: Icons.date_range_outlined,
                                  label: 'Joining Date',
                                  value: _employee!.joiningDate,
                                ),
                                const Divider(color: AppColors.border, height: 1),
                                _DetailTile(
                                  icon: Icons.badge_outlined,
                                  label: 'Employee ID',
                                  value: _employee!.id,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isActive = status.toLowerCase() == 'active';
    final color = isActive ? AppColors.success : AppColors.error;
    final bgColor = isActive ? AppColors.successLight : AppColors.errorLight;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class _DetailSectionTitle extends StatelessWidget {
  final String title;

  const _DetailSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: AppColors.textSecondary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
