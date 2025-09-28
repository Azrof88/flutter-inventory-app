import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // A package for formatting dates and times

// AZROF-NOTE: This is a temporary model for UI development.
// MUBIN/MEHEDI: You will replace this with the real Transaction model from `lib/data/models/`.
class _DummyTransaction {
  final String productName;
  final int quantityChange;
  final String reason;
  final DateTime timestamp;

  _DummyTransaction({
    required this.productName,
    required this.quantityChange,
    required this.reason,
    required this.timestamp,
  });
}

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- DUMMY DATA ---
    // MUBIN-TODO: Your task will be to create a new `TransactionService` (as a Singleton).
    // This service will have a dummy method like `getTransactions()` that returns a
    // hardcoded `List<_DummyTransaction>` like the one below.
    // You will then call that method here to get the data.

    // MEHEDI-TODO: Your task will be to replace Mubin's dummy `getTransactions()`
    // method with a real-time stream from your Firestore 'transactions' collection.
    // You will use a StreamBuilder here to listen to the data and rebuild the list
    // automatically when new transactions are added. Remember to order the query
    // by timestamp descending to show the newest transactions first.
    final List<_DummyTransaction> transactions = [
      _DummyTransaction(productName: 'Laptop Pro X1', quantityChange: 50, reason: 'Shipment from Supplier A', timestamp: DateTime.now().subtract(const Duration(hours: 2))),
      _DummyTransaction(productName: 'Wireless Mouse', quantityChange: -5, reason: 'Sale #101', timestamp: DateTime.now().subtract(const Duration(hours: 3))),
      _DummyTransaction(productName: 'Laptop Pro X1 with a very, very long name that might overflow the screen if not handled properly', quantityChange: -1, reason: 'Internal Use - Marketing Department', timestamp: DateTime.now().subtract(const Duration(days: 1))),
      _DummyTransaction(productName: '4K Monitor', quantityChange: 20, reason: 'Stock Correction', timestamp: DateTime.now().subtract(const Duration(days: 2))),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
      ),
      body:
          // --- CORNER CASE 1: EMPTY STATE ---
          // This logic checks if the transaction list is empty. If it is, we show
          // a helpful message instead of a blank screen.
          transactions.isEmpty
              ? const Center(
                  child: Text(
                    'No transactions have been recorded yet.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              :
              // --- CORNER CASE 4: PERFORMANCE ---
              // A ListView.builder is used to efficiently build the list, which is
              // crucial for performance when there are many transactions.
              ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    final isStockIn = transaction.quantityChange > 0;
                    final iconData = isStockIn ? Icons.arrow_upward : Icons.arrow_downward;
                    final iconColor = isStockIn ? Colors.green : Colors.red;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        leading: CircleAvatar(
                          backgroundColor: iconColor.withOpacity(0.1),
                          child: Icon(iconData, color: iconColor),
                        ),
                        title: Text(
                          '${transaction.productName}: ${isStockIn ? '+' : ''}${transaction.quantityChange}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          // --- CORNER CASE 2: LONG TEXT ---
                          // This prevents long product names from breaking the layout.
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction.reason,
                              // This handles long reason text.
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              // Using the intl package for clean date formatting.
                              DateFormat('MMM d, yyyy - hh:mm a').format(transaction.timestamp),
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
