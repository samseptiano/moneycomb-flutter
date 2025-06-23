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

class DisplayExpensesPaging extends ExpenseState {
  final List<Expense> expense;

  const DisplayExpensesPaging({required this.expense});
  @override
  List<Object> get props => [expense];
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

class DisplayExpensesSummary extends ExpenseState {
  final double ytd;
  final double lastYear;
  final double month;
  final double lastMonth;
  final double last2Month;
  final double avg3Month;

  const DisplayExpensesSummary({
    required this.ytd,
    required this.lastYear,
    required this.month,
    required this.lastMonth,
    required this.last2Month,
    required this.avg3Month,
  });

  @override
  List<Object> get props =>
      [ytd, lastYear, month, lastMonth, last2Month, avg3Month];
}


class DisplayExpensesSummaryChart extends ExpenseState {
  final List<Map<String, dynamic>> ytd;
  final Map<String, double> monthByCategory;

  const DisplayExpensesSummaryChart({
    required this.ytd,
    required this.monthByCategory
  });

  @override
  List<Object> get props =>
      [ytd, monthByCategory];
}