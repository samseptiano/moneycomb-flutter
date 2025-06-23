import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TotalCard extends StatelessWidget {
  final String title;
  final double amount;
  final bool isExpense;

  const TotalCard({
    super.key,
    required this.title,
    required this.amount,
    required this.isExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: isExpense ? Colors.redAccent : Colors.green,
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        trailing: Text(
          NumberFormat('#,##0').format(amount),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
