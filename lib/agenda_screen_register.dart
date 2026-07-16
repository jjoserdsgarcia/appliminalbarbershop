import 'package:appliminalbarbershop/component_schedule.dart';
import 'package:appliminalbarbershop/schedule_class.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AgendaScreenRegister extends StatefulWidget {
  const AgendaScreenRegister({
    super.key,
    required this.descricaoDia,
    required this.employeeSchedule,
  });

  // Descrição do dia (Ex.: Segunda-feira)
  final String descricaoDia;

  // Caso exista um horário já cadastrado, ele será recebido aqui
  final ScheduleClass? employeeSchedule;

  @override
  State<AgendaScreenRegister> createState() =>
      _AgendaScreenRegisterState();
}

class _AgendaScreenRegisterState extends State<AgendaScreenRegister> {
  // Horário inicial padrão
  var startTime = 0;

  // Horário final padrão
  var endTime = 23;

  // Controla se o usuário está selecionando o horário de início ou fim
  var selecionandoHorarioInicio = true;

  @override
  void initState() {
    super.initState();

    // Caso seja uma edição, carrega os horários já cadastrados
    if (widget.employeeSchedule != null) {
      startTime = widget.employeeSchedule!.startTime;
      endTime = widget.employeeSchedule!.endTime;
    }
  }

  /// Responsável por selecionar um horário.
  /// Dependendo da opção escolhida (Início/Fim),
  /// altera startTime ou endTime.
  void selecionarHorario(int horaInteiro) {
    // Selecionando horário de início
    if (selecionandoHorarioInicio) {
      // O horário inicial deve ser menor que o final
      if (horaInteiro < endTime) {
        setState(() {
          startTime = horaInteiro;
        });
      } else {
        // Exibe mensagem de erro
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog.adaptive(
              title: const Text('Atenção'),
              content: const Text(
                'Horário de início não pode ser superior ao horário de fim.',
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Fechar'),
                ),
              ],
            );
          },
        );
      }
    }

    // Selecionando horário de fim
    else {
      // O horário final deve ser maior que o inicial
      if (horaInteiro > startTime) {
        setState(() {
          endTime = horaInteiro;
        });
      } else {
        // Exibe mensagem de erro
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog.adaptive(
              title: const Text('Atenção'),
              content: const Text(
                'Horário de fim não pode ser inferior ao horário de início.',
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Fechar'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  /// Define a cor de cada horário.
  /// Verde para horários a partir do início.
  /// Vermelho para horários anteriores.
  Color? getHorarioColor(int horaInteiro) {
    return horaInteiro >= startTime ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    // Lista contendo todos os horários do dia
    final horarios = <String>[];

    for (var i = 0; i < 24; i++) {
      horarios.add('${i.toString().padLeft(2, '0')}:00');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela Fatias Horários Funcionamento'),
      ),
      body: Column(
        children: [
          // Botões para escolher se será alterado o início ou o fim
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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    color: selecionandoHorarioInicio
                        ? Colors.amber
                        : null,
                  ),
                  child: const Text('Início'),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selecionandoHorarioInicio = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    color: selecionandoHorarioInicio
                        ? null
                        : Colors.amber,
                  ),
                  child: const Text('Fim'),
                ),
              ),
            ],
          ),

          // Lista dos horários
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8.0,
              children: [
                // Horários de 00:00 até 11:00
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                  child: ListView(
                    children: horarios.take(12).map((hora) {
                      var horaInteiro =
                          int.parse(hora.substring(0, 2));

                      return ComponentSchedule(
                        clickContainer: () {
                          selecionarHorario(horaInteiro);
                        },
                        containerColor:
                            getHorarioColor(horaInteiro),
                        textoHorario: '$horaInteiro:00',
                      );
                    }).toList(),
                  ),
                ),

                // Horários de 12:00 até 23:00
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                  child: ListView(
                    children: horarios.getRange(12, 24).map((hora) {
                      var horaInteiro =
                          int.parse(hora.substring(0, 2));

                      return GestureDetector(
                        onTap: () =>
                            selecionarHorario(horaInteiro),
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: 8),
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
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Botão para salvar os horários
          ElevatedButton(
            onPressed: () async {
              final supabase = Supabase.instance.client;

              // Atualiza caso seja edição
              if (widget.employeeSchedule != null) {
                await supabase
                    .from("schedule_professional")
                    .update({
                      "start_time": startTime,
                      "end_time": endTime,
                    })
                    .eq("id", widget.employeeSchedule!.id!);
              }

              // Insere um novo registro
              else {
                await supabase
                    .from("schedule_professional")
                    .insert({
                  'description': widget.descricaoDia,
                  'start_time': startTime,
                  'end_time': endTime,
                });
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}