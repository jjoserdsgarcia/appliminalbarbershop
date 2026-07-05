import 'package:appliminalbarbershop/services_screen_select.dart';
import 'package:appliminalbarbershop/user_class.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfessionalsScreenSelect extends StatefulWidget {
  const ProfessionalsScreenSelect({super.key});

  @override
  State<ProfessionalsScreenSelect> createState() =>
      _ProfessionalsScreenSelectState();
}

class _ProfessionalsScreenSelectState extends State<ProfessionalsScreenSelect> {

  List<UserClass> professionals = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchProfessionals();
  }


void searchProfessionals() async {
    final supabase = Supabase.instance.client;
    final professionalsSupabase = await supabase
        .from("user") //
        .select()
        .eq("is_employee", true);
    setState(() {
      professionals = professionalsSupabase.map(
        (e) {
          return UserClass(id: e["id"], login: e["login"], isEmployee: e["is_employee"], password: e["password"], fullName: e["full_name"]);
        },
      ).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Funcionarios Disponíveis"),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 300,
           
          ),
          child: ListView.builder(
            itemCount: professionals.length,
            itemBuilder: (context, index) {
              final UserClass currentProfessionals = professionals[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ServicesScreenSelect(professionalName: currentProfessionals.fullName, professionalId: currentProfessionals.id);
                      },
                    ),
                  );
                },
                child: Card(
                  elevation: 8.0,
                  child: ListTile(
                    leading: Icon(Icons.sports_basketball),
                    title: Text(currentProfessionals.fullName),
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
