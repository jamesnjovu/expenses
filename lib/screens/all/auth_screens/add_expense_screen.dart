import 'package:expenses/services/expense_repository.dart';
import 'package:expenses/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String selectedCategory = 'Food'; // Default category
  String? selectedImage; // Store the selected image path
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(labelText: 'Date'),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
              items: [
                'Food',
                'Transportation',
                'Housing',
                'Entertainment',
                'Other', // Add the "Other" option
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Open the image picker
                _selectImage();
              },
              child: const Text('Select Image to Attach'),
            ),
            ElevatedButton(
              onPressed: () {
                // Open the camera
                _captureImage();
              },
              child: const Text('Capture Image to Attach'),
            ),
            ElevatedButton(
              onPressed: () {
                // Validate and save the expense
                _saveExpense();
              },
              child: const Text('Save Expense'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectImage() async {
    final pickedFile = await _imagePicker.pickImage(
        source: ImageSource
            .gallery); // You can use ImageSource.camera for the camera
    if (pickedFile != null) {
      setState(() {
        selectedImage = pickedFile.path;
      });
    }
  }

  Future<void> _captureImage() async {
    final pickedFile = await _imagePicker.pickImage(
        source: ImageSource
            .camera); // You can use ImageSource.camera for the camera
    if (pickedFile != null) {
      setState(() {
        selectedImage = pickedFile.path;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text = picked.toString();
      });
    }
  }

  void _saveExpense() {
    final title = _titleController.text;
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final date = _dateController.text;

    if (title.isNotEmpty && amount > 0 && date.isNotEmpty) {
      // Call the repository to insert the expense into the database
      final expense = Expense(
        title: title,
        amount: amount,
        date: date,
        category: selectedCategory, // Include the category
        image: selectedImage, // Include the image path
      );
      ExpenseRepository expenseRepository = ExpenseRepository();
      expenseRepository.insertExpense(expense);

      // Navigate back to the expense list screen
      Navigator.pop(context);
    } else {
      // Show an error message if any field is empty or invalid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields with valid data.'),
        ),
      );
    }
  }
}
