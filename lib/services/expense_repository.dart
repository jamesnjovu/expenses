import 'package:expenses/models/database_helper.dart';
import 'package:expenses/models/expense.dart';
import "package:sqflite/sqflite.dart";

class ExpenseRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insertExpense(Expense expense) async {
    Database? db = await dbHelper.database;
    return await db!.insert(DatabaseHelper.table, expense.toMap());
  }

  Future<List<Expense>> getExpenses() async {
    Database? db = await dbHelper.database;
    List<Map<String, dynamic>> maps = await db!.query(DatabaseHelper.table);
    return List.generate(maps.length, (i) {
      return Expense(
        id: maps[i]['id'],
        title: maps[i]['title'],
        amount: maps[i]['amount'],
        date: maps[i]['date'],
        category: '',
      );
    });
  }

  Future<int> updateExpense(Expense expense) async {
    Database? db = await dbHelper.database;
    return await db!.update(
      DatabaseHelper.table,
      expense.toMap(),
      where: "id = ?",
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteExpense(int id) async {
    Database? db = await dbHelper.database;
    return await db!.delete(
      DatabaseHelper.table,
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
