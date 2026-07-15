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
            "Escolha seu Barbeiro",
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

          child: Builder(
            builder: (context) {

              if (isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFD6B35A),
                  ),
                );
              }

              if (errorMessage != null) {
                return Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                );
              }

              if (professionals.isEmpty) {
                return const Center(
                  child: Text(
                    "Nenhum barbeiro disponível.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: professionals.length,
                itemBuilder: (context, index) {

                  final UserClass currentProfessional =
                      professionals[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ServicesScreenSelect(
                            professionalName:
                                currentProfessional.fullName,
                            professionalId:
                                currentProfessional.id,
                          ),
                        ),
                      );
                    },

                    child: Container(
                      margin: const EdgeInsets.only(bottom: 18),

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

                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              const Color(0xFFD6B35A),

                          child: const Icon(
                            Icons.person,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),

                        title: Text(
                          currentProfessional.fullName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Padding(
                          padding:
                              const EdgeInsets.only(top: 8),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              Text(
                                currentProfessional.description,
                                style: const TextStyle(
                                  color: Colors.white70,
                                ),
                              ),

                              const SizedBox(height: 10),

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
              );
            },
          ),
        ),
      ),
    ),
  );
}
}