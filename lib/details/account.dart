import 'package:flutter/material.dart';

class DetailAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Akun"),
        backgroundColor: Colors.blueGrey,
      ),
      body: const Center(
        child: Text(
          "Hello, World!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
