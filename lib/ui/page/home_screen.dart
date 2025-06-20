import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_comb/ui/page/transaction_history_screen.dart';
import '../../bloc/bloc/expense/expense_bloc.dart';
import '../../bloc/bloc/income/income_bloc.dart';
import '../widgets/total_card_home.dart';
import 'add_or_update_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<_HomeItem> items = [];

  @override
  void initState() {
    super.initState();
    items.addAll([
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
    ]);

    // Dispatch events to fetch data on startup
    context
        .read<ExpenseBloc>()
        .add(const FetchAllExpensesTotalExpensesByMonth());
    // ..add(const FetchTotalExpenses());
    context.read<IncomeBloc>().add(const FetchAllIncomeTotalIncomeByMonth());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MoneyComb')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.black87),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => const AddOrUpdateScreen()),
          );
        },
      ),
      body: ListView(
  padding: const EdgeInsets.all(16),
  children: [
    // Income BLoC
    BlocBuilder<IncomeBloc, IncomeState>(
      builder: (context, state) {
        if (state is DisplayIncomesWithTotal) {
          return TotalCardHome(
            title: 'This Month Income',
            subTitle: 'YTD Income',
            amountMonth: state.total,
            amountYtd: state.total,
            isExpense: false,
          );
        } else {
          return const SizedBox(); // or a loading/skeleton widget
        }
      },
    ),

    const SizedBox(height: 10),

    // Expense BLoC
    BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        if (state is DisplayExpensesWithTotal) {
          return TotalCardHome(
            title: 'This Month Expense',
            subTitle: 'YTD Expense',
            amountMonth: state.total,
            amountYtd: state.total,
            isExpense: true,
          );
        } else {
          return const SizedBox(); // or a loading/skeleton widget
        }
      },
    ),

    const SizedBox(height: 24),

    // Menu List
    ...items.map(
      (item) => Container(
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
      ),
    ),
  ],
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
