import 'package:appliminalbarbershop/professionals_screen_select.dart';
import 'package:appliminalbarbershop/service_class.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Tela inicial do cliente
/// Exibe todos os serviços disponíveis para agendamento.
class HomeScreenUser extends StatefulWidget {
  const HomeScreenUser({super.key});

  @override
  State<HomeScreenUser> createState() => _HomeScreenUserState();
}

class _HomeScreenUserState extends State<HomeScreenUser> {
  // Lista que armazenará os serviços cadastrados
  List<ServiceClass> cortes = [];

  @override
  void initState() {
    super.initState();

    // Busca os serviços ao abrir a tela
    searchServices();
  }

  /// Busca todos os serviços cadastrados no banco de dados
  void searchServices() async {
    final supabase = Supabase.instance.client;

    // Consulta a tabela de serviços
    final servicesSupabase = await supabase.from("service").select();

    // Atualiza a lista de serviços
    setState(() {
      cortes = servicesSupabase.map(
        (e) {
          return ServiceClass(
            id: e["id"],
            name: e["name"],
            description: e["description"],
            // O preço está armazenado em centavos
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
              "LIMINAL BARBERSHOP",
              style: TextStyle(
                color: Color(0xFFD6B35A),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 4),

            // Subtítulo
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

      // Corpo da tela
      body: Container(
        decoration: BoxDecoration(
          // Imagem de fundo
          image: DecorationImage(
            image: const AssetImage(
              "assets/images/barber_backrooms.jpg",
            ),
            fit: BoxFit.cover,

            // Escurece a imagem para destacar o conteúdo
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

            // Lista de serviços
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: cortes.length,

              itemBuilder: (context, index) {
                // Serviço atual
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
                        color: Colors.black.withValues(alpha: .35),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),

                  child: ListTile(
                    contentPadding: const EdgeInsets.all(18),

                    // Ícone do serviço
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

                    // Nome/descrição do serviço
                    title: Text(
                      currentService.description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Informações adicionais
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Preço do serviço
                          Text(
                            "R\$ ${currentService.price.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Color(0xFFD6B35A),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          // Mensagem informativa
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

      // Botão para iniciar um agendamento
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
          // Navega para a tela de seleção de profissionais
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) {
                    return ProfessionalsScreenSelect();
                  },
                ),
              )
              .then((value) {
                // Recebe o retorno da próxima tela
                if (value != null) {
                  print("value: $value");
                }
              });
        },
      ),
    );
  }
}
