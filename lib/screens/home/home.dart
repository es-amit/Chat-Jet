import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("new app"),
        backgroundColor: Colors.redAccent,
      ),
      body: Text('THis is new app'),
    );
  }
}