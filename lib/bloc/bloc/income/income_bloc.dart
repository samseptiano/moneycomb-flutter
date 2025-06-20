import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:money_comb/constants/incomeCategory.dart';
import '../../../constants/constants.dart';
import '../../../models/income.dart';
import '../../../services/database_service.dart';
part 'income_event.dart';
part 'income_state.dart';

class IncomeBloc extends Bloc<IncomeEvent, IncomeState> {
  IncomeBloc() : super(IncomeInitial()) {
    List<Income> incomes = [];

    int _currentOffset = 0;
    final int _pageSize = Constants.transactionHistoryPageSize;

    on<AddIncome>((event, emit) async {
      await DatabaseService.instance.createIncome(
        Income(
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

    on<UpdateIncome>((event, emit) async {
      await DatabaseService.instance.updateIncome(
        income: event.income,
      );
    });

    on<FetchIncomes>((event, emit) async {
      incomes = await DatabaseService.instance.readAllIncomes();
      emit(DisplayIncomes(income: incomes));
    });

    on<FetchIncomesPaging>((event, emit) async {
      _currentOffset = 0;
      incomes = await DatabaseService.instance
          .readAllIncomesPaging(search: event.query, limit: _pageSize, offset: _currentOffset, orderBy: event.orderBy, orderDir: event.orderDir);
      emit(DisplayIncomesPaging(income: incomes));
    });

    on<LoadMoreIncomes>((event, emit) async {
      if (state is DisplayIncomesPaging) {
        final currentState = state as DisplayIncomesPaging;
        _currentOffset += _pageSize;
        final moreIncomes = incomes = await DatabaseService.instance
            .readAllIncomesPaging(search: event.query, limit: _pageSize, offset: _currentOffset, orderBy: event.orderBy, orderDir: event.orderDir);

        // If no more data, return same state
        if (moreIncomes.isEmpty) return;

        final updatedIncomes = [...currentState.income, ...moreIncomes];
        emit(DisplayIncomesPaging(income: updatedIncomes));
      }
    });

    on<FetchSpecificIncome>((event, emit) async {
      Income income = await DatabaseService.instance.readIncome(id: event.id);
      emit(DisplaySpecificIncome(income: income));
    });

    on<DeleteIncome>((event, emit) async {
      await DatabaseService.instance.deleteInactiveIncome(id: event.id);
      add(const FetchIncomes());
    });

    on<FetchAllIncomeTotalIncomeByMonth>((event, emit) async {
      final incomes = await DatabaseService.instance.readAllIncomes();
      final total =
          await DatabaseService.instance.readTotalIncomeByCurrentMonth();
      emit(DisplayIncomesWithTotal(incomes: incomes, total: total));
    });

    on<FetchAllIncomeTotalIncomeByMonthAndYear>((event, emit) async {
      final incomes = await DatabaseService.instance.readAllIncomes();
      final total =
          await DatabaseService.instance.readTotalIncomeByCurrentMonth();
      final totalyear =
          await DatabaseService.instance.readTotalIncomeByCurrentYear();

      emit(DisplayIncomesWithTotalYear(
          incomes: incomes, total: total, totalYear: totalyear));
    });
  }
}
