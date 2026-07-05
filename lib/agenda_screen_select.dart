import 'package:flutter/material.dart';

class AgendaScreenSelect extends StatefulWidget {
  const AgendaScreenSelect({super.key});

  @override
  State<AgendaScreenSelect> createState() => _AgendaScreenSelectState();
}

class _AgendaScreenSelectState extends State<AgendaScreenSelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Selecione a data e hora"),
      ),

    );
  }
}
