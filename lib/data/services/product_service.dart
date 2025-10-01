import 'data_change_notifier.dart';
import '../models/dummy_data.dart';
import '../models/dummy_product_model.dart';

// --- DESIGN PATTERN: SINGLETON ---
class ProductService {
  // Private constructor
  ProductService._internal();

  // The single, static instance
  static final ProductService _instance = ProductService._internal();

  // Public getter to access the instance
  static ProductService get instance => _instance;

  final List<DummyProduct> _products = DummyData.products;

  /// Fetches a list of all products.
  Future<List<DummyProduct>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _products;
  }

  /// Fetches all products belonging to a specific category.
  Future<List<DummyProduct>> getProductsByCategory(String categoryId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _products.where((product) => product.categoryId == categoryId).toList();
  }
  
  /// Fetches all products that are low on stock.
  Future<List<DummyProduct>> getLowStockProducts() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _products.where((p) => p.quantity < 10).toList();
  }

  /// Adds a new product to the in-memory list.
  Future<void> addProduct({
    required String name,
    required String sku,
    required int quantity,
    required String categoryId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _products.add(
      DummyProduct(
        name: name,
        sku: sku,
        quantity: quantity,
        categoryId: categoryId,
      ),
    );
    dataChangeNotifier.notify(); // Notify listeners of the change
  }

  /// Updates an existing product in the list, identified by its SKU.
  Future<void> updateProduct({
    required String originalSku,
    required String newName,
    required String newSku,
    required int newQuantity,
    required String newCategoryId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _products.indexWhere((p) => p.sku == originalSku);
    if (index != -1) {
      _products[index] = DummyProduct(
        name: newName,
        sku: newSku,
        quantity: newQuantity,
        categoryId: newCategoryId,
      );
      dataChangeNotifier.notify(); // Notify listeners of the change
    }
  }

  /// Deletes a product from the list, identified by its SKU.
  Future<void> deleteProduct(String sku) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _products.removeWhere((p) => p.sku == sku);
    dataChangeNotifier.notify(); // Notify listeners of the change
  }
}