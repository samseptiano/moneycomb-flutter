import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_comb/ui/widgets/total_card.dart';

import '../../bloc/bloc/expense/expense_bloc.dart';
import '../widgets/transaction_list.dart';

class ExpenseTab extends StatefulWidget {
  const ExpenseTab({super.key});

  @override
  State<ExpenseTab> createState() => _ExpenseTabState();
}

class _ExpenseTabState extends State<ExpenseTab> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(const FetchAllExpensesTotalExpensesByMonth());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        if (state is DisplayExpensesWithTotal) {
          return Column(
            children: [
              TotalCard(title: "Monthly Expenses", amount: state.total, isExpense: true),
              Expanded(
                child: TransactionList(
                  items: state.expenses,
                  isExpense: true,
                ),
              ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
