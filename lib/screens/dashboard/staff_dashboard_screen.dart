import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../widgets/metric_card.dart';
import '../../widgets/category_pie_chart.dart';
import 'dashboard_screen.dart';
import '../alerts/low_stock_screen.dart'; // <-- 1. IMPORT THE NEW SCREEN

class StaffDashboardScreen extends StatelessWidget {
  const StaffDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // A ListView is the most robust way to build this scrollable screen.
    final staffContent = Container(
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

              // MUBIN-TODO: Your task is to call the dummy methods from your new
              // `DashboardService` here to populate the `value` fields.
              // This connects the UI to your business logic layer.
              // Example: value: DashboardService.instance.getTotalProductCount().toString()
              
              // MEHEDI-TODO: Your task is to replace Mubin's dummy methods
              // in the `DashboardService` with real-time streams from Firestore.
              // This will require converting this screen into a StatefulWidget so it
              // can rebuild and display the live data from the database.

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
            ],
          ),
          const SizedBox(height: 20),
          // We give the chart a fixed height to ensure it behaves predictably.
          SizedBox(
            height: 400,
            child: CategoryPieChart(),
          ),
        ],
      ),
    );

    return DashboardScreen(
      title: 'Staff Dashboard',
      body: staffContent,
      userRole: UserRole.staff,
    );
  }
}

