import 'package:flutter/material.dart';
import 'package:expenses/services/auth_service.dart';
import 'package:expenses/services/preferences_manager.dart';
import 'package:expenses/main.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedCurrency = 'ZMW';
  String selectedCategory = 'Food';
  bool darkMode = false;

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  void loadPreferences() async {
    selectedCurrency = await PreferencesManager.getCurrency();
    selectedCategory = await PreferencesManager.getCategory();
    darkMode = await PreferencesManager.getDarkMode();
    setState(() {});
  }
  void handleLogout() async {
    await AuthService().signOut();
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const App()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Currency Symbol:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: selectedCurrency,
              onChanged: (newValue) {
                setState(() {
                  selectedCurrency = newValue!;
                  PreferencesManager.setCurrency(newValue);
                });
              },
              items: ['ZMW', 'USD', 'EUR', 'GBP']
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Default Category:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: selectedCategory,
              onChanged: (newValue) {
                setState(() {
                  selectedCategory = newValue!;
                  PreferencesManager.setCategory(newValue);
                });
              },
              items: ['Food', 'Transportation', 'Housing', 'Entertainment']
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Dark Mode:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Switch(
              value: darkMode,
              onChanged: (value) {
                setState(() {
                  darkMode = value;
                  PreferencesManager.setDarkMode(value);
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                handleLogout();
              },
              child: const Text('Log out'),
            )
          ],
        ),
      ),
    );
  }
}
