import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AgendaScreenSelect extends StatefulWidget {
  const AgendaScreenSelect({
    super.key,
    required this.professionalId,
    required this.serviceId,
    required this.serviceDescription,
    required this.professionalName,
    required this.servicePrice,
  });

  final int professionalId;
  final int serviceId;
  final String serviceDescription;
  final String professionalName;
  final double servicePrice;

  @override
  State<AgendaScreenSelect> createState() => _AgendaScreenSelectState();
}

class _AgendaScreenSelectState extends State<AgendaScreenSelect> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamento'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Profissional: ${widget.professionalName}'),
            Text('Serviço: ${widget.serviceDescription}'),
            Text('Preço: R\$ ${widget.servicePrice.toStringAsFixed(2)}'),
            
          ],
        ),
      ),
    );
  }
}