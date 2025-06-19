enum ExpenseCategory {
  // Basic Needs
  basicNeeds(null, false),
  foodAndBeverages(basicNeeds, false),
  utilities(basicNeeds, true),
  rentOrMortgage(basicNeeds, true),

  // Transportation
  transportation(null, false),
  fuel(transportation, false),
  parking(transportation, false),
  toll(transportation, false),
  publicTransport(transportation, false),
  vehicleMaintenance(transportation, false),
  vehicleInsurance(transportation, true),

  // Communication & Internet
  communication(null, false),
  phoneCredit(communication, true),
  dataPackages(communication, true),
  internet(communication, true),

  // Health
  health(null, false),
  medicines(health, false),
  doctorConsultation(health, false),
  healthInsurance(health, true),

  // Education
  education(null, false),
  booksAndSupplies(education, false),
  schoolFees(education, true),
  courseFees(education, false),
  privateTutoring(education, true),

  // Entertainment & Recreation
  entertainment(null, false),
  movies(entertainment, false),
  vacation(entertainment, false),
  streamingServices(entertainment, true),

  // Lifestyle
  lifestyle(null, false),
  diningOut(lifestyle, false),
  clothing(lifestyle, false),
  personalCare(lifestyle, false),
  personalCareMembership(lifestyle, true),

  // Finance & Investment
  finance(null, false),
  loanRepayment(finance, true),
  savings(finance, true),
  investment(finance, true),

  // Donation & Social
  donation(null, false),
  charity(donation, false),
  gifts(donation, false),
  familySupport(donation, true),

  // Others
  others(null, false);

  final ExpenseCategory? parent;
  final bool isFixed;

  const ExpenseCategory(this.parent, this.isFixed);

  bool get isParentCategory => parent == null;
  bool get isChildCategory => parent != null;
}

List<ExpenseCategory> getFixedExpenseCategories() {
  return ExpenseCategory.values
      .where((cat) => cat.isChildCategory && cat.isFixed)
      .toList();
}

List<ExpenseCategory> getVariableExpenseCategories() {
  return ExpenseCategory.values
      .where((cat) => cat.isChildCategory && !cat.isFixed)
      .toList();
}

List<ExpenseCategory> getOtherExpenseCategories() {
  return ExpenseCategory.values
      .where((cat) => cat.isParentCategory && !cat.isFixed)
      .toList();
}
