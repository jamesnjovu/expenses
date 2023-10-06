import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
          padding: const EdgeInsets.only(top: 60.0),
        child: Center(
          child: ElevatedButton(
              child: const Text('Sign Out'),
              onPressed: () {
                AuthService().signOut();
              },
          ),
        ),
      ),
    );
  }
}
