import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bloc/income/income_bloc.dart';
import '../widgets/total_card.dart';
import '../widgets/transaction_list.dart';


class IncomeTab extends StatefulWidget {
  const IncomeTab({super.key});

  @override
  State<IncomeTab> createState() => _IncomeTabState();
}

class _IncomeTabState extends State<IncomeTab> {
  @override
  void initState() {
    super.initState();
    context.read<IncomeBloc>().add(const FetchAllIncomeTotalIncomeByMonth());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IncomeBloc, IncomeState>(
      builder: (context, state) {
        if (state is DisplayIncomesWithTotal) {
          return Column(
            children: [
              TotalCard(title: "Monthly Incomes", amount: state.total, isExpense: false),
              Expanded(
                child: TransactionList(
                  items: state.incomes,
                  isExpense: false,
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
