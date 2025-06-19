import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:money_comb/constants/IncomeCategory.dart';
import '../../../models/income.dart';
import '../../../services/database_service.dart';
part 'income_event.dart';
part 'income_state.dart';

class IncomeBloc extends Bloc<IncomeEvent, IncomeState> {
  IncomeBloc() : super(IncomeInitial()) {
    List<Income> incomes = [];
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
      final total = await DatabaseService.instance.readTotalIncomeByCurrentMonth();
      emit(DisplayIncomesWithTotal(incomes: incomes, total: total));
    });
  }
}
