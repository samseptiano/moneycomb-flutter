import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_comb/ui/page/about_screen.dart';
import 'package:money_comb/ui/page/transaction_history_screen.dart';
import '../../bloc/bloc/expense/expense_bloc.dart';
import '../../bloc/bloc/income/income_bloc.dart';
import '../widgets/total_card_home.dart';
import 'add_or_update_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final List<_SettingItem> items = [];

  @override
  void initState() {
    super.initState();
    items.addAll([
      _SettingItem(
        icon: Icons.info,
        label: 'About App',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => const AboutScreen()),
          );
        },
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setting')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Menu List
          ...items.map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                onTap: item.onTap,
                leading: Icon(item.icon, size: 35, color: Colors.blue),
                title: Text(
                  item.label,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  _SettingItem({required this.icon, required this.label, required this.onTap});
}
