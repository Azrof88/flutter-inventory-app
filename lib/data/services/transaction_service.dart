import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import '../models/dummy_data.dart';
import '../models/transaction_model.dart';
import '../models/dummy_product_model.dart';
import 'data_change_notifier.dart';

class TransactionService {
  TransactionService._internal();
  static final TransactionService _instance = TransactionService._internal();
  static TransactionService get instance => _instance;

  final List<Transaction> _transactions = [];

  Future<List<Transaction>> getTransactions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _transactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return _transactions;
  }

  Future<void> updateStock({
    required String productSku,
    required int quantityChange,
    required String reason,
    required TransactionType type,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final productIndex = DummyData.products.indexWhere((p) => p.sku == productSku);
    if (productIndex == -1) {
      throw Exception('Product with SKU $productSku not found.');
    }
    final product = DummyData.products[productIndex];

    final newQuantity = type == TransactionType.addition
        ? product.quantity + quantityChange
        : product.quantity - quantityChange;

    final updatedProduct = DummyProduct(
      name: product.name,
      sku: product.sku,
      quantity: newQuantity,
      categoryId: product.categoryId,
    );
    DummyData.products[productIndex] = updatedProduct;

    final newTransaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productId: product.sku,
      productName: product.name,
      changeInQuantity: type == TransactionType.addition ? quantityChange : -quantityChange,
      type: type,
      reason: reason,
      userId: 'dummy_user_id',
      timestamp: Timestamp.now(),
    );

    _transactions.add(newTransaction);
    dataChangeNotifier.notify(); // Notify listeners of the change
  }
}