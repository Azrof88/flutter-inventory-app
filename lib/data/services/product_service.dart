import 'data_change_notifier.dart';
import '../models/dummy_data.dart';
import '../models/dummy_product_model.dart';

// --- DESIGN PATTERN: SINGLETON ---
class ProductService {
  ProductService._internal();
  static final ProductService _instance = ProductService._internal();
  static ProductService get instance => _instance;

  final List<DummyProduct> _products = DummyData.products;

  Future<List<DummyProduct>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _products;
  }

  Future<List<DummyProduct>> getProductsByCategory(String categoryId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _products.where((product) => product.categoryId == categoryId).toList();
  }
  
  // --- NEW METHOD ADDED HERE ---
  /// Fetches all products with quantity less than or equal to 10.
  Future<List<DummyProduct>> getLowStockProducts() async {
    await Future.delayed(const Duration(milliseconds: 400));
    // MUBIN-NOTE: Filtering based on the user's requirement of quantity <= 10.
    return _products.where((p) => p.quantity <= 10).toList();
  }

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
    dataChangeNotifier.notify();
  }

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
      dataChangeNotifier.notify();
    }
  }

  Future<void> deleteProduct(String sku) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _products.removeWhere((p) => p.sku == sku);
    dataChangeNotifier.notify();
  }
}