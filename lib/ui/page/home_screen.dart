import 'package:flutter/material.dart';
import 'package:money_comb/ui/page/transaction_history_screen.dart';

import 'add_or_update_page.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<_HomeItem> items = [
      _HomeItem(
        icon: Icons.history,
        label: 'History',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TransactionHistoryScreen(),
            ),
          );
        },
      ),
      _HomeItem(icon: Icons.bar_chart, label: 'Summary', onTap: () {}),
      _HomeItem(icon: Icons.settings, label: 'Setting', onTap: () {}),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('MoneyComb')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.black87),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => const AddOrUpdatePage()),
          );
        },
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              onTap: item.onTap,
              leading: Icon(item.icon, size: 50, color: Colors.blue),
              title: Text(
                item.label,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 30),
            ),
          );
        },
      ),
    );
  }
}

class _HomeItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  _HomeItem({required this.icon, required this.label, required this.onTap});
}
