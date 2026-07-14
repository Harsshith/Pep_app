import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import '../../providers/employee_provider.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/loading_widget.dart';
import '../employee_list/employee_list_screen.dart';
import '../add_employee/add_employee_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmployeeProvider>(context, listen: false).fetchDashboard();
    });
  }

  Future<void> _refreshData() async {
    await Provider.of<EmployeeProvider>(context, listen: false).fetchDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.appName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh Dashboard',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Consumer<EmployeeProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.employees.isEmpty) {
              return const LoadingWidget(message: 'Loading dashboard statistics...');
            }

            if (provider.errorMessage != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60, color: AppColors.error),
                      const SizedBox(height: 16),
                      Text(
                        provider.errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _refreshData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final stats = provider.dashboardStats;
            final total = stats['totalEmployees']?.toString() ?? '0';
            final active = stats['activeEmployees']?.toString() ?? '0';
            final inactive = stats['inactiveEmployees']?.toString() ?? '0';

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Here is a quick overview of your workforce.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Dashboard Stats Cards Grid/Column
                  DashboardCard(
                    title: 'Total Employees',
                    count: total,
                    icon: Icons.people,
                    color: AppColors.primary,
                    backgroundColor: AppColors.primaryLight,
                  ),
                  const SizedBox(height: 12),
                  DashboardCard(
                    title: 'Active Employees',
                    count: active,
                    icon: Icons.check_circle,
                    color: AppColors.success,
                    backgroundColor: AppColors.successLight,
                  ),
                  const SizedBox(height: 12),
                  DashboardCard(
                    title: 'Inactive Employees',
                    count: inactive,
                    icon: Icons.cancel,
                    color: AppColors.error,
                    backgroundColor: AppColors.errorLight,
                  ),
                  
                  const SizedBox(height: 32),
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Quick Actions Buttons Row
                  Row(
                    children: [
                      Expanded(
                        child: _ActionCard(
                          title: 'View All Employees',
                          subtitle: 'Manage and search',
                          icon: Icons.list_alt,
                          color: AppColors.primary,
                          onTap: () {
                            // Fetch latest employees before navigating
                            provider.clearFilters();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const EmployeeListScreen()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionCard(
                          title: 'Add Employee',
                          subtitle: 'Register new personnel',
                          icon: Icons.person_add_outlined,
                          color: AppColors.success,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AddEmployeeScreen()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
