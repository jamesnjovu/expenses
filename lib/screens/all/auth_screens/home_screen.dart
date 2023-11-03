import 'package:expenses/screens/all/auth_screens/expense_repository.dart';
import 'package:expenses/screens/all/auth_screens/add_expense_screen.dart';
import 'package:expenses/models/expense.dart';
import 'package:flutter/material.dart'
    show
    BuildContext,
    CircularProgressIndicator,
    ColorScheme,
    Colors,
    Column,
    FloatingActionButton,
    Icon,
    IconButton,
    Icons,
    ListTile,
    MainAxisAlignment,
    MaterialApp,
    MaterialPageRoute,
    Navigator,
    Scaffold,
    State,
    StatefulWidget,
    StatelessWidget,
    Text,
    Theme,
    ThemeData,
    Widget,
    runApp;
import 'package:flutter/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  final title = "Home Page";

  @override
  Widget build(BuildContext context) {
    final expenseRepository = ExpenseRepository();

    // Function to refresh the expense list
    Future<void> refreshExpenses() async {
      setState(() {}); // Trigger a rebuild of the expense list
    }

    return MaterialApp(
        home: Scaffold(
          body: FutureBuilder<List<Expense>>(
            future: expenseRepository.getExpenses(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final expenses = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    return ListTile(
                      title: Text(expense.title),
                      subtitle:
                      Text('Amount: \$${expense.amount.toStringAsFixed(2)}'),
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
        ));
  }

  void setState(Null Function() param0) {}
}
