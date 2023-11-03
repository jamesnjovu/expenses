import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:expenses/services/expense_repository.dart';
import 'package:expenses/models/expense.dart';
import 'package:expenses/services/send_service.dart';
import 'package:expenses/services/preferences_manager.dart';

class ShareReportScreen extends StatefulWidget {
  ShareReportScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<ShareReportScreen> {
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  String? selectedMethod;
  String? recipient;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Select Date Range:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: DateTimePicker(
                      label: 'Start Date',
                      selectedDate: selectedStartDate,
                      onDateSelected: (date) {
                        setState(() {
                          selectedStartDate = date;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: DateTimePicker(
                      label: 'End Date',
                      selectedDate: selectedEndDate,
                      onDateSelected: (date) {
                        setState(() {
                          selectedEndDate = date;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Select Sharing Method:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: selectedMethod,
                hint: Text('Select Method'),
                items: ['Email', 'SMS']
                    .map((method) => DropdownMenuItem<String>(
                          value: method,
                          child: Text(method),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMethod = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a method';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: selectedMethod == 'Email'
                      ? 'Recipient Email'
                      : 'Recipient Phone Number',
                ),
                onChanged: (value) {
                  recipient = value;
                },
                validator: (value) {
                  if (selectedMethod == 'Email') {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                  } else if (selectedMethod == 'SMS') {
                    if (value!.isEmpty || value.length != 10) {
                      return 'Please enter a valid 10-digit phone number';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Implement sending the report based on selectedMethod
                    if (selectedMethod == 'Email') {
                      // Send report via email
                      shareViaEmail();
                    } else if (selectedMethod == 'SMS') {
                      // Send report via SMS
                      shareViaSMS();
                    }
                  }
                },
                child: Text('Send Report'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DateTimePicker extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;

  DateTimePicker({
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
        InkWell(
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            if (pickedDate != null) {
              onDateSelected(pickedDate);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              children: <Widget>[
                Icon(Icons.calendar_today),
                SizedBox(width: 5),
                Text(
                  selectedDate != null
                      ? "${selectedDate!.toLocal()}".split(' ')[0]
                      : 'Select Date',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
