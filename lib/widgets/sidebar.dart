import 'package:flutter/material.dart';
import '../data/models/user_model.dart';
import '../data/services/auth_service.dart'; // Import AuthService
import '../screens/auth/login_screen.dart'; // Import LoginScreen for navigation
import '../screens/products/product_list_screen.dart'; // <-- IMPORT THE NEW SCREEN
import '../screens/history/transaction_history_screen.dart'; // <-- IMPORT THE NEW SCREEN
import '../screens/users/manage_users_screen.dart'; // <-- 1. IMPORT THE NEW SCREEN

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
              // AZROF-NOTE: We may want to prevent re-navigating if already on the dashboard.
              Navigator.pop(context);
            },
          ),
        
          // Replace your old "Products" ListTile with this one.
          ListTile(
            leading: const Icon(Icons.inventory_2),
            title: const Text('Products'),
            onTap: () {
              // First, close the drawer so it's not open in the background.
              Navigator.pop(context);
              // Then, navigate to the new ProductListScreen.
              Navigator.of(context).push(
                MaterialPageRoute(
                  // 2. We pass the current user's role to the screen so it knows
                  // which UI variations to display (e.g., show/hide delete button).
                  builder: (context) => ProductListScreen(userRole: userRole),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Transaction History'),
            onTap: () {
              // First, close the drawer.
              Navigator.pop(context);
              // Then, navigate to the new TransactionHistoryScreen.
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const TransactionHistoryScreen()),
              );
            },
          ),
          const Divider(),
          // --- UPDATE THIS NAVIGATION ---
          if (userRole == UserRole.admin)
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Manage Users'),
              onTap: () {
                // First, close the drawer.
                Navigator.pop(context);
                // Then, navigate to the new ManageUsersScreen.
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const ManageUsersScreen()),
                );
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

