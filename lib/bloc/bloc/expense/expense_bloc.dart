import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:money_comb/constants/expenseCategory.dart';
import 'package:money_comb/models/expense.dart';
import '../../../services/database_service.dart';
part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc() : super(ExpenseInitial()) {
    List<Expense> expenses = [];
    double totalExpense = 0;

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

    on<FetchSpecificExpense>((event, emit) async {
      Expense expense =
          await DatabaseService.instance.readExpense(id: event.id);
      emit(DisplaySpecificExpense(expense: expense));
    });

    on<DeleteExpense>((event, emit) async {
      await DatabaseService.instance.deleteInactiveExpense(id: event.id);
      add(const FetchExpenses());
    });

    on<FetchAllExpensesTotalExpensesByMonth>((event, emit) async {
      final expenses = await DatabaseService.instance.readAllExpenses();
      final total = await DatabaseService.instance.readTotalExpenseByCurrentMonth();
      emit(DisplayExpensesWithTotal(expenses: expenses, total: total));
    });
  }
}
