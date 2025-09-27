import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import 'add_edit_product_screen.dart'; // <-- IMPORT THE NEW SCREEN
import '../../data/models/dummy_product_model.dart'; // <-- USE THE SHARED MODEL



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
              // The call to _buildActionButtons now correctly passes the specific 'product'
              // for this list item.
              trailing: _buildActionButtons(context, product),
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

