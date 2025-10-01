import '../models/dummy_category_model.dart';
import '../models/dummy_data.dart';

// --- DESIGN PATTERN: SINGLETON ---
class CategoryService {
  // Private constructor
  CategoryService._internal();

  // The single, static instance
  static final CategoryService _instance = CategoryService._internal();

  // Public getter to access the instance
  static CategoryService get instance => _instance;

  /// Fetches the list of all available categories.
  Future<List<DummyCategory>> getCategories() async {
    // Simulate a network delay
    await Future.delayed(const Duration(milliseconds: 200));
    return DummyData.categories;
  }
}