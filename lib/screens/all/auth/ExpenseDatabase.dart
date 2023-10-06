import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseDatabase {
  late Database _database;

  Future<void> initializeDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'expenses.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE expenses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            amount REAL,
            category TEXT,
            thumbnail TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertExpense(Expense expense) async {
    await _database.insert('expenses', expense.toMap());
  }

  Future<List<Expense>> getExpenses() async {
    final List<Map<String, dynamic>> maps = await _database.query('expenses');
    return List.generate(maps.length, (i) {
      return Expense(
        id: maps[i]['id'],
        date: maps[i]['date'],
        amount: maps[i]['amount'],
        category: maps[i]['category'],
        thumbnail: maps[i]['thumbnail'],
      );
    });
  }
}

class Expense {
  final int? id;
  final String date;
  final double amount;
  final String category;
  final String thumbnail;

  Expense({
    this.id,
    required this.date,
    required this.amount,
    required this.category,
    required this.thumbnail,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'amount': amount,
      'category': category,
      'thumbnail': thumbnail,
    };
  }
}
