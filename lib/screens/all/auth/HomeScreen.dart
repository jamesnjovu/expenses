import 'package:expenses/screens/all/auth/ExpenseEntryForm.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final ExpenseDatabase database;

  HomeScreen({required this.database});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final loadedExpenses = await widget.database.getExpenses();
    setState(() {
      expenses = loadedExpenses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final expense = expenses[index];
          return ListTile(
            leading: Image.asset(
              expense.thumbnail,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text('Amount: \$${expense.amount.toStringAsFixed(2)}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${expense.date}'),
                Text('Category: ${expense.category}'),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the expense entry form when the FAB is pressed.
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => ExpenseEntryForm(database: widget.database),
            ),
          )
              .then((_) {
            _loadExpenses(); // Reload the list after adding a new expense.
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
