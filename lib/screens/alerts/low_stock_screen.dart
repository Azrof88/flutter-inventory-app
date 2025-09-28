import 'package:flutter/material.dart';
import '../../widgets/update_stock_dialog.dart'; // <-- 1. IMPORT THE DIALOG

// MUBIN/MEHEDI: You will replace this with the real Product model.
class _DummyLowStockProduct {
  final String name;
  final String sku;
  final int quantity;
  final int reorderLevel;

  _DummyLowStockProduct({
    required this.name,
    required this.sku,
    required this.quantity,
    required this.reorderLevel,
  });
}

class LowStockScreen extends StatelessWidget {
  const LowStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // MUBIN/MEHEDI: This dummy list will be replaced by a call to your service layer.
    final List<_DummyLowStockProduct> lowStockProducts = [
      _DummyLowStockProduct(name: 'Wireless Mouse', sku: 'WM-67890', quantity: 7, reorderLevel: 10),
      _DummyLowStockProduct(name: '4K Monitor', sku: 'MON-4K-001', quantity: 2, reorderLevel: 5),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Low Stock Alerts'),
      ),
      body: lowStockProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline_rounded, size: 80, color: Colors.green.shade300),
                  const SizedBox(height: 16),
                  const Text('All products are well-stocked!', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: lowStockProducts.length,
              itemBuilder: (context, index) {
                final product = lowStockProducts[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text('SKU: ${product.sku}', style: TextStyle(color: Colors.grey.shade600)),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  const TextSpan(text: 'Quantity: '),
                                  TextSpan(text: '${product.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16)),
                                  TextSpan(text: ' (Reorder at ${product.reorderLevel})'),
                                ],
                              ),
                            ),
                            
                            // --- 2. MAKE THIS BUTTON INTERACTIVE ---
                            ElevatedButton(
                              onPressed: () {
                                // AZROF-NOTE: This is the UI flow. We are reusing the
                                // UpdateStockDialog we've already built.
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return UpdateStockDialog(
                                      productName: product.name,
                                      currentQuantity: product.quantity,
                                    );
                                  },
                                );
                              },
                              child: const Text('Update'),
                            ),
                          ],
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

