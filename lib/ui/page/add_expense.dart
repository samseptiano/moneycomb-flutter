import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_comb/bloc/bloc/expense/expense_bloc.dart';
import 'package:money_comb/bloc/bloc/income/income_bloc.dart';
import 'package:money_comb/constants/datatype.dart';
import 'package:money_comb/constants/expenseCategory.dart';
import 'package:money_comb/constants/IncomeCategory.dart';
import 'package:money_comb/util/stringUtil.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _nominal = TextEditingController();

  DataType? _selectedDataType;

  ExpenseCategory? _selectedExpenseCategory = ExpenseCategory.others;
  IncomeCategory? _selectedIncomeCategory = IncomeCategory.others;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Expense/Income'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Title",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _title,
                    decoration: InputDecoration(
                      hintText: "Enter title",
                      prefixIcon: const Icon(Icons.title),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _description,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Enter description",
                      prefixIcon: const Icon(Icons.description),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Nominal",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nominal,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter nominal",
                      prefixIcon: const Icon(Icons.currency_exchange),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text('Expense'),
                          leading: Radio<DataType>(
                            value: DataType.Expense,
                            groupValue: _selectedDataType,
                            onChanged: (DataType? value) {
                              setState(() {
                                _selectedDataType = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text('Income'),
                          leading: Radio<DataType>(
                            value: DataType.Income,
                            groupValue: _selectedDataType,
                            onChanged: (DataType? value) {
                              setState(() {
                                _selectedDataType = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_selectedDataType == DataType.Expense) ...[
                    const SizedBox(height: 16),
                    const Text(
                      "Expense Category",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<ExpenseCategory>(
                      value: _selectedExpenseCategory,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      items: ExpenseCategory.values
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(StringUtil.formatCamelCase(e.name)),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedExpenseCategory = value;
                        });
                      },
                    ),
                  ] else if (_selectedDataType == DataType.Income) ...[
                    const SizedBox(height: 16),
                    const Text(
                      "Income Category",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<IncomeCategory>(
                      value: _selectedIncomeCategory,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      items: IncomeCategory.values
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(StringUtil.formatCamelCase(e.name)),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedIncomeCategory = value;
                        });
                      },
                    ),
                  ],
                  const SizedBox(height: 24),
                  BlocBuilder<ExpenseBloc, ExpenseState>(
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text("Add Expense/Income"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            if (_title.text.isNotEmpty &&
                                _description.text.isNotEmpty) {
                              if (_selectedDataType == DataType.Expense) {
                                context.read<ExpenseBloc>().add(
                                      AddExpense(
                                          title: _title.text,
                                          isImportant: true,
                                          number: 0,
                                          description: _description.text,
                                          nominal: double.parse(_nominal.text),
                                          category: _selectedExpenseCategory!,
                                          createdBy: "",
                                          createdAt: DateTime.now(),
                                          updatedBy: "",
                                          updatedAt: DateTime.now()),
                                    );
                              } else {
                                context.read<IncomeBloc>().add(
                                      AddIncome(
                                          title: _title.text,
                                          isImportant: true,
                                          number: 0,
                                          description: _description.text,
                                          nominal: double.parse(_nominal.text),
                                          category: _selectedIncomeCategory!,
                                          createdBy: "",
                                          createdAt: DateTime.now(),
                                          updatedBy: "",
                                          updatedAt: DateTime.now()),
                                    );
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(seconds: 1),
                                  content:
                                      Text("Expense/Income added successfully"),
                                ),
                              );
                              context
                                  .read<ExpenseBloc>()
                                  .add(const FetchAllExpensesTotalExpensesByMonth());
                              context
                                  .read<IncomeBloc>()
                                  .add(const FetchAllIncomeTotalIncomeByMonth());
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Title and description must not be empty"),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
