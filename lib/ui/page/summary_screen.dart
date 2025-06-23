import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_comb/ui/widgets/summary_card.dart';
import '../../bloc/bloc/expense/expense_bloc.dart';
import '../../bloc/bloc/income/income_bloc.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  void initState() {
    super.initState();

    // Dispatch fetch summary events (you must implement these events in your blocs)
    context.read<ExpenseBloc>().add(const FetchExpensesSummary());
    context.read<IncomeBloc>().add(const FetchIncomesSummary());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Summary'),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<IncomeBloc, IncomeState>(
              builder: (context, state) {
                if (state is DisplayIncomeSummary) {
                  return SummaryCard(
                    thisMonth: state.month,
                    ytd: state.ytd,
                    lastYear: state.lastYear,
                    lastMonth: state.lastMonth,
                    last2Month: state.last2Month,
                    avgLast3Month: state.avg3Month,
                    ytdInfo:
                        'Year-To-Date (YTD) Income: Total income from Jan 1st of this year to today.',
                    lastYearInfo:
                        'Total income made in the previous calendar year.',
                    lastMonthInfo: 'Total income made in the previous month.',
                    last2MonthInfo: 'Total income made two months ago.',
                    avgLast3MonthInfo:
                        'Average of monthly income from the last 3 months (excluding current month).',
                    isExpense: false,
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            BlocBuilder<ExpenseBloc, ExpenseState>(
              builder: (context, state) {
                if (state is DisplayExpensesSummary) {
                  return SummaryCard(
                    thisMonth: state.month,
                    ytd: state.ytd,
                    lastYear: state.lastYear,
                    lastMonth: state.lastMonth,
                    last2Month: state.last2Month,
                    avgLast3Month: state.avg3Month,
                    ytdInfo:
                        'Year-To-Date (YTD) Expense: Total expense from Jan 1st of this year to today.',
                    lastYearInfo:
                        'Total expense made in the previous calendar year.',
                    lastMonthInfo: 'Total expense made in the previous month.',
                    last2MonthInfo: 'Total expense made two months ago.',
                    avgLast3MonthInfo:
                        'Average of monthly expenses from the last 3 months (excluding current month).',
                    isExpense: true,
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
