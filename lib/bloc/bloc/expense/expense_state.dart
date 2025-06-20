part of 'expense_bloc.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState();
}

class ExpenseInitial extends ExpenseState {
  @override
  List<Object> get props => [];
  
}

class DisplayTotalExpenses extends ExpenseState {
  final double expense;

  const DisplayTotalExpenses({required this.expense});
  @override
  List<Object> get props => [expense];
}

class DisplayExpenses extends ExpenseState {
  final List<Expense> expense;

  const DisplayExpenses({required this.expense});
  @override
  List<Object> get props => [expense];
}


class DisplayExpensesWithTotal extends ExpenseState {
  final List<Expense> expenses;
  final double total;

  const DisplayExpensesWithTotal({
    required this.expenses,
    required this.total,
  });

  @override
  List<Object> get props => [expenses, total];
}

class DisplayExpensesWithTotalYear extends ExpenseState {
  final List<Expense> expenses;
  final double total;
    final double totalYear;


  const DisplayExpensesWithTotalYear({
    required this.expenses,
    required this.total,
    required this.totalYear,

  });

  @override
  List<Object> get props => [expenses, total, totalYear];
}

class DisplaySpecificExpense extends ExpenseState {
  final Expense expense;

  const DisplaySpecificExpense({required this.expense});
  @override
  List<Object> get props => [expense];
}
