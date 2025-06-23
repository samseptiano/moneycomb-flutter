import 'dart:ffi';

import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:money_comb/models/expense.dart';
import 'package:money_comb/models/income.dart';

import '../constants/constants.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;
  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute(
        '''
    CREATE TABLE expense (
      _id INTEGER PRIMARY KEY AUTOINCREMENT,
      isImportant BOOLEAN NOT NULL,
      number INTEGER NOT NULL,
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      nominal REAL NOT NULL,
      category TEXT NOT NULL,
      fgActive BOOLEAN NOT NULL,
      createdBy TEXT NOT NULL,
      createdAt TEXT NOT NULL,
      updatedBy TEXT NOT NULL,
      updatedAt TEXT NOT NULL
    )
  ''');

    await db.execute(
        '''
    CREATE TABLE income (
      _id INTEGER PRIMARY KEY AUTOINCREMENT,
      isImportant BOOLEAN NOT NULL,
      number INTEGER NOT NULL,
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      nominal REAL NOT NULL,
      category TEXT NOT NULL,
      fgActive BOOLEAN NOT NULL,
      createdBy TEXT NOT NULL,
      createdAt TEXT NOT NULL,
      updatedBy TEXT NOT NULL,
      updatedAt TEXT NOT NULL
    )
  ''');
  }

  Future<Expense> createExpense(Expense expense) async {
    final db = await instance.database;
    final id = await db.insert(expenseTable, expense.toJson());
    return expense.copy(id: id);
  }

  Future<Income> createIncome(Income income) async {
    final db = await instance.database;
    final id = await db.insert(incomeTable, income.toJson());
    return income.copy(id: id);
  }

  Future<double> readTotalExpense() async {
    final db = await instance.database;

    final result = await db.rawQuery(
        'SELECT SUM(${ExpenseFields.nominal}) as total FROM $expenseTable where fgActive = 1 ');

    final total = result.first['total'];
    return (total is num) ? total.toDouble() : 0.0;
  }

Future<double> readAverageExpenseLast3Months() async {
  final db = await instance.database;
  double total = 0;

  final now = DateTime.now();

  for (int i = 0; i < 3; i++) {
    final targetMonth = DateTime(now.year, now.month - i, 1);
    final start = DateFormat('yyyy-MM-dd').format(targetMonth);

    // Get the last day of the month
    final firstDayNextMonth = (targetMonth.month == 12)
        ? DateTime(targetMonth.year + 1, 1, 1)
        : DateTime(targetMonth.year, targetMonth.month + 1, 1);
    final end = firstDayNextMonth.subtract(const Duration(days: 1));
    final endStr = DateFormat('yyyy-MM-dd').format(end);

    final result = await db.rawQuery('''
      SELECT SUM(${ExpenseFields.nominal}) as total
      FROM $expenseTable
      WHERE fgActive = 1
        AND date(${ExpenseFields.createdAt}) BETWEEN date(?) AND date(?)
    ''', [start, endStr]);

    final rowTotal = result.first['total'];
    final monthlyTotal = (rowTotal is num) ? rowTotal.toDouble() : 0.0;
    total += monthlyTotal;

    print('Month: ${targetMonth.month}/${targetMonth.year}, Total: $monthlyTotal');
  }

  final average = total / 3;
  print('Average (this + last 2 months): $average');
  return average;
}




  Future<double> readTotalExpenseByCurrentMonth() async {
    final db = await instance.database;

    final result = await db.rawQuery(
        '''
    SELECT SUM(${ExpenseFields.nominal}) as total
    FROM $expenseTable
    WHERE fgActive = 1
      AND strftime('%Y-%m', createdAt) = strftime('%Y-%m', 'now')
  ''');

    final total = result.first['total'];
    return (total is num) ? total.toDouble() : 0.0;
  }

  Future<double> readTotalExpenseByLastMonth() async {
    final db = await instance.database;

    final result = await db.rawQuery(
        '''
    SELECT SUM(${ExpenseFields.nominal}) as total
    FROM $expenseTable
    WHERE fgActive = 1
      AND date(createdAt) >= date('now', 'start of month', '-1 month')
      AND date(createdAt) <  date('now', 'start of month')
    ''');

    final total = result.first['total'];
    return (total is num) ? total.toDouble() : 0.0;
  }

  Future<double> readTotalExpenseByTwoMonthsAgo() async {
    final db = await instance.database;

    final result = await db.rawQuery(
        '''
    SELECT SUM(${ExpenseFields.nominal}) as total
    FROM $expenseTable
    WHERE fgActive = 1
      AND date(createdAt) >= date('now', 'start of month', '-2 months')
      AND date(createdAt) <  date('now', 'start of month', '-1 month')
    ''');

    final total = result.first['total'];
    return (total is num) ? total.toDouble() : 0.0;
  }

  Future<double> readTotalExpenseByCurrentYear() async {
    final db = await instance.database;

    final result = await db.rawQuery(
        '''
    SELECT SUM(${ExpenseFields.nominal}) as total
    FROM $expenseTable
    WHERE fgActive = 1
      AND strftime('%Y', createdAt) = strftime('%Y', 'now')
  ''');

    final total = result.first['total'];
    return (total is num) ? total.toDouble() : 0.0;
  }

  Future<double> readTotalExpenseByLastYear() async {
    final db = await instance.database;

    final result = await db.rawQuery(
        '''
    SELECT SUM(${ExpenseFields.nominal}) as total
    FROM $expenseTable
    WHERE fgActive = 1
      AND date(createdAt) >= date('now', 'start of year', '-1 year')
      AND date(createdAt) < date('now', 'start of year')
  ''');

    final total = result.first['total'];
    return (total is num) ? total.toDouble() : 0.0;
  }

  Future<double> readTotalIncome() async {
    final db = await instance.database;

    final result = await db.rawQuery(
        'SELECT SUM(${IncomeFields.nominal}) as total FROM $incomeTable  where fgActive = 1');

    final total = result.first['total'];
    return (total is num) ? total.toDouble() : 0.0;
  }

