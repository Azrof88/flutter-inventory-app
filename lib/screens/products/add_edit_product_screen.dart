import 'package:flutter/material.dart';
import '../../data/models/dummy_product_model.dart';
import '../../data/models/dummy_category_model.dart';
import '../../data/models/dummy_data.dart';

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

  @override
  void initState() {
    super.initState();
    _isEditing = widget.product != null;

    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _skuController = TextEditingController(text: widget.product?.sku ?? '');
    _quantityController = TextEditingController(text: widget.product?.quantity.toString() ?? '0');

// This logic handles pre-selecting the category in the dropdown.

    if (_isEditing) {
      try {
        _selectedCategory = DummyData.categories.firstWhere(
          (cat) => cat.id == widget.product!.categoryId
        );
      } catch (e) {
        _selectedCategory = null;
      }
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

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      // DATA HAND-OFF POINT FOR MUBIN & MEHEDI

      // MUBIN-TODO: This is where your logic begins. Your task is to take the data
      // from this form and pass it to a new `ProductService`. You will create a method
      // in that service for both adding and updating. For example:
      // if (_isEditing) {
      //   productService.updateProduct(id: ..., name: ..., sku: ..., categoryId: _selectedCategory!.id);
      // } else {
      //   productService.addProduct(name: ..., sku: ..., categoryId: _selectedCategory!.id);
      // }
      // Your service methods will update your in-memory list of products.

      // MEHEDI-TODO: Your task is to replace Mubin's dummy `addProduct` and `updateProduct`
      // methods with real Firestore logic. You will use `.add()` to create a new product
      // document or `.update()` to modify an existing one in the 'products' collection.
      // Remember to save the `_selectedCategory!.id` to the `categoryId` field in the document.
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    //  DATA HAND-OFF POINT FOR MUBIN & MEHEDI 

    // MUBIN-TODO: The list of categories for the dropdown should come from your
    // service layer. Create a method in your `ProductService` or a new `CategoryService`
    // called `getCategories()` that returns the `DummyData.categories` list.
    // This screen will then call your service method to get this data.
    
    // MEHEDI-TODO: Your task is to replace Mubin's dummy `getCategories()` method
    // with a real Firestore query that fetches all documents from the 'categories' collection.
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
                decoration: const InputDecoration(labelText: 'Product Name', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _skuController,
                decoration: const InputDecoration(labelText: 'SKU', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Please enter a SKU' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) => int.tryParse(value!) == null ? 'Please enter a valid number' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<DummyCategory>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: DummyData.categories.map((DummyCategory category) {
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
                validator: (value) => value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: Text(_isEditing ? 'Update Product' : 'Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}