import 'package:flutter_test/flutter_test.dart';
import 'package:employee_manager/main.dart';
import 'package:employee_manager/screens/dashboard/dashboard_screen.dart';

void main() {
  testWidgets('Dashboard initial load smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title shows.
    expect(find.text('Employee Manager'), findsOneWidget);
    
    // Verify that the loading widget is initially visible or main parts are mounted
    expect(find.byType(DashboardScreen), findsOneWidget);
  });
}
