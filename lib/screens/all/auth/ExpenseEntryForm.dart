// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
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

class ExpenseEntryForm extends StatefulWidget {
  final ExpenseDatabase database;

  ExpenseEntryForm({required this.database});

  @override
  _ExpenseEntryFormState createState() => _ExpenseEntryFormState();
}

class _ExpenseEntryFormState extends State<ExpenseEntryForm> {
  String selectedCategory = 'Food'; // Default category
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Date'),
              onTap: () {
                // You can implement a date picker dialog here.
              },
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
              items: ['Food', 'Transportation', 'Housing', 'Entertainment']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final amount = double.tryParse(amountController.text) ?? 0.0;
                final date = dateController.text;
                final category = selectedCategory;
                final description = descriptionController.text;

                final expense = Expense(
                  date: date,
                  amount: amount,
                  category: category,
                  thumbnail:
                      'path/to/your/image.png', // Replace with the actual image path.
                );

                await widget.database.insertExpense(expense);

                // Clear the form fields after submission.
                amountController.clear();
                dateController.clear();
                descriptionController.clear();
                setState(() {
                  selectedCategory = 'Food'; // Reset category to default.
                });
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
