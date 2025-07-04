import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_comb/bloc/bloc/expense/expense_bloc.dart';
import 'package:money_comb/bloc/bloc/income/income_bloc.dart';
import 'package:money_comb/constants/datatype.dart';
import 'package:money_comb/constants/expenseCategory.dart';
import 'package:money_comb/constants/incomeCategory.dart';
import 'package:money_comb/models/expense.dart';
import 'package:money_comb/models/income.dart';
import 'package:money_comb/util/stringUtil.dart';

import '../../constants/constants.dart';
import '../widgets/category_dropdown.dart';

class AddOrUpdateScreen extends StatefulWidget {
  final bool isUpdate;
  final bool isExpense;
  final dynamic item; // can be Expense or Income
  final DataType? initialType;

  const AddOrUpdateScreen({
    Key? key,
    this.isUpdate = false,
    this.isExpense = true,
    this.item,
    this.initialType,
  }) : super(key: key);

  @override
  State<AddOrUpdateScreen> createState() => _AddOrUpdateScreenState();
}

class _AddOrUpdateScreenState extends State<AddOrUpdateScreen> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _nominal = TextEditingController();

  DataType? _selectedDataType;
  ExpenseCategory? _selectedExpenseCategory = ExpenseCategory.others;
  IncomeCategory? _selectedIncomeCategory = IncomeCategory.others;

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate && widget.item != null) {
      final item = widget.item;
      _title.text = item.title;
      _description.text = item.description;
      _nominal.text = item.nominal.toString();
      if (item is Expense) {
        _selectedDataType = DataType.Expense;
        _selectedExpenseCategory = item.category;
      } else {
        _selectedDataType = DataType.Income;
        _selectedIncomeCategory = item.category;
      }
    } else {
      _selectedDataType = widget.initialType;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              widget.isUpdate ? 'Update Expense/Income' : 'Add Expense/Income'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => {
              if (widget.isUpdate)
                {
                  if (widget.item is Income)
                    {
                      context
                          .read<IncomeBloc>()
                          .add(FetchSpecificIncome(id: widget.item.id!)),
                    }
                  else
                    {
                      context
                          .read<ExpenseBloc>()
                          .add(FetchSpecificExpense(id: widget.item.id)),
                    },
                  Navigator.pop(context)
                }
              else
                {
                  context
                      .read<IncomeBloc>()
                      .add(const FetchAllIncomeTotalIncomeByMonthAndYear()),
                  context
                      .read<ExpenseBloc>()
                      .add(const FetchAllExpensesTotalExpensesByMonthAndYear()),
                  Navigator.pop(context)
                }
            },
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
                  _buildTextField("Title", _title, Icons.title, maxLength: 20),
                  const SizedBox(height: 16),
                  _buildTextField(
                      "Description", _description, Icons.description,
                      maxLines: 3, maxLength: 100),
                  const SizedBox(height: 16),
                  _buildTextField("Nominal", _nominal, Icons.currency_exchange,
                      isNumber: true, enableThousandSeparator: true),
                  const SizedBox(height: 16),
                  _buildDataTypeSelector(),
                  if (_selectedDataType == DataType.Expense)
                    CategoryDropdowns.buildExpenseCategoryDropdown(
                        _selectedExpenseCategory,
                        (p0) => {_selectedExpenseCategory = p0}),
                  if (_selectedDataType == DataType.Income)
                    CategoryDropdowns.buildIncomeCategoryDropdown(
                        _selectedIncomeCategory,
                        (p0) => {_selectedIncomeCategory = p0}),
                  const SizedBox(height: 24),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
    int? maxLength,
    bool isNumber = false,
    bool enableThousandSeparator = false,
  }) {
    final formatter = NumberFormat('#,###');

    if (isNumber && enableThousandSeparator) {
      controller.addListener(() {
        final rawText = controller.text.replaceAll(',', '');

        if (rawText.isEmpty) return;

        final number = int.tryParse(rawText);
        if (number == null) return;

        // Clamp to max allowed digits
        if (number > 999999999999) {
          controller.text = '999,999,999,999';
          controller.selection = TextSelection.collapsed(
            offset: controller.text.length,
          );
          return;
        }

        final newText = formatter.format(number);
        if (controller.text != newText) {
          final offset = newText.length;
          controller.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(offset: offset),
          );
        }
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          maxLength: isNumber ? 15 : maxLength, // allow formatted length
          inputFormatters:
              isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
          keyboardType: isNumber
              ? TextInputType.number
              : (maxLines > 1 ? TextInputType.multiline : TextInputType.text),
          decoration: InputDecoration(
            hintText: "Enter ${label.toLowerCase()}",
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ],
    );
  }

  Widget _buildDataTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            title: const Text('Expense'),
            leading: Radio<DataType>(
              value: DataType.Expense,
              groupValue: _selectedDataType,
              onChanged: (value) => setState(() => _selectedDataType = value),
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: const Text('Income'),
            leading: Radio<DataType>(
              value: DataType.Income,
              groupValue: _selectedDataType,
              onChanged: (value) => setState(() => _selectedDataType = value),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(widget.isUpdate ? Icons.save : Icons.add),
        label: Text(widget.isUpdate ? 'Update' : 'Add'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: () {
          if (_title.text.isNotEmpty &&
              _description.text.isNotEmpty &&
              _nominal.text.isNotEmpty) {
            final nominal =
                double.tryParse(_nominal.text.replaceAll(",", "")) ?? 0;

            if (_selectedDataType == DataType.Expense) {
              final expense = Expense(
                id: widget.isUpdate ? widget.item.id : null,
                title: _title.text,
                description: _description.text,
                number: 0,
                isImportant: true,
                nominal: nominal,
                category: _selectedExpenseCategory!,
                createdBy: '',
                createdAt: DateTime.now(),
                updatedBy: '',
                updatedAt: DateTime.now(),
              );
              context.read<ExpenseBloc>().add(
                    widget.isUpdate
                        ? UpdateExpense(expense: expense)
                        : AddExpense(
                            title: _title.text,
                            isImportant: true,
                            number: 0,
                            description: _description.text,
                            nominal: nominal,
                            category: _selectedExpenseCategory!,
                            createdBy: '',
                            createdAt: DateTime.now(),
                            updatedBy: '',
                            updatedAt: DateTime.now(),
                          ),
                  );

              if (widget.isUpdate) {
                context.read<ExpenseBloc>().add(FetchExpensesPaging(
                    "",
                    ExpenseOrderBy.createdAt.toString().split('.').last,
                    OrderDir.DESC.toString().split('.').last));
              } else {
                context
                    .read<ExpenseBloc>()
                    .add(const FetchAllExpensesTotalExpensesByMonthAndYear());
              }
            } else {
              final income = Income(
                id: widget.isUpdate ? widget.item.id : null,
                title: _title.text,
                description: _description.text,
                number: 0,
                isImportant: true,
                nominal: nominal,
                category: _selectedIncomeCategory!,
                createdBy: '',
                createdAt: DateTime.now(),
                updatedBy: '',
                updatedAt: DateTime.now(),
              );
              context.read<IncomeBloc>().add(
                    widget.isUpdate
                        ? UpdateIncome(income: income)
                        : AddIncome(
                            title: _title.text,
                            isImportant: true,
                            number: 0,
                            description: _description.text,
                            nominal: nominal,
                            category: _selectedIncomeCategory!,
                            createdBy: '',
                            createdAt: DateTime.now(),
                            updatedBy: '',
                            updatedAt: DateTime.now(),
                          ),
                  );

              if (widget.isUpdate) {
                context.read<IncomeBloc>().add(FetchIncomesPaging(
                    "",
                    IncomeOrderBy.createdAt.toString().split('.').last,
                    OrderDir.DESC.toString().split('.').last));
              } else {
                context
                    .read<IncomeBloc>()
                    .add(const FetchAllIncomeTotalIncomeByMonthAndYear());
              }
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(widget.isUpdate
                      ? 'Updated successfully'
                      : 'Added successfully')),
            );

            Navigator.pop(context); // First pop
            Navigator.pop(context); // Second pop
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                      Text("Title, description, nominal must not be empty")),
            );
          }
        },
      ),
    );
  }
}
