import 'package:appliminalbarbershop/services_screen_select.dart';
import 'package:appliminalbarbershop/user_class.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Tela para seleção do profissional (barbeiro)
class ProfessionalsScreenSelect extends StatefulWidget {
  const ProfessionalsScreenSelect({super.key});

  @override
  State<ProfessionalsScreenSelect> createState() =>
      _ProfessionalsScreenSelectState();
}

class _ProfessionalsScreenSelectState
    extends State<ProfessionalsScreenSelect> {
  // Lista de profissionais cadastrados
  List<UserClass> professionals = [];

  // Controla o carregamento da tela
  bool isLoading = true;

  // Mensagem de erro caso ocorra alguma falha
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    // Busca os profissionais ao abrir a tela
    searchProfessionals();
  }

  /// Busca todos os funcionários cadastrados no banco de dados
  Future<void> searchProfessionals() async {
    final supabase = Supabase.instance.client;

    try {
      // Consulta apenas usuários que são funcionários
      final professionalsSupabase = await supabase
          .from("user")
          .select()
          .eq("is_employee", true);

      // Verifica se a tela ainda está ativa
      if (!mounted) return;

      setState(() {
        // Converte os registros em objetos UserClass
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
      // Verifica se a tela ainda está ativa
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
      // Cor de fundo da aplicação
      backgroundColor: const Color(0xFF121212),

      // Barra superior
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1C1C1C),
        centerTitle: true,

        // Título da tela
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

            // Subtítulo
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

      // Corpo da tela
      body: Container(
        decoration: BoxDecoration(
          // Imagem de fundo
          image: DecorationImage(
            image: const AssetImage(
              "assets/images/barber_backrooms.jpg",
            ),
            fit: BoxFit.cover,

            // Escurece a imagem para melhorar a leitura
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: .82),
              BlendMode.darken,
            ),
          ),
        ),

        child: Center(
          child: ConstrainedBox(
            // Limita a largura máxima da lista
            constraints: const BoxConstraints(maxWidth: 700),

            child: Builder(
              builder: (context) {
                // Exibe indicador de carregamento
                if (isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFD6B35A),
                    ),
                  );
                }

                // Exibe mensagem de erro
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

                // Caso não existam profissionais
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

                // Lista de profissionais
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: professionals.length,

                  itemBuilder: (context, index) {
                    // Profissional atual
                    final UserClass currentProfessional =
                        professionals[index];

                    return GestureDetector(
                      // Abre a próxima tela ao selecionar um barbeiro
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
                        margin:
                            const EdgeInsets.only(bottom: 18),

                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),

                          borderRadius:
                              BorderRadius.circular(18),

                          border: Border.all(
                            color:
                                const Color(0xFFD6B35A),
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withValues(alpha: .35),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),

                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.all(18),

                          // Avatar do profissional
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

                          // Nome do profissional
                          title: Text(
                            currentProfessional.fullName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          // Descrição do profissional
                          subtitle: Padding(
                            padding:
                                const EdgeInsets.only(
                                    top: 8),

                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [
                                Text(
                                  currentProfessional
                                      .description,
                                  style: const TextStyle(
                                    color:
                                        Colors.white70,
                                  ),
                                ),

                                const SizedBox(
                                    height: 10),
                              ],
                            ),
                          ),

                          // Ícone indicando navegação
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color:
                                Color(0xFFD6B35A),
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