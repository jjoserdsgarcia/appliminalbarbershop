import 'package:flutter/material.dart';

class HomeScreenEmployee extends StatefulWidget {
  const HomeScreenEmployee({super.key});

  @override
  State<HomeScreenEmployee> createState() => _HomeScreenEmployeeState();
}

class _HomeScreenEmployeeState extends State<HomeScreenEmployee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Página Principal do Funcionário"),
      ),
    );
  }
}
