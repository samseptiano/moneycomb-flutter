import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_comb/bloc/bloc/expense/expense_bloc.dart';
import 'package:money_comb/ui/widgets/chart/custom_line_chart.dart';
import 'package:money_comb/ui/widgets/chart/custom_pie_chart.dart';

import '../../bloc/bloc/income/income_bloc.dart';

class SummaryChartScreen extends StatefulWidget {
  final bool isExpense;

  const SummaryChartScreen({super.key, required this.isExpense});

  @override
  State<SummaryChartScreen> createState() => _SummaryChartScreenState();
}

class _SummaryChartScreenState extends State<SummaryChartScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.isExpense) {
      context.read<ExpenseBloc>().add(const FetchExpensesSummaryChart());
    } else {
      context
          .read<IncomeBloc>()
          .add(const FetchIncomesSummaryChart()); // if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.isExpense ? 'Expense Chart' : 'Income Chart'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.read<ExpenseBloc>().add(const FetchExpensesSummary());
              context.read<IncomeBloc>().add(const FetchIncomesSummary());

              Navigator.pop(context);
            },
          )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCard(
              context,
              title: widget.isExpense ? "YTD Expense" : "YTD Income",
              child: widget.isExpense
                  ? BlocBuilder<ExpenseBloc, ExpenseState>(
                      builder: (context, state) {
                        if (state is DisplayExpensesSummaryChart) {
                          return CustomLineChart(
                            data: state.ytd,
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    )
                  : BlocBuilder<IncomeBloc, IncomeState>(
                      builder: (context, state) {
                        if (state is DisplayIncomesSummaryChart) {
                          return CustomLineChart(
                            data: state.ytd,
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
            ),
            const SizedBox(height: 16),
            _buildCard(
              context,
              title: widget.isExpense
                  ? "Monthly Expense By Category"
                  : "YTD Income By Category",
              child: widget.isExpense
                  ? BlocBuilder<ExpenseBloc, ExpenseState>(
                      builder: (context, state) {
                        if (state is DisplayExpensesSummaryChart) {
                          return CustomPieChart(
                            data: state.monthByCategory,
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    )
                  : BlocBuilder<IncomeBloc, IncomeState>(
                      builder: (context, state) {
                        if (state is DisplayIncomesSummaryChart) {
                          return CustomPieChart(
                            data: state.monthByCategory,
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required String title, required Widget child}) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
