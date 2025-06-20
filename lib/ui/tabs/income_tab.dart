import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/bloc/income/income_bloc.dart';
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

  @override
  void initState() {
    super.initState();

    // Initial load
    context.read<IncomeBloc>().add(const FetchIncomesPaging(""));

    // Scroll listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !_isFetchingMore) {
        _isFetchingMore = true;
        context.read<IncomeBloc>().add(LoadMoreIncomes(_searchQuery));
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
              hintText: 'Search incomes...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
                  context.read<IncomeBloc>().add(FetchIncomesPaging(_searchQuery));

              });
            },
          ),
        ),
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
