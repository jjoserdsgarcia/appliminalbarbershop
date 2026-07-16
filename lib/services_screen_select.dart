import 'package:appliminalbarbershop/agenda_screen_register.dart';
import 'package:appliminalbarbershop/agenda_screen_select.dart';
import 'package:appliminalbarbershop/service_class.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ServicesScreenSelect extends StatefulWidget {
  const ServicesScreenSelect({super.key, required this.professionalName, required this.professionalId});

  final String professionalName;
  final int professionalId;

  @override
  State<ServicesScreenSelect> createState() => _ServicesScreenSelectState();
}

class _ServicesScreenSelectState extends State<ServicesScreenSelect> {
  List<ServiceClass> services = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchServices();
  }

  void searchServices() async {
    final supabase = Supabase.instance.client;
    final servicesSupabase = await supabase
        .from("service") //
        .select();
    setState(() {
      services = servicesSupabase.map(
        (e) {
          return ServiceClass(
            id: e["id"],
            name: e["name"],
            description: e["description"],
            price: (e["price"] / 100),
            active: e["active"],
          );
        },
      ).toList();
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF121212),

    appBar: AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF1C1C1C),
      centerTitle: true,
      title: const Column(
        children: [
          Text(
            "BACKROOM BARBERSHOP",
            style: TextStyle(
              color: Color(0xFFD6B35A),
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Escolha um Serviço",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    ),

    body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage(
            "assets/images/barber_backrooms.jpg",
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(.82),
            BlendMode.darken,
          ),
        ),
      ),

      child: Column(
        children: [

          /// BARBEIRO SELECIONADO
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFD6B35A),
              ),
            ),
            child: Row(
              children: [

                CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFFD6B35A),
                  child: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Barbeiro Selecionado",
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        widget.professionalName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),
                ),

                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                )

              ],
            ),
          ),

          /// SERVIÇOS
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              itemCount: services.length,
              itemBuilder: (context, index) {

                final currentService = services[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AgendaScreenRegister(
                          descricaoDia: "",
                          employeeSchedule: null,
                        ),
                      ),
                    );
                  },

                  child: Container(
                    margin:
                        const EdgeInsets.only(bottom: 18),

                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius:
                          BorderRadius.circular(18),

                      border: Border.all(
                        color: const Color(0xFFD6B35A),
                      ),

                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.withOpacity(.35),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),

                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.all(18),

                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFD6B35A),
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.content_cut,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),

                      title: Text(
                        currentService.description,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      subtitle: Padding(
                        padding:
                            const EdgeInsets.only(
                                top: 8),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            Text(
                              "R\$ ${currentService.price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: Color(
                                    0xFFD6B35A),
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            const Text(
                              "Toque para escolher este serviço.",
                              style: TextStyle(
                                color: Colors.white60,
                              ),
                            ),

                          ],
                        ),
                      ),

                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFFD6B35A),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
}