import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bloc/income/income_bloc.dart';
import '../../constants/constants.dart';
import '../widgets/transaction_list.dart';

class IncomeTab extends StatefulWidget {
  const IncomeTab({super.key});

  @override
  State<IncomeTab> createState() => _IncomeTabState();
}

class _IncomeTabState extends State<IncomeTab> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool _isFetchingMore = false;
  String _searchQuery = '';

  // Default sort
  SortOption<IncomeOrderBy> _selectedSort = incomeSortOptions.firstWhere(
    (s) => s.field == IncomeOrderBy.createdAt && s.direction == OrderDir.DESC,
  );

  @override
  void initState() {
    super.initState();

    // Initial load
    context.read<IncomeBloc>().add(
          FetchIncomesPaging(
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

        context.read<IncomeBloc>().add(
              LoadMoreIncomes(
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

  void _onSortSelected(SortOption<IncomeOrderBy> selected) {
    setState(() {
      _selectedSort = selected;

      context.read<IncomeBloc>().add(
            FetchIncomesPaging(
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
                    hintText: 'Search incomes...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                      context.read<IncomeBloc>().add(
                            FetchIncomesPaging(
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
              PopupMenuButton<SortOption<IncomeOrderBy>>(
                icon: const Icon(Icons.sort),
                onSelected: _onSortSelected,
                itemBuilder: (context) => incomeSortOptions
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
          child: BlocConsumer<IncomeBloc, IncomeState>(
            listener: (context, state) {
              _isFetchingMore = false;
            },
            builder: (context, state) {
              if (state is DisplayIncomesPaging) {
                return TransactionList(
                  items: state.income,
                  isExpense: false,
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
