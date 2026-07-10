import 'package:appliminalbarbershop/component_schedule.dart';
import 'package:appliminalbarbershop/schedule_class.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AgendaScreenRegister extends StatefulWidget {
  const AgendaScreenRegister({
    super.key,
    required this.descricaoDia,
    required this.employeeSchedule,
    required this.professionalName,
    required this.professionalId,
    required this.serviceName,
    required this.serviceId,
  });

  final String professionalName;
  final int professionalId;
  final String serviceName;
  final int serviceId;
  final String descricaoDia;
  final ScheduleClass? employeeSchedule;

  @override
  State<AgendaScreenRegister> createState() => _AgendaScreenRegisterState();
}

class _AgendaScreenRegisterState extends State<AgendaScreenRegister> {
  var startTime = 0;
  var endTime = 23;
  var selecionandoHorarioInicio = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.employeeSchedule != null) {
      setState(() {
        startTime = widget.employeeSchedule!.startTime;
        endTime = widget.employeeSchedule!.endTime;
      });
    }
  }

  void selecionarHorario(int horaInteiro) {
    if (selecionandoHorarioInicio) {
      if (horaInteiro < endTime) {
        setState(() {
          startTime = horaInteiro;
        });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog.adaptive(
              title: Text('Atenção'),
              content: Text('Horário de início não pode ser superior ao horário de fim.'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Fechar'),
                ),
              ],
            );
          },
        );
      }
    } else {
      if (selecionandoHorarioInicio) {
        if (horaInteiro > startTime) {
          setState(() {
            endTime = horaInteiro;
          });
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog.adaptive(
                title: Text('Atenção'),
                content: Text('Horário de fim não pode ser inferior ao horário de início.'),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Fechar'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        //.
      }
    }
  }

  Color? getHorarioColor(int horaInteiro) {
    return horaInteiro >= startTime ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final horarios = <String>[];

    for (var i = 0; i < 24; i++) {
      horarios.add('${i.toString().padLeft(2, '0')}:00');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Tela Fatias Horários Funcionamento'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selecionandoHorarioInicio = true;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    color: selecionandoHorarioInicio ? Colors.amber : null,
                  ),
                  child: Text('Início'),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selecionandoHorarioInicio = false;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    color: selecionandoHorarioInicio ? null : Colors.amber,
                  ),
                  child: Text('Fim'),
                ),
              ),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8.0,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                  child: ListView(
                    children: horarios.take(12).map(
                      (hora) {
                        // print('hora: "${hora.substring(0, 2)}"');
                        var horaInteiro = int.parse(hora.substring(0, 2));
                        return ComponentSchedule(
                          clickContainer: () {
                            selecionarHorario(horaInteiro);
                          },
                          containerColor: getHorarioColor(horaInteiro),
                          textoHorario: '$horaInteiro:00',
                        );
                      },
                    ).toList(),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                  child: ListView(
                    children: horarios.getRange(12, 24).map(
                      (hora) {
                        // print('hora: "${hora.substring(0, 2)}"');
                        var horaInteiro = int.parse(hora.substring(0, 2));
                        return GestureDetector(
                          onTap: () => selecionarHorario(horaInteiro),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color: getHorarioColor(horaInteiro),
                              ),
                              child: Text(hora),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
