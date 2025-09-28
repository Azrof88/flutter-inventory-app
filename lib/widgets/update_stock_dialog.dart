import 'package:flutter/material.dart';

// MUBIN/MEHEDI-NOTE: This is a temporary, local enum for UI development.
// Your first step will be to replace this with the real `TransactionType` enum
// from the `lib/data/models/transaction_model.dart` file.
enum _TransactionType { add, remove }

class UpdateStockDialog extends StatefulWidget {
  final String productName;
  final int currentQuantity;

  const UpdateStockDialog({
    super.key,
    required this.productName,
    required this.currentQuantity,
  });

  @override
  State<UpdateStockDialog> createState() => _UpdateStockDialogState();
}

class _UpdateStockDialogState extends State<UpdateStockDialog> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _reasonController = TextEditingController();
  _TransactionType _selectedType = _TransactionType.add;

  @override
  void dispose() {
    _quantityController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    // First, validate the form to ensure all data is correct.
    if (_formKey.currentState!.validate()) {
      // --- DATA HAND-OFF POINT FOR MUBIN & MEHEDI ---

      // MUBIN-TODO: This is where your logic begins. Your task is to take the data
      // from this dialog and pass it to your new `TransactionService`. You will create
      // a method in that service, for example:
      // `Future<void> updateStock({String productId, int quantity, String reason, TransactionType type})`
      // This method will update your in-memory list of products and create a new transaction record.

      // MEHEDI-TODO: Your task is to replace Mubin's dummy `updateStock` method
      // with real Firestore logic. This will involve a "batched write" or a "transaction"
      // to perform two database operations at the same time:
      // 1. Create a new document in the 'transactions' collection.
      // 2. Update the 'quantity' field of the corresponding document in the 'products' collection.
      // Using a transaction is critical here to prevent data corruption.
      
      // After the logic is done, we close the dialog.
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update Stock for ${widget.productName}'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // This vertical Column for the radio buttons is a robust layout
              // for mobile dialogs and prevents horizontal overflow errors.
              Column(
                children: <Widget>[
                  RadioListTile<_TransactionType>(
                    title: const Text('Add Stock'),
                    value: _TransactionType.add,
                    groupValue: _selectedType,
                    onChanged: (value) => setState(() => _selectedType = value!),
                  ),
                  RadioListTile<_TransactionType>(
                    title: const Text('Remove Stock'),
                    value: _TransactionType.remove,
                    groupValue: _selectedType,
                    onChanged: (value) => setState(() => _selectedType = value!),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a quantity';
                  final quantity = int.tryParse(value);
                  if (quantity == null || quantity <= 0) return 'Please enter a valid positive number';
                  if (_selectedType == _TransactionType.remove && quantity > widget.currentQuantity) {
                    return 'Cannot remove more than available stock (${widget.currentQuantity})';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason (e.g., Sale, Shipment)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please provide a reason';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _onConfirm,
          child: const Text('Confirm Update'),
        ),
      ],
    );
  }
}

