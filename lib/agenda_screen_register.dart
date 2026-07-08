import 'package:flutter/material.dart';

class AgendaScreenRegister extends StatefulWidget {
  const AgendaScreenRegister({super.key});

  @override
  State<AgendaScreenRegister> createState() => _AgendaScreenRegisterState();
}

class _AgendaScreenRegisterState extends State<AgendaScreenRegister> {
  final formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registre o horário"),
      ),
    );
  }
}
