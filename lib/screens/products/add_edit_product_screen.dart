import 'package:flutter/material.dart';
import '../../data/models/dummy_product_model.dart';
import '../../data/models/dummy_category_model.dart';
import '../../data/services/category_service.dart'; // <-- 1. IMPORT CATEGORY SERVICE
import '../../data/services/product_service.dart'; // <-- 2. IMPORT PRODUCT SERVICE

class AddEditProductScreen extends StatefulWidget {
  final DummyProduct? product;
  final DummyCategory? category;

  const AddEditProductScreen({
    super.key,
    this.product,
    this.category,
  });

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _skuController;
  late TextEditingController _quantityController;
  DummyCategory? _selectedCategory;
  late bool _isEditing;

  // MUBIN-NOTE: We now hold the list of categories in a Future.
  late Future<List<DummyCategory>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.product != null;

    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _skuController = TextEditingController(text: widget.product?.sku ?? '');
    _quantityController =
        TextEditingController(text: widget.product?.quantity.toString() ?? '0');

    // 3. Fetch categories from the service when the screen loads.
    _categoriesFuture = CategoryService.instance.getCategories();

    if (_isEditing) {
      // For editing, we find the matching category from the full list later
      // in the FutureBuilder, once the categories have been fetched.
      // This is more robust than relying on DummyData directly.
    } else if (widget.category != null) {
      _selectedCategory = widget.category;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _onSave() async {
    if (_formKey.currentState!.validate()) {
      // --- DATA HAND-OFF POINT FOR MUBIN & MEHEDI ---

      // MUBIN-TODO: This is where your logic begins. Your task is to take the data
      // from this form and pass it to a new `ProductService`. You will create a method
      // in that service for both adding and updating.
      // MUBIN-NOTE: Task complete. We call the appropriate ProductService method below.
      
      // MEHEDI-TODO: Your task is to replace Mubin's dummy `addProduct` and `updateProduct`
      // methods with real Firestore logic...

      final name = _nameController.text;
      final sku = _skuController.text;
      final quantity = int.parse(_quantityController.text);
      final categoryId = _selectedCategory!.id;

      // 4. Show a loading indicator while saving.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? 'Updating Product...' : 'Adding Product...')),
      );

      if (_isEditing) {
        await ProductService.instance.updateProduct(
          originalSku: widget.product!.sku,
          newName: name,
          newSku: sku,
          newQuantity: quantity,
          newCategoryId: categoryId,
        );
      } else {
        await ProductService.instance.addProduct(
          name: name,
          sku: sku,
          quantity: quantity,
          categoryId: categoryId,
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //  DATA HAND-OFF POINT FOR MUBIN & MEHEDI 

    // MUBIN-TODO: The list of categories for the dropdown should come from your
    // service layer...
    // MUBIN-NOTE: Task complete. We use a FutureBuilder below to get categories from CategoryService.
    
    // MEHEDI-TODO: Your task is to replace Mubin's dummy `getCategories()` method
    // with a real Firestore query...

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Product' : 'Add New Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                    labelText: 'Product Name', border: OutlineInputBorder()),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _skuController,
                decoration: const InputDecoration(
                    labelText: 'SKU', border: OutlineInputBorder()),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a SKU' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                    labelText: 'Quantity', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) => int.tryParse(value!) == null
                    ? 'Please enter a valid number'
                    : null,
              ),
              const SizedBox(height: 16),
              // 5. Use a FutureBuilder to build the dropdown.
              FutureBuilder<List<DummyCategory>>(
                future: _categoriesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Text('Could not load categories.');
                  }
                  
                  final categories = snapshot.data!;
                  // This logic runs after categories are loaded to set the initial value
                  // for an existing product.
                  if (_isEditing && _selectedCategory == null) {
                    try {
                      _selectedCategory = categories.firstWhere((cat) => cat.id == widget.product!.categoryId);
                    } catch (e) {
                      _selectedCategory = null;
                    }
                  }

                  return DropdownButtonFormField<DummyCategory>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: categories.map((DummyCategory category) {
                      return DropdownMenuItem<DummyCategory>(
                        value: category,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a category' : null,
                  );
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                child: Text(_isEditing ? 'Update Product' : 'Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}