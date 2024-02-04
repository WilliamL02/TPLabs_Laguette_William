import 'package:flutter/material.dart';
void main() {
  runApp(const HomeScreen());
}
class HomeScreen extends StatelessWidget {
  const  HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text('Welcome to the Home Screen'),
        
      ),
  floatingActionButton: FloatingActionButton(
  onPressed: () {
    Navigator.pushNamed(context, '/profile');
  },
  child: const Text('Go to Profile'),
), 
    );

  
  }
}


