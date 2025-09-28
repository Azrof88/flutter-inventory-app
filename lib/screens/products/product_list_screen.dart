import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../data/models/dummy_product_model.dart';
import '../../data/models/dummy_category_model.dart';
import '../../data/models/dummy_data.dart'; // <-- 1. IMPORT THE SINGLE SOURCE OF TRUTH
import '../../widgets/update_stock_dialog.dart';
import 'add_edit_product_screen.dart';

class ProductListScreen extends StatelessWidget {
  final UserRole userRole;
  // This optional parameter is the key to the filtering feature.
  final DummyCategory? category;

  const ProductListScreen({
    super.key,
    required this.userRole,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    // --- DATA HAND-OFF POINT FOR MUBIN & MEHEDI ---

    // MUBIN-TODO: This filtering logic is a perfect example of what belongs in your
    // business logic layer. Your task is to create a conditional logic in your ProductService.
    // IF `category` is not null, you will call a new method: `getProductsByCategory(category!.id)`.
    // ELSE (if `category` is null), you will call `getAllProducts()`.
    // This screen will then call the appropriate service method to get its data.
    
    // MEHEDI-TODO: Your task is to replace Mubin's methods with real Firestore queries.
    // This will involve converting this screen to a StatefulWidget that uses a
    // StreamBuilder. The StreamBuilder will conditionally apply a `.where()`
    // clause to the Firestore query if a category filter is present.
    final List<DummyProduct> productsToDisplay = category == null
        ? DummyData.products
        : DummyData.products.where((product) => product.categoryId == category!.id).toList();

    return Scaffold(
      appBar: AppBar(
        // --- DYNAMIC APPBAR TITLE ---
        // The title now changes based on whether a filter has been applied.
        title: Text(category == null ? 'All Products' : 'Products in: ${category!.name}'),
      ),
      body: ListView.builder(
        itemCount: productsToDisplay.length,
        itemBuilder: (context, index) {
          final product = productsToDisplay[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('SKU: ${product.sku}'),
              leading: Chip(
                label: Text('Qty: ${product.quantity}'),
                backgroundColor: product.quantity < 5 ? Colors.red.shade100 : Colors.green.shade100,
                labelStyle: TextStyle(color: product.quantity < 5 ? Colors.red.shade900 : Colors.green.shade900),
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'update_stock') {
                    showDialog(context: context, builder: (ctx) => UpdateStockDialog(productName: product.name, currentQuantity: product.quantity));
                  } else if (value == 'edit') {
                    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => AddEditProductScreen(product: product)));
                  }
                  // MUBIN-TODO: Implement the logic for the 'delete' option here.
                  // You should show a confirmation dialog. If the user confirms,
                  // you will call a `deleteProduct(productId)` method in your ProductService.
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem(value: 'update_stock', child: ListTile(leading: Icon(Icons.layers_outlined), title: Text('Update Stock'))),
                  const PopupMenuItem(value: 'edit', child: ListTile(leading: Icon(Icons.edit), title: Text('Edit'))),
                  if (userRole == UserRole.admin) const PopupMenuDivider(),
                  if (userRole == UserRole.admin) const PopupMenuItem(value: 'delete', child: ListTile(leading: Icon(Icons.delete, color: Colors.red), title: Text('Delete', style: TextStyle(color: Colors.red)))),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // --- "SMART" NAVIGATION LOGIC ---
          // When the user taps the '+' button, we pass the current category filter
          // (which can be null) to the AddEditProductScreen. This allows the
          // form to pre-select the category automatically.
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddEditProductScreen(category: category)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

