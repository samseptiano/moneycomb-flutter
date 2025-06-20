import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bloc/expense/expense_bloc.dart';
import '../../constants/constants.dart';
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

  // Default sort
  SortOption<ExpenseOrderBy> _selectedSort = expenseSortOptions.firstWhere(
    (s) => s.field == ExpenseOrderBy.createdAt && s.direction == OrderDir.DESC,
  );

  @override
  void initState() {
    super.initState();

    // Initial load
    context.read<ExpenseBloc>().add(
          FetchExpensesPaging(
            _searchQuery,
            _selectedSort.field.name,
            _selectedSort.direction.name,
          ),
        );

    // Listen to scroll for pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !_isFetchingMore) {
        _isFetchingMore = true;

        context.read<ExpenseBloc>().add(
              LoadMoreExpenses(
                _searchQuery,
                _selectedSort.field.name,
                _selectedSort.direction.name,
              ),
            );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSortSelected(SortOption<ExpenseOrderBy> selected) {
    setState(() {
      _selectedSort = selected;

      context.read<ExpenseBloc>().add(
            FetchExpensesPaging(
              _searchQuery,
              selected.field.name,
              selected.direction.name,
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search and Sort Row
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search expenses...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                      context.read<ExpenseBloc>().add(
                            FetchExpensesPaging(
                              _searchQuery,
                              _selectedSort.field.name,
                              _selectedSort.direction.name,
                            ),
                          );
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<SortOption<ExpenseOrderBy>>(
                icon: const Icon(Icons.sort),
                onSelected: _onSortSelected,
                itemBuilder: (context) => expenseSortOptions
                    .map((option) => PopupMenuItem(
                          value: option,
                          child: Text(option.label),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),

        // Transaction List
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
