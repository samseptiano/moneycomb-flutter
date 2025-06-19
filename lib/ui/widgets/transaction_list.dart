import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/bloc/expense/expense_bloc.dart';
import '../../bloc/bloc/income/income_bloc.dart';
import '../../util/stringUtil.dart';
import '../page/details_page.dart';

class TransactionList extends StatelessWidget {
  final List<dynamic> items;
  final bool isExpense;

  const TransactionList({
    Key? key,
    required this.items,
    required this.isExpense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('No data found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];

        return GestureDetector(
          onTap: () {
            if (isExpense) {
              context
                  .read<ExpenseBloc>()
                  .add(FetchSpecificExpense(id: item.id!));
            } else {
              context.read<IncomeBloc>().add(FetchSpecificIncome(id: item.id!));
            }

            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DetailsPage()),
            );
          },
          child: Card(
            elevation: 6,
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: isExpense ? Colors.redAccent : Colors.green,
            child: Column(
              children: [
  // Top-right date
  Padding(
    padding: const EdgeInsets.only(right: 12.0, top: 8.0),
    child: Align(
      alignment: Alignment.topRight,
      child: Text(
        DateFormat('dd MMM yyyy hh:mm').format(item.createdAt),
        style: const TextStyle(color: Colors.white70, fontSize: 11),
      ),
    ),
  ),

  // Main content
  ListTile(
    title: Text(
      item.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(color: Colors.white, fontSize: 16),
    ),
    subtitle: Text(
      item.description,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(color: Colors.white, fontSize: 12),
    ),
    trailing: Text(
      NumberFormat('#,##0').format(item.nominal),
      style: const TextStyle(color: Colors.white, fontSize: 18),
    ),
  ),

  // Bottom-right category
  Padding(
    padding: const EdgeInsets.only(right: 16.0, bottom: 4.0),
    child: Align(
      alignment: Alignment.centerRight,
      child: Text(
        StringUtil.formatCamelCase(
          item.category.toString().split('.').last,
        ),
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontStyle: FontStyle.italic,
        ),
      ),
    ),
  ),
],

            ),
          ),
        );
      },
    );
  }
}
