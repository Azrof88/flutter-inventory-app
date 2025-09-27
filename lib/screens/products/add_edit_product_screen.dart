import 'package:flutter/material.dart';
import '../../data/models/dummy_product_model.dart'; // <-- USE THE SHARED MODEL



class AddEditProductScreen extends StatefulWidget {
  // If a product is passed, this screen is in 'Edit' mode.
  // If it's null, the screen is in 'Add' mode.
  final DummyProduct? product;

  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _skuController;
  late TextEditingController _quantityController;

  // This boolean determines the UI text and save logic.
  late bool _isEditing;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.product != null;

    // Pre-fill the form fields if we are editing an existing product.
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _skuController = TextEditingController(text: widget.product?.sku ?? '');
    // For simplicity, we'll just use a placeholder for quantity in the dummy UI.
    _quantityController = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _onSave() {
    // First, validate the form.
    if (_formKey.currentState!.validate()) {
      // MUBIN-TODO: Implement the save logic here.
      // You will need to create a `ProductService` (similar to AuthService).
      // Inside that service, you'll have methods like `addProduct` and `updateProduct`.
      // Your logic here will look like this:
      /*
      if (_isEditing) {
        // Call the update method from your service
        ProductService.instance.updateProduct(
          id: widget.product!.id, // You'll need an ID for the real product
          name: _nameController.text,
          sku: _skuController.text,
          quantity: int.parse(_quantityController.text),
        );
      } else {
        // Call the add method from your service
        ProductService.instance.addProduct(
          name: _nameController.text,
          sku: _skuController.text,
          quantity: int.parse(_quantityController.text),
        );
      }
      */
      
      // MEHEDI-TODO: Your task will be to replace Mubin's dummy `ProductService`
      // methods with real calls to Firestore to add or update documents in the
      // 'products' collection.

      // After the logic is done, we navigate back.
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The title dynamically changes based on the mode.
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
                validator: (value) => value!.isEmpty ? 'Please enter a product name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _skuController,
                decoration: const InputDecoration(labelText: 'SKU (Stock Keeping Unit)', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Please enter a SKU' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Initial Quantity', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a quantity';
                  if (int.tryParse(value) == null || int.parse(value) < 0) {
                    return 'Please enter a valid non-negative number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                // The button text also changes dynamically.
                child: Text(_isEditing ? 'Update Product' : 'Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

