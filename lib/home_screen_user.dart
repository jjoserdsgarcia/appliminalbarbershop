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
      appBar: AppBar(
        title: Text("Página Principal - Bem vindo Usuário!"),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 500,
          ),
          child: ListView.builder(
            itemCount: cortes.length,
            itemBuilder: (context, index) {
              final ServiceClass currentService = cortes[index];
              return Card(
                elevation: 8.0,
                child: ListTile(
                  leading: Icon(Icons.sports_basketball),
                  title: Text(currentService.description),
                  subtitle: Text("Preço: ${currentService.price}"),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) {
                    return ProfessionalsScreenSelect();
                  },
                ),
              )
              .then(
                (value) {
                  if (value != null) {
                    print("value: $value");
                  }
                  ProfessionalsScreenSelect();
                },
              );
        },
      ),
    );
  }
}
