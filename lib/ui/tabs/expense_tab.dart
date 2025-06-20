import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_comb/ui/widgets/total_card.dart';

import '../../bloc/bloc/expense/expense_bloc.dart';
import '../widgets/transaction_list.dart';

class ExpenseTab extends StatefulWidget {
  const ExpenseTab({super.key});

  @override
  State<ExpenseTab> createState() => _ExpenseTabState();
}

class _ExpenseTabState extends State<ExpenseTab> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isFetchingMore = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    // Initial load
    context.read<ExpenseBloc>().add(const FetchExpensesPaging(""));

    // Scroll listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !_isFetchingMore) {
        _isFetchingMore = true;
        context.read<ExpenseBloc>().add(LoadMoreExpenses(_searchQuery));
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search expenses...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
                  context.read<ExpenseBloc>().add(FetchExpensesPaging(_searchQuery));

              });
            },
          ),
        ),
        Expanded(
          child: BlocConsumer<ExpenseBloc, ExpenseState>(
            listener: (context, state) {
              _isFetchingMore = false;
            },
            builder: (context, state) {
              if (state is DisplayExpensesPaging) {
              
                return TransactionList(
                  items: state.expense,
                  isExpense: true,
                  controller: _scrollController,
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }
}
