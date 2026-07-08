import 'package:appliminalbarbershop/service_class.dart';
import 'package:appliminalbarbershop/service_screen_register.dart';
import 'package:appliminalbarbershop/service_screen_update.dart';
import 'package:appliminalbarbershop/widget_draweradmin.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
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
      drawer: LateralMenuEmployee(),
      appBar: AppBar(
        title: Text("Serviços registrados"),
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
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: ((context) {
                            return UpdateServicesScreen(
                              serviceId: currentService.id,
                              serviceName: currentService.name,
                              serviceDescription: currentService.description,
                              servicePrice: currentService.price,
                              serviceActive: currentService.active,
                            );
                          }),
                        ),
                      )
                      .then(
                        (value) {
                          searchServices();
                        },
                      );
                },
                child: Card(
                  elevation: 8.0,
                  child: ListTile(
                    leading: Icon(Icons.shop),
                    title: Text(currentService.name),
                    subtitle: Text("Preço: ${currentService.price}"),
                  ),
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
                    return RegisterServicesScreen();
                  },
                ),
              )
              .then(
                (value) {
                  searchServices();
                },
              );
        },
      ),
    );
  }
}
