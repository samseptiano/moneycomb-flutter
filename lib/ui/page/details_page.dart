import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_comb/bloc/bloc/expense/expense_bloc.dart';
import 'package:money_comb/bloc/bloc/income/income_bloc.dart';
import 'package:money_comb/constants/constants.dart';
import 'package:money_comb/constants/expenseCategory.dart';
import 'package:money_comb/models/expense.dart';
import 'package:money_comb/models/income.dart';
import 'package:money_comb/ui/page/add_or_update_page.dart';
import 'package:money_comb/ui/widgets/detail_content.dart';
import 'package:money_comb/util/stringUtil.dart';
import '../widgets/custom_text.dart';

class DetailsPage extends StatefulWidget {
  final bool isExpense;

  const DetailsPage({Key? key, required this.isExpense}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final TextEditingController _newTitle = TextEditingController();
  final TextEditingController _newDescription = TextEditingController();
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
              context
                  .read<ExpenseBloc>()
                  .add(const FetchAllExpensesTotalExpensesByMonth());
            } else {
              context
                  .read<IncomeBloc>()
                  .add(const FetchAllIncomeTotalIncomeByMonth());
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
                            builder: (_) => AddOrUpdatePage(
                                isUpdate: true, item: state.expense),
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
                            builder: (_) => AddOrUpdatePage(
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
