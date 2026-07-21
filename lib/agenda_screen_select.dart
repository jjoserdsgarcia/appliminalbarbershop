import 'package:appliminalbarbershop/home_screen_user.dart';
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

  // Correspondem a int8 no PostgreSQL.
  final int professionalId;
  final int serviceId;

  final String serviceDescription;
  final String professionalName;
  final double servicePrice;

  @override
  State<AgendaScreenSelect> createState() => _AgendaScreenSelectState();
}

class _AgendaScreenSelectState extends State<AgendaScreenSelect> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  final SupabaseClient _supabase = Supabase.instance.client;

  final List<String> _times = [
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
    '17:30',
    '18:00',
  ];

  late List<DateTime> _dates;

  DateTime? _selectedDate;
  String? _selectedTime;

  Set<String> _occupiedTimes = {};

  bool _loading = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _dates = _generateDates();

    if (_dates.isNotEmpty) {
      _selectedDate = _dates.first;
      _loadOccupiedTimes();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  List<DateTime> _generateDates() {
    final now = DateTime.now();

    DateTime date = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final dates = <DateTime>[];

    // Mostra os próximos 14 dias, exceto domingos.
    while (dates.length < 14) {
      if (date.weekday != DateTime.sunday) {
        dates.add(date);
      }

      date = date.add(const Duration(days: 1));
    }

    return dates;
  }

  Future<void> _loadOccupiedTimes() async {
    if (_selectedDate == null) {
      return;
    }

    setState(() {
      _loading = true;
      _occupiedTimes.clear();
    });

    try {
      final response = await _supabase
          .from('appointments')
          .select('appointment_time')
          .eq('professional_id', widget.professionalId)
          .eq(
            'appointment_date',
            _databaseDate(_selectedDate!),
          )
          .eq('status', 'scheduled');

      final occupied = <String>{};

      for (final item in response) {
        final time = item['appointment_time']?.toString();

        if (time != null && time.length >= 5) {
          occupied.add(time.substring(0, 5));
        }
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _occupiedTimes = occupied;

        if (_occupiedTimes.contains(_selectedTime)) {
          _selectedTime = null;
        }
      });
    } on PostgrestException catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage('Erro ao consultar os horários.');
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _saveAppointment() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
      _showMessage('Selecione uma data.');
      return;
    }

    if (_selectedTime == null) {
      _showMessage('Selecione um horário.');
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final result = await _supabase
          .from('appointments')
          .insert({
            'professional_id': widget.professionalId,
            'service_id': widget.serviceId,
            'professional_name': widget.professionalName,
            'service_description': widget.serviceDescription,
            'service_price': widget.servicePrice,
            'customer_name': _nameController.text.trim(),
            'customer_phone': _phoneController.text.trim(),
            'appointment_date': _databaseDate(
              _selectedDate!,
            ),
            'appointment_time': '${_selectedTime!}:00',
            'status': 'scheduled',
          })
          .select('id')
          .single();

      // A coluna id é int8 no Supabase.
      final int appointmentId = (result['id'] as num).toInt();

      if (!mounted) {
        return;
      }

      await _showSuccessDialog(appointmentId);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } on PostgrestException catch (error) {
      if (error.code == '23505') {
        _selectedTime = null;

        _showMessage(
          'Este horário acabou de ser reservado. Escolha outro.',
        );

        await _loadOccupiedTimes();
      } else {
        _showMessage(error.message);
      }
    } catch (_) {
      _showMessage('Erro ao registrar o atendimento.');
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  Future<void> _showSuccessDialog(
    int appointmentId,
  ) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 55,
          ),
          title: const Text(
            'Agendamento confirmado',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Protocolo: #$appointmentId',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                _nameController.text.trim(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(widget.serviceDescription),
              Text(widget.professionalName),
              const SizedBox(height: 10),
              Text(
                _displayDate(_selectedDate!),
                textAlign: TextAlign.center,
              ),
              Text(
                'Horário: $_selectedTime',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreenUser()));
              },
              child: const Text('Concluir'),
            ),
          ],
        );
      },
    );
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  String _databaseDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  String _displayDate(DateTime date) {
    const weekdays = [
      'segunda-feira',
      'terça-feira',
      'quarta-feira',
      'quinta-feira',
      'sexta-feira',
      'sábado',
      'domingo',
    ];

    const months = [
      'janeiro',
      'fevereiro',
      'março',
      'abril',
      'maio',
      'junho',
      'julho',
      'agosto',
      'setembro',
      'outubro',
      'novembro',
      'dezembro',
    ];

    return '${weekdays[date.weekday - 1]}, '
        '${date.day} de ${months[date.month - 1]}';
  }

  String _shortWeekday(DateTime date) {
    const weekdays = [
      'SEG',
      'TER',
      'QUA',
      'QUI',
      'SEX',
      'SÁB',
      'DOM',
    ];

    return weekdays[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final price = widget.servicePrice.toStringAsFixed(2).replaceAll('.', ',');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamento'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.person),
                      title: const Text('Profissional'),
                      subtitle: Text(
                        widget.professionalName,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.content_cut),
                      title: const Text('Serviço'),
                      subtitle: Text(
                        widget.serviceDescription,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.attach_money),
                      title: const Text('Preço'),
                      subtitle: Text('R\$ $price'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const SizedBox(height: 25),

            const Text(
              'Escolha o dia',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _dates.length,
                separatorBuilder: (_, _) {
                  return const SizedBox(width: 8);
                },
                itemBuilder: (context, index) {
                  final date = _dates[index];

                  final selected = _selectedDate == date;

                  return ChoiceChip(
                    selected: selected,
                    label: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_shortWeekday(date)),
                        Text(
                          date.day.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onSelected: (_) {
                      setState(() {
                        _selectedDate = date;
                        _selectedTime = null;
                      });

                      _loadOccupiedTimes();
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Escolha o horário',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            if (_loading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _times.map((time) {
                  final occupied = _occupiedTimes.contains(time);

                  return ChoiceChip(
                    selected: _selectedTime == time,
                    label: Text(
                      occupied ? '$time ocupado' : time,
                    ),
                    onSelected: occupied
                        ? null
                        : (selected) {
                            setState(() {
                              _selectedTime = selected ? time : null;
                            });
                          },
                  );
                }).toList(),
              ),

            const SizedBox(height: 30),

            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _saving ? null : _saveAppointment,
                icon: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.check_circle_outline,
                      ),
                label: Text(
                  _saving ? 'Registrando...' : 'Confirmar agendamento',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
