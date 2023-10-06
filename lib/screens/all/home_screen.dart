import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../components/AppDropdownInput.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateInput = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  var errorMessage = '';
  var category = '';

  handleSubmit(context) async {
    if (!_formKey.currentState!.validate()) return;
    final email = _dateInput.value.text;
    final password = _amountController.value.text;
    final description = _descriptionController.value.text;

    setState(() => _loading = true);
    setState(() => errorMessage = '');

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: Center(
          child: ElevatedButton(
            child: const Text('Add Expense'),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      scrollable: true,
                      title: const Text('Add Expense'),
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _amountController,
                                decoration: const InputDecoration(
                                  labelText: 'Amount',
                                  icon: Icon(Icons.money),
                                ),
                              ),
                              TextFormField(
                                controller: _dateInput,
                                decoration: const InputDecoration(
                                  labelText: 'Date',
                                  icon: Icon(Icons.calendar_today),
                                ),
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2100));

                                  if (pickedDate != null) {
                                    print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                    print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                    setState(() {
                                      _dateInput.text = formattedDate; //set output date to TextField value.
                                    });
                                  } else {}
                                },
                              ),
                              // AppDropdownInput(
                              //   hintText: "Category",
                              //   options: const ["Male", "Female"],
                              //   value: category,
                              //   onChanged: (String value) {
                              //     setState(() {
                              //       category = value;
                              //     });
                              //   },
                              //   getLabel: (String value) => value,
                              // ),
                              TextFormField(
                                controller: _descriptionController,
                                decoration: const InputDecoration(
                                  labelText: 'Description',
                                  icon: Icon(Icons.message),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                            child: _loading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text("Add"),
                            onPressed: () => handleSubmit(context)
                        )
                      ],
                    );
                  });
            },
          ),
        ),
      ),
    );
  }
}
