import '../models/dummy_data.dart';
import '../models/dummy_product_model.dart';

// --- DESIGN PATTERN: SINGLETON ---
// This ensures we have only one instance of this service in the entire app.
class DashboardService {
  // Private constructor
  DashboardService._internal();

  // The single, static instance
  static final DashboardService _instance = DashboardService._internal();

  // Public getter to access the instance
  static DashboardService get instance => _instance;

  // This is the in-memory data store for products.
  // In a real app, this would be a stream from a database.
  final List<DummyProduct> _products = DummyData.products;

  // --- SERVICE METHODS ---

  /// Calculates the total number of unique products.
  Future<int> getTotalProductCount() async {
    // Simulate a network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _products.length;
  }

  /// Calculates the number of products with quantity below a threshold (e.g., 10).
  Future<int> getLowStockCount() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _products.where((p) => p.quantity < 10).length;
  }

  /// Provides a dummy value for the total inventory worth.
  Future<String> getTotalInventoryValue() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // MUBIN-NOTE: The real calculation for this would involve unitPrice, which is not in DummyProduct.
    // So for the dummy service, we return a hardcoded string as requested in the TODO.
    return "\$15.2k";
  }

  /// Groups products by category and counts them.
  Future<Map<String, int>> getCategoryProductCounts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final categoryCounts = <String, int>{};
    for (var product in _products) {
      // If the categoryId is already a key in the map, increment its value.
      // Otherwise, initialize it with a count of 1.
      categoryCounts[product.categoryId] = (categoryCounts[product.categoryId] ?? 0) + 1;
    }
    return categoryCounts;
  }
}