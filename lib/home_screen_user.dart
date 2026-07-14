import 'package:appliminalbarbershop/professionals_screen_select.dart';
import 'package:appliminalbarbershop/service_class.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreenUser extends StatefulWidget {
  const HomeScreenUser({super.key});

  @override
  State<HomeScreenUser> createState() => _HomeScreenUserState();
}

class _HomeScreenUserState extends State<HomeScreenUser> {
  List<ServiceClass> cortes = [];

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
      cortes = servicesSupabase.map(
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Escolha um serviço",
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
          image: const AssetImage("assets/images/barber_backrooms.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(.82),
            BlendMode.darken,
          ),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: cortes.length,
            itemBuilder: (context, index) {
              final currentService = cortes[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFD6B35A),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.35),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(18),

                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6B35A),
                      borderRadius: BorderRadius.circular(15),
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "R\$ ${currentService.price.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Color(0xFFD6B35A),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Serviço disponível para agendamento.",
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ),

    floatingActionButton: FloatingActionButton.extended(
      backgroundColor: const Color(0xFFD6B35A),
      foregroundColor: Colors.black,
      icon: const Icon(Icons.calendar_month),
      label: const Text(
        "Agendar",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (context) {
              return ProfessionalsScreenSelect();
            },
          ),
        )
            .then((value) {
          if (value != null) {
            print("value: $value");
          }
        });
      },
    ),
  );
}
}