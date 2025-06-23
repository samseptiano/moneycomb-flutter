part of 'expense_bloc.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();
}

// Add Expense Event
class AddExpense extends ExpenseEvent {
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final double nominal;
  final ExpenseCategory category;
  final bool fgActive;
  final String createdBy;
  final DateTime createdAt;
  final String updatedBy;
  final DateTime updatedAt;

  const AddExpense({
    required this.title,
    required this.isImportant,
    required this.number,
    required this.description,
    required this.nominal,
    required this.category,
    this.fgActive = true,
    required this.createdBy,
    required this.createdAt,
    required this.updatedBy,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        title,
        isImportant,
        number,
        description,
        nominal,
        category,
        fgActive,
        createdBy,
        createdAt,
        updatedBy,
        updatedAt,
      ];
}

// Update Expense Event
class UpdateExpense extends ExpenseEvent {
  final Expense expense;

  const UpdateExpense({required this.expense});

  @override
  List<Object?> get props => [expense];
}

// Fetch FetchAllExpensesTotalExpensesByMonthAndYear Event
class FetchAllExpensesTotalExpensesByMonthAndYear extends ExpenseEvent {
  const FetchAllExpensesTotalExpensesByMonthAndYear();

  @override
  List<Object?> get props => [];
}

// Fetch All Expenses Event
class FetchExpenses extends ExpenseEvent {
  const FetchExpenses();

  @override
  List<Object?> get props => [];
}

// Fetch All Expenses with paging Event
class FetchExpensesPaging extends ExpenseEvent {
  final String query;
  final String orderBy;
  final String orderDir;

  const FetchExpensesPaging(this.query, this.orderBy, this.orderDir);

  @override
  List<Object?> get props => [query, orderBy, orderDir];
}

class LoadMoreExpenses extends ExpenseEvent {
  final String query;
  final String orderBy;
  final String orderDir;
  const LoadMoreExpenses(this.query, this.orderBy, this.orderDir);

  @override
  List<Object?> get props => [query, orderBy, orderDir];
}

// Fetch Specific Expense by ID
class FetchSpecificExpense extends ExpenseEvent {
  final int id;

  const FetchSpecificExpense({required this.id});

  @override
  List<Object?> get props => [id];
}

// Soft Delete Expense Event
class DeleteExpense extends ExpenseEvent {
  final int id;

  const DeleteExpense({required this.id});

  @override
  List<Object?> get props => [id];
}


// Fetch Expenses Summary Event
class FetchExpensesSummary extends ExpenseEvent {
  const FetchExpensesSummary();

  @override
  List<Object?> get props => [];
}

// Fetch Expenses Summary Chart Event
class FetchExpensesSummaryChart extends ExpenseEvent {
  const FetchExpensesSummaryChart();

  @override
  List<Object?> get props => [];
}