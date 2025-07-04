import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:money_comb/constants/constants.dart';
import 'package:money_comb/constants/expenseCategory.dart';
import 'package:money_comb/models/expense.dart';
import '../../../services/database_service.dart';
part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc() : super(ExpenseInitial()) {
    List<Expense> expenses = [];

    int _currentOffset = 0;
    final int _pageSize = Constants.transactionHistoryPageSize;

    on<AddExpense>((event, emit) async {
      await DatabaseService.instance.createExpense(
        Expense(
            isImportant: event.isImportant,
            number: event.number,
            title: event.title,
            description: event.description,
            nominal: event.nominal,
            category: event.category,
            createdAt: event.createdAt,
            updatedAt: event.updatedAt),
      );
    });

    on<UpdateExpense>((event, emit) async {
      await DatabaseService.instance.updateExpense(
        expense: event.expense,
      );
    });

    on<FetchExpenses>((event, emit) async {
      expenses = await DatabaseService.instance.readAllExpenses();
      emit(DisplayExpenses(expense: expenses));
    });

    on<FetchExpensesPaging>((event, emit) async {
      _currentOffset = 0;

      expenses = await DatabaseService.instance.readAllExpensesPaging(
          search: event.query,
          limit: _pageSize,
          offset: _currentOffset,
          orderBy: event.orderBy,
          orderDir: event.orderDir);
      emit(DisplayExpensesPaging(expense: expenses));
    });

    on<LoadMoreExpenses>((event, emit) async {
      if (state is DisplayExpensesPaging) {
        final currentState = state as DisplayExpensesPaging;
        _currentOffset += _pageSize;
        final moreExpenses = expenses = await DatabaseService.instance
            .readAllExpensesPaging(
                search: event.query,
                limit: _pageSize,
                offset: _currentOffset,
                orderBy: event.orderBy,
                orderDir: event.orderDir);
        // If no more data, return same state
        if (moreExpenses.isEmpty) return;

        final updatedExpenses = [...currentState.expense, ...moreExpenses];
        emit(DisplayExpensesPaging(expense: updatedExpenses));
      }
    });

    on<FetchSpecificExpense>((event, emit) async {
      Expense expense =
          await DatabaseService.instance.readExpense(id: event.id);
      emit(DisplaySpecificExpense(expense: expense));
    });

    on<DeleteExpense>((event, emit) async {
      await DatabaseService.instance.deleteInactiveExpense(id: event.id);
      add(const FetchExpenses());
    });

    on<FetchAllExpensesTotalExpensesByMonthAndYear>((event, emit) async {
      final expenses = await DatabaseService.instance.readAllExpenses();
      final total =
          await DatabaseService.instance.readTotalExpenseByCurrentMonth();
      final totalYear =
          await DatabaseService.instance.readTotalExpenseByCurrentYear();

      emit(DisplayExpensesWithTotalYear(
          expenses: expenses, total: total, totalYear: totalYear));
    });

    on<FetchExpensesSummary>((event, emit) async {
      final ytd =
          await DatabaseService.instance.readTotalExpenseByCurrentYear();
      final lastYear =
          await DatabaseService.instance.readTotalExpenseByLastYear();
      final month =
          await DatabaseService.instance.readTotalExpenseByCurrentMonth();
      final lastMonth =
          await DatabaseService.instance.readTotalExpenseByLastMonth();
      final last2Month =
          await DatabaseService.instance.readTotalIncomeByTwoMonthsAgo();
      final avg3Month =
          await DatabaseService.instance.readAverageExpenseLast3Months();
      emit(DisplayExpensesSummary(
          ytd: ytd,
          lastYear: lastYear,
          month: month,
          lastMonth: lastMonth,
          last2Month: last2Month,
          avg3Month: avg3Month));
    });

    on<FetchExpensesSummaryChart>((event, emit) async {
      final ytd = await DatabaseService.instance.readYTDExpensesGroupByMonth();
      final monthBycategory = await DatabaseService.instance.readCurrentMonthExpensesGroupByCategory();

      emit(DisplayExpensesSummaryChart(ytd: ytd, monthByCategory: monthBycategory));
    });
  }
}
