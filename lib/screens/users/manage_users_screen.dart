import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';

class ManageUsersScreen extends StatelessWidget {
  const ManageUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- DUMMY DATA FOR UI DEVELOPMENT ---
    // MUBIN-TODO: Your task is to create a new `UserService` (as a Singleton) or
    // add methods to the existing `AuthService`. You will implement a dummy method
    // like `Future<List<AppUser>> getUsers()` that returns this hardcoded list.
    // This screen will then call your service method to get its data.
    
    // --- FIX IS HERE: Changed 'const' to 'final' ---
    // This resolves the build error. The list is still immutable, but its
    // contents are no longer required to be compile-time constants.
    final List<AppUser> allUsers = [
      AppUser(uid: '1', email: 'admin@gmail.com', role: UserRole.admin),
      AppUser(uid: '3', email: 'staff@gmail.com', role: UserRole.staff),
      AppUser(uid: '4', email: 'staff2@gmail.com', role: UserRole.staff),
    ];

    // This is the core logic that ensures only staff users are ever displayed.
    final List<AppUser> staffUsers =
        allUsers.where((user) => user.role == UserRole.staff).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Staff Users'),
      ),
      body:
          // If the filtered list is empty, we show a helpful message.
          staffUsers.isEmpty
              ? const Center(
                  child: Text(
                    'No staff users have been added yet.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: staffUsers.length,
                  itemBuilder: (context, index) {
                    final user = staffUsers[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        leading: const Icon(Icons.account_circle,
                            size: 40, color: Colors.grey),
                        title: Text(user.email,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Chip(
                          label: Text(
                            user.role.name[0].toUpperCase() +
                                user.role.name.substring(1),
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.blueGrey,
                        ),
                        // A PopupMenuButton keeps the UI clean and prevents overflow.
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'promote') {
                              // MUBIN-TODO: Show a confirmation dialog here.
                              // If confirmed, call a UserService method: `promoteToAdmin(userId: user.uid)`.
                            } else if (value == 'delete') {
                              // MUBIN-TODO: Show a confirmation dialog here.
                              // If confirmed, call a UserService method: `deleteUser(userId: user.uid)`.
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'promote',
                              child: ListTile(
                                leading: Icon(Icons.admin_panel_settings),
                                title: Text('Promote to Admin'),
                              ),
                            ),
                            const PopupMenuDivider(),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: ListTile(
                                leading: Icon(Icons.delete, color: Colors.red),
                                title: Text('Delete User',
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}