import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_comb/bloc/bloc/expense/expense_bloc.dart';
import 'package:money_comb/bloc/bloc/income/income_bloc.dart';
import 'package:money_comb/constants/constants.dart';
import 'package:money_comb/ui/page/add_or_update_screen.dart';
import 'package:money_comb/ui/widgets/detail_content.dart';

class DetailTransactionScreen extends StatefulWidget {
  final bool isExpense;

  const DetailTransactionScreen({Key? key, required this.isExpense})
      : super(key: key);

  @override
  State<DetailTransactionScreen> createState() =>
      _DetailTransactionScreenState();
}

class _DetailTransactionScreenState extends State<DetailTransactionScreen> {
  bool toggleSwitch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isExpense ? 'Expense Details' : 'Income Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (widget.isExpense) {
              context.read<ExpenseBloc>().add(FetchExpensesPaging(
                  "",
                  ExpenseOrderBy.createdAt.toString().split('.').last,
                  OrderDir.DESC.toString().split('.').last));
            } else {
              context.read<IncomeBloc>().add(FetchIncomesPaging("", IncomeOrderBy.createdAt.toString().split('.').last,
                  OrderDir.DESC.toString().split('.').last));
            }
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: widget.isExpense
            ? BlocBuilder<ExpenseBloc, ExpenseState>(
                builder: (context, state) {
                  if (state is DisplaySpecificExpense) {
                    return DetailContent(
                      item: state.expense,
                      isExpense: true,
                      onUpdate: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddOrUpdateScreen(
                                isUpdate: true, isExpense: widget.isExpense, item: state.expense),
                          ),
                        );
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              )
            : BlocBuilder<IncomeBloc, IncomeState>(
                builder: (context, state) {
                  if (state is DisplaySpecificIncome) {
                    return DetailContent(
                      item: state.income,
                      isExpense: true,
                      onUpdate: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddOrUpdateScreen(
                                isUpdate: true, item: state.income),
                          ),
                        );
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
      ),
    );
  }
}
