import 'package:flutter/material.dart';
import '../../data/models/user_model.dart'; // Import this to use the UserRole enum
import 'dashboard_screen.dart'; // Import the main layout shell

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // NO Scaffold or AppBar here!
    // This is the unique content for the admin.
    final adminContent = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Welcome, Admin!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // TODO: Navigate to user management screen
            },
            child: const Text('Manage Users'),
          )
        ],
      ),
    );

    // Now, wrap the unique content with the common DashboardScreen layout.
    // This provides the AppBar and the Drawer (sidebar).
    return DashboardScreen(
      title: 'Admin Dashboard',
      body: adminContent,
      userRole: UserRole.admin, // Pass the role to the sidebar
    );
  }
}
