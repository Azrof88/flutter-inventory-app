import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../widgets/metric_card.dart';
import '../../widgets/category_pie_chart.dart';
import 'dashboard_screen.dart';
import '../alerts/low_stock_screen.dart'; // <-- 1. IMPORT THE NEW SCREEN

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // A ListView is the most robust way to build this scrollable screen.
    final adminContent = Container(
      color: Colors.grey.shade100,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            alignment: WrapAlignment.center,
            children: [
              // --- DATA HAND-OFF POINT FOR MUBIN & MEHEDI ---
              
              // MUBIN-TODO: Your task is to create a new service file: `lib/data/services/dashboard_service.dart`.
              // This service will be a Singleton and will contain dummy methods that return hardcoded data for now.
              // For example:
              //   Future<int> getTotalProductCount() async { return 124; }
              //   Future<int> getLowStockCount() async { return 8; }
              //   Future<String> getTotalInventoryValue() async { return "\$15.2k"; }
              // You will then call these methods to populate the `value` fields in the MetricCard widgets below.
              
              // MEHEDI-TODO: Your task is to replace Mubin's dummy methods in the `DashboardService`.
              // You will implement real-time listeners to Firestore. For example, `getTotalProductCount`
              // will listen to the `.snapshots()` of the 'products' collection and return its size.
              // This will require converting this screen into a StatefulWidget that can rebuild when the data from your streams changes.

              MetricCard(title: 'Total Products', value: '124', icon: Icons.inventory_2_outlined, iconColor: Colors.deepPurple),
              // --- 2. MAKE THIS CARD INTERACTIVE ---
              // The GestureDetector widget makes its child (the MetricCard) tappable.
              GestureDetector(
                onTap: () {
                  // This navigates the user to the detailed low stock screen.
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LowStockScreen()),
                  );
                },
                child: const MetricCard(
                  title: 'Low on Stock',
                  value: '8',
                  icon: Icons.warning_amber_rounded,
                  iconColor: Colors.orange,
                ),
              ),
              MetricCard(title: 'Inventory Value', value: '\$15.2k', icon: Icons.attach_money_rounded, iconColor: Colors.green),
            ],
          ),
          const SizedBox(height: 20),
          // We give the chart a fixed height to ensure it behaves predictably.
          SizedBox(
            height: 400,
            child: CategoryPieChart(userRole: UserRole.admin),

          ),
        ],
      ),
    );

    return DashboardScreen(
      title: 'Admin Dashboard',
      body: adminContent,
      userRole: UserRole.admin,
    );
  }
}

