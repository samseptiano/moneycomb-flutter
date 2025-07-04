import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bloc/expense/expense_bloc.dart';
import '../../bloc/bloc/income/income_bloc.dart';
import '../../constants/constants.dart';
import '../tabs/expense_tab.dart';
import '../tabs/income_tab.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Dispatch events to fetch data on startup
    context.read<ExpenseBloc>().add(FetchExpensesPaging(
        "",
        ExpenseOrderBy.createdAt.toString().split('.').last,
        OrderDir.DESC.toString().split('.').last));
    // ..add(const FetchTotalExpenses());
    context.read<IncomeBloc>().add(FetchIncomesPaging("", IncomeOrderBy.createdAt.toString().split('.').last,
                  OrderDir.DESC.toString().split('.').last));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('History'),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Expenses'),
              Tab(text: 'Incomes'),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context
                  .read<ExpenseBloc>()
                  .add(const FetchAllExpensesTotalExpensesByMonthAndYear());
              context
                  .read<IncomeBloc>()
                  .add(const FetchAllIncomeTotalIncomeByMonthAndYear());

              Navigator.pop(context);
            },
          )),
      body: TabBarView(
        controller: _tabController,
        children: const [
          // Expense tab
          ExpenseTab(),
          // Income tab
          IncomeTab(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
