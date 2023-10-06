import 'package:flutter/material.dart';
import '../signup/signup_screen.dart';
import '../../../services/auth_service.dart';
import '../home_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key, required this.title});
  final String title;

  @override
  State<LogInScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LogInScreen> {
  bool _loading = false;
  var errorMessage = '';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  handleSubmit(context) async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.value.text;
    final password = _passwordController.value.text;

    setState(() => _loading = true);
    setState(() => errorMessage = '');

    final response = await AuthService().signInWithEmailAndPassword(email, password);

    if (response == null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      setState(() => errorMessage = response);
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: Center(
                      child: SizedBox(
                          width: 200,
                          height: 150,
                          child: Image.asset('assets/images/logo.png')),
                    ),
                  ),
                  Text(errorMessage, style: const TextStyle(color: Colors.red, fontSize: 20)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: _emailController,
                      validator: (value) {
                          if (value == null) {
                            return 'Please enter your email';
                          }
                          return null;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          hintText: 'Enter valid email id as abc@gmail.com'
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
                    child: TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null) {
                          const snackBar = SnackBar(
                            content: Text('Please enter your password!'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          hintText: 'Enter secure password'),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black
                      ),
                      onPressed: () => handleSubmit(context),
                      child: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          :  const Text(
                              'Login',
                              style: TextStyle(color: Colors.white, fontSize: 25),
                            )
                    ),
                  ),
                  const SizedBox(
                    height: 130,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      );
                    },
                    child: const Text('New User? Create Account'),
                  ),
                ],
              )
          )
      ),
    );
  }
}
