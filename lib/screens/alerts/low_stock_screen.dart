import 'package:flutter/material.dart';
import '../../data/models/dummy_product_model.dart';
import '../../data/services/product_service.dart';
import '../../widgets/update_stock_dialog.dart';

class LowStockScreen extends StatefulWidget {
  const LowStockScreen({super.key});

  @override
  State<LowStockScreen> createState() => _LowStockScreenState();
}

class _LowStockScreenState extends State<LowStockScreen> {
  late Future<List<DummyProduct>> _lowStockFuture;

  @override
  void initState() {
    super.initState();
    _fetchLowStockProducts();
  }

  void _fetchLowStockProducts() {
    setState(() {
      _lowStockFuture = ProductService.instance.getLowStockProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Low Stock Alerts'),
      ),
      body: FutureBuilder<List<DummyProduct>>(
        future: _lowStockFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline_rounded, size: 80, color: Colors.green.shade300),
                  const SizedBox(height: 16),
                  const Text('All products are well-stocked!', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            );
          }

          final lowStockProducts = snapshot.data!;
          return ListView.builder(
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
                                const TextSpan(text: ' (Low)'),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  // THIS IS THE FIX: Pass the productSku to the dialog.
                                  return UpdateStockDialog(
                                    productSku: product.sku,
                                    productName: product.name,
                                    currentQuantity: product.quantity,
                                  );
                                },
                              ).then((_) => _fetchLowStockProducts()); // Refresh list on close
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
          );
        },
      ),
    );
  }
}