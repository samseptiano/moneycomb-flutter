part of 'income_bloc.dart';

abstract class IncomeState extends Equatable {
  const IncomeState();
}

class IncomeInitial extends IncomeState {
  @override
  List<Object> get props => [];
}

class DisplayTotalIncomes extends IncomeState {
  final double income;

  const DisplayTotalIncomes({required this.income});
  @override
  List<Object> get props => [income];
}

class DisplayIncomes extends IncomeState {
  final List<Income> income;

  const DisplayIncomes({required this.income});
  @override
  List<Object> get props => [income];
}

class DisplayIncomesPaging extends IncomeState {
  final List<Income> income;

  const DisplayIncomesPaging({required this.income});
  @override
  List<Object> get props => [income];
}

class DisplayIncomesWithTotal extends IncomeState {
  final List<Income> incomes;
  final double total;

  const DisplayIncomesWithTotal({
    required this.incomes,
    required this.total,
  });

  @override
  List<Object> get props => [incomes, total];
}

class DisplayIncomesWithTotalYear extends IncomeState {
  final List<Income> incomes;
  final double total;
  final double totalYear;

  const DisplayIncomesWithTotalYear({
    required this.incomes,
    required this.total,
        required this.totalYear,

  });

  @override
  List<Object> get props => [incomes, total, totalYear];
}


class DisplaySpecificIncome extends IncomeState {
  final Income income;

  const DisplaySpecificIncome({required this.income});
  @override
  List<Object> get props => [income];
}


class DisplayIncomeSummary extends IncomeState {
  final double ytd;
  final double lastYear;
  final double month;
  final double lastMonth;
  final double last2Month;
  final double avg3Month;

  const DisplayIncomeSummary({
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
