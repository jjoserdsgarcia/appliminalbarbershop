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
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    searchProfessionals();
  }

  Future<void> searchProfessionals() async {
    final supabase = Supabase.instance.client;
    try {
      final professionalsSupabase = await supabase
          .from("user")
          .select()
          .eq("is_employee", true);

      if (!mounted) return;

      setState(() {
        professionals = professionalsSupabase.map((e) {
          return UserClass(
            id: e["id"],
            login: e["login"],
            isEmployee: e["is_employee"],
            password: e["password"],
            fullName: e["full_name"] ?? "",
            description: e["description"] ?? "",
          );
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = "Erro ao buscar profissionais: $e";
        isLoading = false;
      });
      debugPrint("Erro ao buscar profissionais: $e");
    }
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
          child: Builder(
            builder: (context) {
              if (isLoading) {
                return const CircularProgressIndicator();
              }

              if (errorMessage != null) {
                return Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                );
              }

              if (professionals.isEmpty) {
                return const Text("Nenhum profissional encontrado.");
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: professionals.length,
                itemBuilder: (context, index) {
                  final UserClass currentProfessionals = professionals[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return ServicesScreenSelect(
                              professionalName: currentProfessionals.fullName,
                              professionalId: currentProfessionals.id,
                            );
                          },
                        ),
                      );
                    },
                    child: Card(
                      elevation: 8.0,
                      child: ListTile(
                        leading: Icon(Icons.sports_basketball),
                        title: Text(currentProfessionals.fullName),
                        subtitle: Text(currentProfessionals.description),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}