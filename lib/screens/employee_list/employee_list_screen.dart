import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import '../../providers/employee_provider.dart';
import '../../widgets/employee_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_widget.dart';
import '../employee_detail/employee_detail_screen.dart';
import '../add_employee/add_employee_screen.dart';
import '../edit_employee/edit_employee_screen.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Distinct lists for dropdowns
  final List<String> _departments = ['All', 'Engineering', 'HR', 'Marketing', 'Sales', 'Finance', 'Support'];
  final List<String> _statuses = ['All', 'Active', 'Inactive'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<EmployeeProvider>(context, listen: false);
      _searchController.text = provider.searchQuery;
      provider.fetchEmployees();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showDeleteConfirmation(BuildContext context, String employeeId, String employeeName) {
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
        content: Text('${AppStrings.confirmDeleteMessage}\n\nEmployee: $employeeName'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await Provider.of<EmployeeProvider>(context, listen: false)
                  .deleteEmployee(employeeId);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? AppStrings.successDelete : 'Failed to delete employee'),
                    backgroundColor: success ? AppColors.success : AppColors.error,
                  ),
                );
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
          AppStrings.employeeListTitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddEmployeeScreen()),
              );
            },
            tooltip: 'Add New Employee',
          ),
        ],
      ),
      body: Consumer<EmployeeProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // Search & Filter Panel
              Container(
                color: AppColors.surface,
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // Search bar
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by employee name...',
                        prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                                onPressed: () {
                                  _searchController.clear();
                                  provider.updateSearchQuery('');
                                },
                              )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onChanged: (val) {
                        provider.updateSearchQuery(val);
                      },
                    ),
                    const SizedBox(height: 12),
                    
                    // Filters row
                    Row(
                      children: [
                        // Department Dropdown Filter
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: provider.selectedDepartment,
                            decoration: const InputDecoration(
                              labelText: 'Department',
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            items: _departments.map((dept) {
                              return DropdownMenuItem<String>(
                                value: dept,
                                child: Text(dept, style: const TextStyle(fontSize: 14)),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                provider.updateDepartment(val);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        // Status Dropdown Filter
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: provider.selectedStatus,
                            decoration: const InputDecoration(
                              labelText: 'Status',
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            items: _statuses.map((stat) {
                              return DropdownMenuItem<String>(
                                value: stat,
                                child: Text(stat, style: const TextStyle(fontSize: 14)),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                provider.updateStatus(val);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Employees List
              Expanded(
                child: provider.isLoading && provider.employees.isEmpty
                    ? const LoadingWidget(message: 'Loading employees...')
                    : provider.employees.isEmpty
                        ? EmptyWidget(
                            title: 'No Employees Found',
                            message: 'Try modifying your search queries or department/status filters.',
                            onActionPressed: () {
                              _searchController.clear();
                              provider.clearFilters();
                            },
                            actionText: 'Reset Filters',
                          )
                        : RefreshIndicator(
                            onRefresh: () => provider.fetchEmployees(),
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(16),
                              itemCount: provider.employees.length,
                              itemBuilder: (context, index) {
                                final employee = provider.employees[index];
                                return EmployeeCard(
                                  employee: employee,
                                  onView: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EmployeeDetailScreen(employeeId: employee.id),
                                      ),
                                    );
                                  },
                                  onEdit: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditEmployeeScreen(employee: employee),
                                      ),
                                    );
                                  },
                                  onDelete: () {
                                    _showDeleteConfirmation(context, employee.id, employee.fullName);
                                  },
                                );
                              },
                            ),
                          ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEmployeeScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
