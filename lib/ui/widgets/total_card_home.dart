import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TotalCardHome extends StatelessWidget {
  final String title;
  final String subTitle;
  final double amountMonth;
  final double amountYtd;
  final bool isExpense;

  const TotalCardHome({
    super.key,
    required this.title,
    required this.subTitle,
    required this.amountMonth,
    required this.amountYtd,
    required this.isExpense,
  });


  String getPercentageDifference() {
    if (amountMonth == 0) return '-';
    final percent = (amountMonth / amountYtd) * 100;
    return '(${percent.toStringAsFixed(1)}%)';
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = isExpense ? Colors.red[400] : Colors.green[400];
    final icon = isExpense ? Icons.money_off : Icons.currency_exchange;

    return Card(
      elevation: 6,
      color: cardColor,
      margin: const EdgeInsets.symmetric(horizontal:0, vertical: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Month info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  NumberFormat('#,##0').format(amountMonth),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  subTitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            // YTD row aligned right
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  NumberFormat('#,##0').format(amountYtd),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  getPercentageDifference(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
