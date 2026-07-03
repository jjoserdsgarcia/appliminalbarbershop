import 'package:flutter/material.dart';

class ProfessionalsScreenSelect extends StatefulWidget {
  const ProfessionalsScreenSelect({super.key});

  @override
  State<ProfessionalsScreenSelect> createState() =>
      _ProfessionalsScreenSelectState();
}

class _ProfessionalsScreenSelectState extends State<ProfessionalsScreenSelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Selecione o profissional desejado")),
    );
  }
}
