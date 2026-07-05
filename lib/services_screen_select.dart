import 'package:appliminalbarbershop/agenda_screen_select.dart';
import 'package:appliminalbarbershop/service_class.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ServicesScreenSelect extends StatefulWidget {
  const ServicesScreenSelect({super.key});

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
          );
        },
      ).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Serviços Disponíveis"),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 500,
          ),
          child: ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              final ServiceClass currentService = services[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return AgendaScreenSelect();
                      },
                    ),
                  );
                },
                child: Card(
                  elevation: 8.0,
                  child: ListTile(
                    leading: Icon(Icons.sports_basketball),
                    title: Text(currentService.description),
                    subtitle: Text("Preço: ${currentService.price}"),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
