part of 'income_bloc.dart';

abstract class IncomeEvent extends Equatable {
  const IncomeEvent();
}

// Add Income Event
class AddIncome extends IncomeEvent {
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final double nominal;
  final IncomeCategory category;
  final bool fgActive;
  final String createdBy;
  final DateTime createdAt;
  final String updatedBy;
  final DateTime updatedAt;

  const AddIncome({
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

// Update Income Event
class UpdateIncome extends IncomeEvent {
  final Income income;

  const UpdateIncome({required this.income});

  @override
  List<Object?> get props => [income];
}

// Fetch FetchAllIncomeTotalIncomeByMonthAndYear Event
class FetchAllIncomeTotalIncomeByMonthAndYear extends IncomeEvent {
  const FetchAllIncomeTotalIncomeByMonthAndYear();

  @override
  List<Object?> get props => [];
}

// Fetch FetchAllIncomeTotalIncomeByMonth Event
class FetchAllIncomeTotalIncomeByMonth extends IncomeEvent {
  const FetchAllIncomeTotalIncomeByMonth();

  @override
  List<Object?> get props => [];
}

// Fetch All Incomes Event
class FetchIncomes extends IncomeEvent {
  const FetchIncomes();

  @override
  List<Object?> get props => [];
}

class FetchIncomesPaging extends IncomeEvent {
  final String query;
  final String orderBy;
  final String orderDir;

  const FetchIncomesPaging(this.query, this.orderBy, this.orderDir);

  @override
  List<Object?> get props => [query, orderBy, orderDir];
}

class LoadMoreIncomes extends IncomeEvent {
  final String query;
  final String orderBy;
  final String orderDir;

  const LoadMoreIncomes(this.query, this.orderBy, this.orderDir);

  @override
  List<Object?> get props => [query, orderBy, orderDir];
}

// Fetch Specific Income by ID
class FetchSpecificIncome extends IncomeEvent {
  final int id;

  const FetchSpecificIncome({required this.id});

  @override
  List<Object?> get props => [id];
}

// Soft Delete Income Event
class DeleteIncome extends IncomeEvent {
  final int id;

  const DeleteIncome({required this.id});

  @override
  List<Object?> get props => [id];
}
