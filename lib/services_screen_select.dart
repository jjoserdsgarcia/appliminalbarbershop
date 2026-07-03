import 'package:flutter/material.dart';

class ServicesScreenSelect extends StatefulWidget {
  const ServicesScreenSelect({super.key});

  @override
  State<ServicesScreenSelect> createState() => _ServicesScreenSelectState();
}

class _ServicesScreenSelectState extends State<ServicesScreenSelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Selecione o serviço desejado")),
    );
  }
}
