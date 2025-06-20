import 'package:money_comb/constants/expenseCategory.dart';

const String expenseTable = 'expense';

class ExpenseFields {
  static final List<String> values = [
    id,
    isImportant,
    number,
    title,
    description,
    nominal,
    category,
    fgActive,
    createdBy,
    createdAt,
    updatedBy,
    updatedAt
  ];

  static const String id = '_id';
  static const String isImportant = 'isImportant';
  static const String number = 'number';
  static const String title = 'title';
  static const String description = 'description';
  static const String nominal = 'nominal';
  static const String category = 'category';
  static const String fgActive = 'fgActive';
  static const String createdBy = 'createdBy';
  static const String createdAt = 'createdAt';
  static const String updatedBy = 'updatedBy';
  static const String updatedAt = 'updatedAt';
}

class Expense {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final double nominal;
  final ExpenseCategory category;
  final bool fgActive;
  final String createdBy;
  final DateTime createdAt;
  final String updatedBy;
  final DateTime updatedAt;

  const Expense({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.nominal,
    required this.category,
    this.fgActive = true,
    this.createdBy = 'samseptiano',
    required this.createdAt,
    this.updatedBy = 'samseptiano',
    required this.updatedAt,
  });

  Expense copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    double? nominal,
    ExpenseCategory? category,
    bool? fgActive,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
  }) =>
      Expense(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        title: title ?? this.title,
        description: description ?? this.description,
        nominal: nominal ?? this.nominal,
        category: category ?? this.category,
        fgActive: fgActive ?? this.fgActive,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
        updatedBy: updatedBy ?? this.updatedBy,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  static Expense fromJson(Map<String, Object?> json) => Expense(
        id: json[ExpenseFields.id] as int?,
        isImportant: json[ExpenseFields.isImportant] == 1,
        number: json[ExpenseFields.number] as int,
        title: json[ExpenseFields.title] as String,
        description: json[ExpenseFields.description] as String,
        nominal: json[ExpenseFields.nominal] as double,
        category: ExpenseCategory.values.firstWhere(
            (e) => e.name == json[ExpenseFields.category],
            orElse: () => ExpenseCategory.others),
        fgActive: json[ExpenseFields.fgActive] == 1,
        createdBy: json[ExpenseFields.createdBy] as String,
        createdAt: DateTime.parse(json[ExpenseFields.createdAt] as String),
        updatedBy: json[ExpenseFields.updatedBy] as String,
        updatedAt: DateTime.parse(json[ExpenseFields.updatedAt] as String),
      );

  Map<String, Object?> toJson() => {
        ExpenseFields.id: id,
        ExpenseFields.isImportant: isImportant ? 1 : 0,
        ExpenseFields.number: number,
        ExpenseFields.title: title,
        ExpenseFields.description: description,
        ExpenseFields.nominal: nominal,
        ExpenseFields.category: category.name,
        ExpenseFields.fgActive: fgActive ? 1 : 0,
        ExpenseFields.createdBy: createdBy,
        ExpenseFields.createdAt: createdAt.toIso8601String(),
        ExpenseFields.updatedBy: updatedBy,
        ExpenseFields.updatedAt: updatedAt.toIso8601String(),
      };
}
