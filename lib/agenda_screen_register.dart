import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AgendaScreenRegister extends StatefulWidget {
  const AgendaScreenRegister({super.key});

  @override
  State<AgendaScreenRegister> createState() => _AgendaScreenRegisterState();
}

class _AgendaScreenRegisterState extends State<AgendaScreenRegister> {
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  void registerSchedule() async {
    final supabase = Supabase.instance.client;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registre o horário"),
      ),
    );
  }
}
