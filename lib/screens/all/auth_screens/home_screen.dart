import 'package:expenses/main.dart';
import 'package:expenses/services/expense_repository.dart';
import 'package:expenses/screens/all/auth_screens/add_expense_screen.dart';
import 'package:expenses/models/expense.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart'
    show AppBar, BuildContext, CircularProgressIndicator, ColorScheme, Colors, Column, FloatingActionButton, Icon, IconButton, Icons, ListTile, MainAxisAlignment, MaterialApp, MaterialPageRoute, Navigator, Scaffold, State, StatefulWidget, StatelessWidget, Text, Theme, ThemeData, Widget, runApp;
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currencySymbol = "\ZMW"; // Default currency symbol

  @override
  void initState() {
    super.initState();
    // Retrieve the currency symbol from preferences
    _loadCurrencySymbol();
  }

  Future<void> _loadCurrencySymbol() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currencySymbol =
          prefs.getString('currency') ?? "\ZMW"; // Default to "$" if not set
    });
  }

  @override
  Widget build(BuildContext context) {
    final expenseRepository = ExpenseRepository();

    // Function to refresh the expense list
    Future<void> refreshExpenses() async {
      setState(() {}); // Trigger a rebuild of the expense list
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses Tracker'),
      ),
      body: FutureBuilder<List<Expense>>(
        future: expenseRepository.getExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final expenses = snapshot.data ?? [];
            if (expenses.isEmpty){
              return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No data found',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Click the plus below to Add',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                      ]
                  )
              );
            } else {
              return ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index];
                  return ListTile(
                    title: Text(expense.title),
                    subtitle: Text(
                        'Amount: $currencySymbol${expense.amount.toStringAsFixed(2)} \nDate: ${expense.date}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        expenseRepository.deleteExpense(expense.id!);
                        refreshExpenses(); // Refresh the list
                      },
                    ),
                  );
                },
              );
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to the add expense screen and wait for a result
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddExpenseScreen(),
            ),
          );
          // If result is not null, it means an expense was added, so refresh the list
          if (result != null) {
            refreshExpenses();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
