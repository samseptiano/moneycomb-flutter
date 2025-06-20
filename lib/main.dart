import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_comb/bloc/bloc/expense/expense_bloc.dart';
import 'package:money_comb/bloc/bloc/income/income_bloc.dart';
import 'package:money_comb/ui/page/add_or_update_page.dart';
import 'package:money_comb/ui/splash_screen/splash_screen.dart';
import 'package:money_comb/ui/tabs/expense_tab.dart';
import 'package:money_comb/ui/tabs/income_tab.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ExpenseBloc()),
        BlocProvider(create: (context) => IncomeBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class SqFliteDemo extends StatefulWidget {
  const SqFliteDemo({Key? key}) : super(key: key);

  @override
  State<SqFliteDemo> createState() => _SqFliteDemoState();
}

class _SqFliteDemoState extends State<SqFliteDemo>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Dispatch events to fetch data on startup
    context.read<ExpenseBloc>()
    .add(const FetchExpenses());
    // ..add(const FetchTotalExpenses());
    context.read<IncomeBloc>().add(const FetchIncomes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MoneyComb'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Expenses'),
            Tab(text: 'Incomes'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.black87),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => const AddOrUpdatePage()),
          );
        },
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          // Expense tab
          ExpenseTab(),
          // Income tab
          IncomeTab(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
