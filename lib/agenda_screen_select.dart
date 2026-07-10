// import 'package:appliminalbarbershop/agenda_screen_register.dart';
// import 'package:appliminalbarbershop/schedule_class.dart';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class AgendaScreenSelect extends StatefulWidget {
//   const AgendaScreenSelect({
//     super.key,
//     required this.professionalName,
//     required this.professionalId,
//     required this.serviceName,
//     required this.serviceId,
//   });

//   final String professionalName;
//   final int professionalId;
//   final String serviceName;
//   final int serviceId;

//   @override
//   State<AgendaScreenSelect> createState() => _AgendaScreenSelectState();
// }

// class _AgendaScreenSelectState extends State<AgendaScreenSelect> {
//   final List<String> diasSemana = [
//     "Domingo",
//     "Segunda",
//     "Terça",
//     "Quarta",
//     "Quinta",
//     "Sexta",
//     "Sábado",
//   ];
//   var employeeSchedule = <ScheduleClass>[];
//   var isLoading = false;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     searchSchedule();
//   }

//   void searchSchedule() async {
//     setState(() {
//       isLoading = true;
//     });
//     employeeSchedule.clear();
//     final supabase = Supabase.instance.client;
//     var registrosSupabase = await supabase.from("schedule_professional").select();
//     setState(() {
//       employeeSchedule = registrosSupabase.map((e) {
//         return ScheduleClass(
//           id: e['id'],
//           description: e['description'],

//           startTime: e['start_time'],
//           endTime: e['end_time'],
//         );
//       }).toList();
//       isLoading = false;
//     });
//   }

//   bool verifyRegisterSchedule(String descricaoDia) {
//     return employeeSchedule.indexWhere((element) => element.description == descricaoDia) != -1;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tela Horários Funcionamento'),
//       ),
//       body: isLoading
//           ? Center(
//               child: Column(
//                 children: [CircularProgressIndicator.adaptive(), Text('Seus dados estão sendo carregados...')],
//               ),
//             )
//           : SizedBox(
//               width: MediaQuery.of(context).size.width * 0.35,
//               child: ListView.builder(
//                 itemCount: diasSemana.length,
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () {
//                       var i = employeeSchedule.indexWhere((element) => element.description == diasSemana[index]);
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) {
//                             return AgendaScreenRegister(
//                               descricaoDia: diasSemana[index],
//                               employeeSchedule: i != -1 ? employeeSchedule[i] : null,
//                             );
//                           },
//                         ),
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: verifyRegisterSchedule(diasSemana[index]) ? Colors.green : Colors.red,
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         height: MediaQuery.of(context).size.height * 0.1,
//                         child: Center(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 diasSemana[index],
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                 ),
//                               ),
//                               verifyRegisterSchedule(diasSemana[index]) ? Icon(Icons.check) : Icon(Icons.cancel),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//     );
//   }
// }
