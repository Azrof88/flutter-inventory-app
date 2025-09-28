import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import 'add_edit_product_screen.dart'; // <-- IMPORT THE NEW SCREEN
import '../../data/models/dummy_product_model.dart'; // <-- USE THE SHARED MODEL
import '../../widgets/update_stock_dialog.dart'; // <-- 1. IMPORT THE NEW DIALOG



class ProductListScreen extends StatelessWidget {
  final UserRole userRole;

  const ProductListScreen({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    // --- DUMMY DATA ---
    // MEHEDI-TODO: This hardcoded list will be replaced by a real-time stream
    // from your Firestore 'products' collection. You'll use a StreamBuilder here.
    final List<DummyProduct> products = [
      DummyProduct(name: 'Laptop Pro X1', sku: 'LP-12345', quantity: 15),
      DummyProduct(name: 'Wireless Mouse', sku: 'WM-67890', quantity: 7),
      DummyProduct(name: 'Mechanical Keyboard', sku: 'MK-10112', quantity: 23),
      DummyProduct(name: '4K Monitor', sku: 'MON-4K-001', quantity: 2),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        // The AppBar is styled consistently with the rest of the app
      ),
      body: ListView.builder(
       itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('SKU: ${product.sku}'),
              leading: Chip(
                label: Text('Qty: ${product.quantity}'),
                backgroundColor: product.quantity < 5 ? Colors.red.shade100 : Colors.green.shade100,
                labelStyle: TextStyle(color: product.quantity < 5 ? Colors.red.shade900 : Colors.green.shade900),
              ),
              // --- THE DEFINITIVE FIX: Use a PopupMenuButton ---
              // This replaces the Row of icons with a single, clean "more options" button.
              // This guarantees the layout will never overflow, regardless of how many actions we add.
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  // This is where we handle the user's selection from the menu.
                  if (value == 'update_stock') {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return UpdateStockDialog(
                          productName: product.name,
                          currentQuantity: product.quantity,
                        );
                      },
                    );
                  } else if (value == 'edit') {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddEditProductScreen(product: product)));
                  } else if (value == 'delete') {
                    // MUBIN-TODO: Implement the confirmation dialog logic here.
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  // These are the menu items that are visible to ALL roles.
                  const PopupMenuItem<String>(
                    value: 'update_stock',
                    child: ListTile(leading: Icon(Icons.layers_outlined), title: Text('Update Stock')),
                  ),
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: ListTile(leading: Icon(Icons.edit), title: Text('Edit')),
                  ),
                  // This is the ADMIN-ONLY menu item.
                  if (userRole == UserRole.admin)
                    const PopupMenuDivider(), // A visual separator
                  if (userRole == UserRole.admin)
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: ListTile(leading: Icon(Icons.delete, color: Colors.red), title: Text('Delete', style: TextStyle(color: Colors.red))),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddEditProductScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // This private method dynamically builds the action buttons.
  // This is a clean way to separate the UI logic.
  Widget _buildActionButtons(BuildContext context, DummyProduct product) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [

        // New button to open the stock update dialog
        IconButton(
          icon: const Icon(Icons.layers_outlined, color: Colors.grey),
          tooltip: 'Update Stock',
          onPressed: () {
            // This is the function that shows our new dialog.
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                // We pass the product's name and current quantity to the dialog
                // so it can display them and use them for validation.
                return UpdateStockDialog(
                  productName: product.name,
                  currentQuantity: product.quantity,
                );
              },
            );
          },
        ),
        // --- UI VARIATION (Edit Button) ---
        // This button is visible to all roles.
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blueAccent),
          tooltip: 'Edit Product',
          onPressed: () {
            // Navigate to the screen in 'Edit' mode, passing the product data.
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddEditProductScreen(product: product),
              ),
            );
          },
        ),

        // --- ROLE-BASED UI LOGIC (Subtask 1.2.2) ---
        // This is the core of this feature. The widget is only built
        // and added to the Row if the user is an admin.
        if (userRole == UserRole.admin)
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            tooltip: 'Delete Product',
            onPressed: () {
              // MUBIN-TODO: Implement the confirmation dialog logic here.
              // When this is pressed, you should show a dialog asking "Are you sure?".
              // If the user confirms, you will then call a method in the service
              // to delete the product.
            },
          ),
      ],
    );
  }
}

