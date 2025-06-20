import 'package:flutter/material.dart';

class Constants {
  static const int transactionHistoryPageSize = 20;

  static const String addTodo = 'Add Todo';
  static const Color primaryColor = Colors.black87;
  static ButtonStyle customButtonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
    backgroundColor: Colors.black87,
    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
  );
}

enum OrderDir { ASC, DESC }
enum ExpenseOrderBy { createdAt, nominal, title, category }
enum IncomeOrderBy { createdAt, nominal, title, category }

class SortOption<T> {
  final T field;
  final OrderDir direction;
  final String Function(T) labelBuilder;

  const SortOption(this.field, this.direction, this.labelBuilder);

  String get label {
    final arrow = direction == OrderDir.ASC ? '↑' : '↓';
    return '${labelBuilder(field)} $arrow';
  }

  String get value => '${field.toString().split('.').last}:${direction.name}';
}

List<SortOption<ExpenseOrderBy>> expenseSortOptions = ExpenseOrderBy.values.expand((field) {
  return [
    SortOption(field, OrderDir.ASC, _expenseFieldLabel),
    SortOption(field, OrderDir.DESC, _expenseFieldLabel),
  ];
}).toList();

String _expenseFieldLabel(ExpenseOrderBy field) {
  switch (field) {
    case ExpenseOrderBy.nominal:
      return 'Nominal';
    case ExpenseOrderBy.createdAt:
      return 'Created At';
    case ExpenseOrderBy.title:
      return 'Title';
    case ExpenseOrderBy.category:
      return 'Category';
  }
}

List<SortOption<IncomeOrderBy>> incomeSortOptions = IncomeOrderBy.values.expand((field) {
  return [
    SortOption(field, OrderDir.ASC, _incomeFieldLabel),
    SortOption(field, OrderDir.DESC, _incomeFieldLabel),
  ];
}).toList();

String _incomeFieldLabel(IncomeOrderBy field) {
  switch (field) {
    case IncomeOrderBy.nominal:
      return 'Nominal';
    case IncomeOrderBy.createdAt:
      return 'Created At';
    case IncomeOrderBy.title:
      return 'Title';
    case IncomeOrderBy.category:
      return 'Category';
  }
}
