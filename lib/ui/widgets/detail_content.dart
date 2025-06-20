import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_comb/constants/constants.dart';
import 'package:money_comb/util/stringUtil.dart';
import 'custom_text.dart';

class DetailContent extends StatelessWidget {
  final dynamic item;
  final bool isExpense;
  final VoidCallback? onUpdate;

  const DetailContent({
    Key? key,
    required this.item,
    required this.isExpense,
    this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('Title'),
          CustomText(text: item.title, fontSize: 20),

          _buildLabel('Description'),
          CustomText(text: item.description),

          _buildLabel('Nominal'),
          CustomText(
            text: NumberFormat('#,##0').format(item.nominal),
            fontSize: 20,
          ),

          _buildLabel('Created Date'),
          CustomText(
            text: DateFormat('dd MMM yyyy hh:mm').format(item.createdAt),
          ),

          _buildLabel('Category'),
          CustomText(
            text: StringUtil.formatCamelCase(
              item.category.toString().split('.').last,
            ),
          ),

          const SizedBox(height: 20),

          if (onUpdate != null)
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Update'),
                onPressed: onUpdate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
