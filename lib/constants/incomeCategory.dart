enum IncomeCategory {
  // Top-level
  income(null, false),

  // Subcategories
  salary(income, true),
  business(income, false),
  freelance(income, false),
  investmentReturn(income, false),
  gifts(income, false),
  rentalIncome(income, true),
  others(income, false);

  final IncomeCategory? parent;
  final bool isFixed;

  const IncomeCategory(this.parent, this.isFixed);

  bool get isParentCategory => parent == null;
  bool get isChildCategory => parent != null;
}

List<IncomeCategory> getFixedIncomeCategories() {
  return IncomeCategory.values
      .where((cat) => cat.isChildCategory && cat.isFixed)
      .toList();
}

List<IncomeCategory> getVariableIncomeCategories() {
  return IncomeCategory.values
      .where((cat) => cat.isChildCategory && !cat.isFixed)
      .toList();
}
