import 'package:flutter/material.dart';
import 'package:money_comb/constants/expenseCategory.dart';
import 'package:money_comb/constants/incomeCategory.dart';
import 'package:money_comb/util/stringUtil.dart';

class CategoryDropdowns {
  static Widget buildExpenseCategoryDropdown(
    ExpenseCategory? selectedCategory,
    Function(ExpenseCategory?) onChanged,
  ) {
    final sortedCategories = [...ExpenseCategory.values]..sort((a, b) {
      if (a == ExpenseCategory.others) return 1;
      if (b == ExpenseCategory.others) return -1;
      return a.name.compareTo(b.name);
    });

    return DropdownButtonFormField<ExpenseCategory>(
      value: selectedCategory,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      items: sortedCategories
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(StringUtil.formatCamelCase(e.name)),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  static Widget buildIncomeCategoryDropdown(
    IncomeCategory? selectedCategory,
    Function(IncomeCategory?) onChanged,
  ) {
    final sortedCategories = [...IncomeCategory.values]..sort((a, b) {
      if (a == IncomeCategory.others) return 1;
      if (b == IncomeCategory.others) return -1;
      return a.name.compareTo(b.name);
    });

    return DropdownButtonFormField<IncomeCategory>(
      value: selectedCategory,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      items: sortedCategories
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(StringUtil.formatCamelCase(e.name)),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}