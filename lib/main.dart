import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_comb/bloc/bloc/expense/expense_bloc.dart';
import 'package:money_comb/bloc/bloc/income/income_bloc.dart';
import 'package:money_comb/ui/page/add_or_update_screen.dart';
import 'package:money_comb/ui/page/splash_screen.dart';
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


