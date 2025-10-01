import 'package:flutter/material.dart';
import '../data/models/transaction_model.dart';
import '../data/services/transaction_service.dart';

class UpdateStockDialog extends StatefulWidget {
  final String productSku;
  final String productName;
  final int currentQuantity;

  const UpdateStockDialog({
    super.key,
    required this.productSku,
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
  TransactionType _selectedType = TransactionType.addition;

  @override
  void dispose() {
    _quantityController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _onConfirm() async {
    if (_formKey.currentState!.validate()) {
      final quantity = int.parse(_quantityController.text);
      final reason = _reasonController.text;

      await TransactionService.instance.updateStock(
        productSku: widget.productSku,
        quantityChange: quantity,
        reason: reason,
        type: _selectedType,
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
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
              Column(
                children: <Widget>[
                  RadioListTile<TransactionType>(
                    title: const Text('Add Stock'),
                    value: TransactionType.addition,
                    groupValue: _selectedType,
                    onChanged: (value) => setState(() => _selectedType = value!),
                  ),
                  RadioListTile<TransactionType>(
                    title: const Text('Remove Stock'),
                    value: TransactionType.removal,
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
                  if (quantity == null || quantity <= 0) return 'Enter a positive number';
                  if (_selectedType == TransactionType.removal && quantity > widget.currentQuantity) {
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