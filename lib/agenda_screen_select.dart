import 'package:flutter/material.dart';

class AgendaScreenSelect extends StatefulWidget {
  const AgendaScreenSelect({super.key, required this.professionalName, required this.professionalId, required this.serviceName, required this.serviceId});

  final String professionalName;
  final int professionalId;
  final String serviceName;
  final int serviceId;

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
      body: Column(children: [
        Text("Profissional: ${widget.professionalName} - ID: ${widget.professionalId}"),
        Text("Serviço: ${widget.serviceName} - ID: ${widget.serviceId}"),
      ],)

    );
  }
}
