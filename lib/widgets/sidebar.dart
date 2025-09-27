import 'package:flutter/material.dart';
import '../data/models/user_model.dart';
import '../data/services/auth_service.dart'; // Import AuthService
import '../screens/auth/login_screen.dart'; // Import LoginScreen for navigation

class AppSidebar extends StatelessWidget {
  final UserRole userRole;

  const AppSidebar({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              userRole == UserRole.admin ? 'Admin User' : 'Staff User',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              userRole == UserRole.admin ? 'admin@app.com' : 'staff@app.com',
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.deepPurple),
            ),
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory_2),
            title: const Text('Products'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          if (userRole == UserRole.admin)
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Manage Users'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          // --- UPDATED: LOGOUT BUTTON LOGIC ---
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              // AZROF-NOTE: This is the implementation for logging the user out.
              // MUBIN-NOTE: This shows how the UI calls the service layer to perform an action.
              await AuthService.instance.logout();
              
              if (context.mounted) {
                // Navigate back to the login screen and remove all previous routes.
                // This is important so the user can't press the back button to get
                // back into the dashboard after logging out.
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false, // This predicate removes all routes.
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

