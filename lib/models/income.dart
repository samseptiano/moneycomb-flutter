import 'package:money_comb/constants/incomeCategory.dart';

const String incomeTable = 'income';

class IncomeFields {
  static final List<String> values = [
    id, isImportant, number, title, description, nominal, category,
    fgActive, createdBy, createdAt, updatedBy, updatedAt
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

class Income {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final double nominal;
  final IncomeCategory category;
  final bool fgActive;
  final String createdBy;
  final DateTime createdAt;
  final String updatedBy;
  final DateTime updatedAt;

  const Income({
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

  Income copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    double? nominal,
    IncomeCategory? category,
    bool? fgActive,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
  }) =>
      Income(
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

  static Income fromJson(Map<String, Object?> json) => Income(
        id: json[IncomeFields.id] as int?,
        isImportant: json[IncomeFields.isImportant] == 1,
        number: json[IncomeFields.number] as int,
        title: json[IncomeFields.title] as String,
        description: json[IncomeFields.description] as String,
        nominal: json[IncomeFields.nominal] as double,
        category: IncomeCategory.values.firstWhere(
            (e) => e.name == json[IncomeFields.category],
            orElse: () => IncomeCategory.others),
        fgActive: json[IncomeFields.fgActive] == 1,
        createdBy: json[IncomeFields.createdBy] as String,
        createdAt: DateTime.parse(json[IncomeFields.createdAt] as String),
        updatedBy: json[IncomeFields.updatedBy] as String,
        updatedAt: DateTime.parse(json[IncomeFields.updatedAt] as String),
      );

  Map<String, Object?> toJson() => {
        IncomeFields.id: id,
        IncomeFields.isImportant: isImportant ? 1 : 0,
        IncomeFields.number: number,
        IncomeFields.title: title,
        IncomeFields.description: description,
        IncomeFields.nominal: nominal,
        IncomeFields.category: category.name,
        IncomeFields.fgActive: fgActive ? 1 : 0,
        IncomeFields.createdBy: createdBy,
        IncomeFields.createdAt: createdAt.toIso8601String(),
        IncomeFields.updatedBy: updatedBy,
        IncomeFields.updatedAt: updatedAt.toIso8601String(),
      };
}