Future<double> readAverageIncomeLast3Months() async {
  final db = await instance.database;
  double total = 0;

  final now = DateTime.now();

  for (int i = 0; i < 3; i++) {
    final targetMonth = DateTime(now.year, now.month - i, 1);
    final start = DateFormat('yyyy-MM-dd').format(targetMonth);

    // Get the last day of the month
    final firstDayNextMonth = (targetMonth.month == 12)
        ? DateTime(targetMonth.year + 1, 1, 1)
        : DateTime(targetMonth.year, targetMonth.month + 1, 1);
    final end = firstDayNextMonth.subtract(const Duration(days: 1));
    final endStr = DateFormat('yyyy-MM-dd').format(end);

    final result = await db.rawQuery('''
      SELECT SUM(${IncomeFields.nominal}) as total
      FROM $incomeTable
      WHERE fgActive = 1
        AND date(${IncomeFields.createdAt}) BETWEEN date(?) AND date(?)
    ''', [start, endStr]);

    final rowTotal = result.first['total'];
    final monthlyTotal = (rowTotal is num) ? rowTotal.toDouble() : 0.0;
    total += monthlyTotal;

    print('Month: ${targetMonth.month}/${targetMonth.year}, Total: $monthlyTotal');
  }

  final average = total / 3;
  print('Average (this + last 2 months): $average');
  return average;
}

  Future<double> readTotalIncomeByCurrentMonth() async {
    final db = await instance.database;

    final result = await db.rawQuery(
        '''
    SELECT SUM(${IncomeFields.nominal}) as total
    FROM $incomeTable
    WHERE fgActive = 1
      AND strftime('%Y-%m', createdAt) = strftime('%Y-%m', 'now')
  ''');

    final total = result.first['total'];
    return (total is num) ? total.toDouble() : 0.0;
  }

  Future<double> readTotalIncomeByLastMonth() async {
    final db = await instance.database;

    final result = await db.rawQuery(
        '''
    SELECT SUM(${IncomeFields.nominal}) as total
    FROM $incomeTable
    WHERE fgActive = 1
      AND date(createdAt) >= date('now', 'start of month', '-1 month')
      AND date(createdAt) <  date('now', 'start of month')
    ''');

    final total = result.first['total'];
    return (total is num) ? total.toDouble() : 0.0;
  }

  Future<double> readTotalIncomeByTwoMonthsAgo() async {
    final db = await instance.database;

    final result = await db.rawQuery(
        '''
    SELECT SUM(${IncomeFields.nominal}) as total
    FROM $incomeTable
    WHERE fgActive = 1
      AND date(createdAt) >= date('now', 'start of month', '-2 months')
      AND date(createdAt) <  date('now', 'start of month', '-1 month')
    ''');

    final total = result.first['total'];
    return (total is num) ? total.toDouble() : 0.0;
  }

  Future<double> readTotalIncomeByCurrentYear() async {
    final db = await instance.database;

    final result = await db.rawQuery(
        '''
    SELECT SUM(${IncomeFields.nominal}) as total
    FROM $incomeTable
    WHERE fgActive = 1
      AND strftime('%Y', createdAt) = strftime('%Y', 'now')
  ''');

    final total = result.first['total'];
    return (total is num) ? total.toDouble() : 0.0;
  }

  Future<double> readTotalIncomeByLastYear() async {
    final db = await instance.database;

    final result = await db.rawQuery(
        '''
    SELECT SUM(${IncomeFields.nominal}) as total
    FROM $incomeTable
    WHERE fgActive = 1
      AND date(createdAt) >= date('now', 'start of year', '-1 year')
      AND date(createdAt) < date('now', 'start of year')
  ''');

    final total = result.first['total'];
    return (total is num) ? total.toDouble() : 0.0;
  }

  Future<Expense> readExpense({required int id}) async {
    final db = await instance.database;

    final maps = await db.query(
      expenseTable,
      columns: ExpenseFields.values,
      where: '${ExpenseFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Expense.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<Income> readIncome({required int id}) async {
    final db = await instance.database;

    final maps = await db.query(
      incomeTable,
      columns: IncomeFields.values,
      where: '${IncomeFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Income.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Expense>> readAllExpensesPaging({
    String search = "",
    int limit = Constants.transactionHistoryPageSize,
    int offset = 0,
    String orderBy = ExpenseFields.createdAt,
    String orderDir = 'DESC', // or 'ASC'
  }) async {
    final db = await instance.database;

    String where = '${ExpenseFields.fgActive} = 1';
    List<String> whereArgs = [];

    if (search.isNotEmpty) {
      where += ' AND ('
          '${ExpenseFields.title} LIKE ? OR '
          '${ExpenseFields.description} LIKE ? OR '
          '${ExpenseFields.nominal} LIKE ? OR '
          '${ExpenseFields.category} LIKE ?'
          ')';
      final keyword = '%$search%';
      whereArgs.addAll([keyword, keyword, keyword, keyword]);
    }

    final result = await db.query(
      expenseTable,
      where: where,
      whereArgs: whereArgs,
      limit: limit,
      offset: offset,
      orderBy: '$orderBy $orderDir', // Dynamic sorting
    );

    return result.map((json) => Expense.fromJson(json)).toList();
  }

  Future<List<Expense>> readAllExpenses() async {
    final db = await instance.database;
    const orderBy = '${ExpenseFields.createdAt} DESC';

    final result = await db.query(
      expenseTable,
      where: '${ExpenseFields.fgActive} = ?',
      whereArgs: [1], // 1 represents true in SQLite
      orderBy: orderBy,
    );

    return result.map((json) => Expense.fromJson(json)).toList();
  }

  Future<List<Income>> readAllIncomes() async {
    final db = await instance.database;
    const orderBy = '${IncomeFields.createdAt} DESC';

    final result = await db.query(
      incomeTable,
      where: '${IncomeFields.fgActive} = ?',
      whereArgs: [1], // 1 represents true in SQLite
      orderBy: orderBy,
    );

    return result.map((json) => Income.fromJson(json)).toList();
  }

  Future<List<Income>> readAllIncomesPaging({
    String search = "",
    int limit = Constants.transactionHistoryPageSize,
    int offset = 0,
    String orderBy = IncomeFields.createdAt,
    String orderDir = 'DESC', // or 'ASC'
  }) async {
    final db = await instance.database;

    String where = '${IncomeFields.fgActive} = 1';
    List<String> whereArgs = [];

    if (search.isNotEmpty) {
      where += ' AND ('
          '${IncomeFields.title} LIKE ? OR '
          '${IncomeFields.description} LIKE ? OR '
          '${IncomeFields.nominal} LIKE ? OR '
          '${IncomeFields.category} LIKE ?'
          ')';
      final keyword = '%$search%';
      whereArgs.addAll([keyword, keyword, keyword, keyword]);
    }

    final result = await db.query(
      incomeTable,
      where: where,
      whereArgs: whereArgs,
      limit: limit,
      offset: offset,
      orderBy: '$orderBy $orderDir', // Dynamic sorting
    );

    return result.map((json) => Income.fromJson(json)).toList();
  }

  Future<int> updateExpense({required Expense expense}) async {
    final db = await instance.database;

    return db.update(
      expenseTable,
      expense.toJson(),
      where: '${ExpenseFields.id} = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> updateIncome({required Income income}) async {
    final db = await instance.database;

    return db.update(
      incomeTable,
      income.toJson(),
      where: '${IncomeFields.id} = ?',
      whereArgs: [income.id],
    );
  }

  Future<int> deleteExpense({required int id}) async {
    final db = await instance.database;

    return await db.delete(
      expenseTable,
      where: '${ExpenseFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteInactiveExpense({required int id}) async {
    final db = await instance.database;

    return await db.update(
      expenseTable,
      {ExpenseFields.fgActive: 0}, // 0 represents false in SQLite
      where: '${ExpenseFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteIncome({required int id}) async {
    final db = await instance.database;

    return await db.delete(
      incomeTable,
      where: '${IncomeFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteInactiveIncome({required int id}) async {
    final db = await instance.database;

    return await db.update(
      incomeTable,
      {IncomeFields.fgActive: 0}, // 0 represents false in SQLite
      where: '${IncomeFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
