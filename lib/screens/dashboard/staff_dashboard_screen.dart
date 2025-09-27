import 'package:flutter/material.dart';
import '../../data/models/user_model.dart'; // Import this to use the UserRole enum
import 'dashboard_screen.dart'; // Import the main layout shell


class StaffDashboardScreen extends StatelessWidget {
  const StaffDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This is the unique content for the staff user.
    final staffContent = const Center(
      child: Text(
        'Welcome, Staff!',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );

    // Wrap the content with the common layout shell.
    return DashboardScreen(
      title: 'Staff Dashboard',
      body: staffContent,
      userRole: UserRole.staff, // Pass the role to the sidebar
    );
  }
}
