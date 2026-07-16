import 'package:flutter/material.dart';

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
        title: Text(widget.professionalName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.serviceDescription,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              'Preço: R\$ ${widget.servicePrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
