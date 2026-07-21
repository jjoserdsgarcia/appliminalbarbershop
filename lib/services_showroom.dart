import 'package:appliminalbarbershop/service_class.dart';
import 'package:appliminalbarbershop/service_screen_register.dart';
import 'package:appliminalbarbershop/service_screen_update.dart';
import 'package:appliminalbarbershop/widget_draweradmin.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Tela responsável por listar, cadastrar e editar os serviços.
class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  // Lista de serviços cadastrados
  List<ServiceClass> services = [];

  @override
  void initState() {
    super.initState();

    // Busca os serviços ao abrir a tela
    searchServices();
  }

  /// Busca todos os serviços cadastrados no Supabase
  void searchServices() async {
    final supabase = Supabase.instance.client;

    final servicesSupabase = await supabase.from("service").select();

    setState(() {
      services = servicesSupabase.map(
        (e) {
          return ServiceClass(
            id: e["id"],
            name: e["name"],
            description: e["description"],

            // O preço é armazenado em centavos
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
      // Menu lateral
      drawer: LateralMenuEmployee(),

      // Cor de fundo
      backgroundColor: const Color(0xFF121212),

      // Barra superior
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1C1C1C),
        foregroundColor: const Color(0xFFD6B35A),
        centerTitle: true,

        title: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "LIMINAL BARBERSHOP",
              style: TextStyle(
                color: Color(0xFFD6B35A),
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),

            SizedBox(height: 4),

            Text(
              "Gerenciar Serviços",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),

      // Corpo da tela
      body: Stack(
        children: [
          //--------------------------------------------------
          // Imagem de fundo
          //--------------------------------------------------
          Positioned.fill(
            child: Image.asset(
              "assets/images/barber_backrooms.jpg",
              fit: BoxFit.cover,
            ),
          ),

          //--------------------------------------------------
          // Camada escura sobre a imagem
          //--------------------------------------------------
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.82),
            ),
          ),

          //--------------------------------------------------
          // Lista de serviços
          //--------------------------------------------------
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 750),

              child: ListView.builder(
                padding: const EdgeInsets.all(20),

                itemCount: services.length,

                itemBuilder: (context, index) {
                  final currentService = services[index];

                  return GestureDetector(
                    // Abre a tela de edição
                    onTap: () {
                      Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder: (_) => UpdateServicesScreen(
                                serviceId: currentService.id,

                                serviceName: currentService.name,

                                serviceDescription: currentService.description,

                                servicePrice: currentService.price,

                                serviceActive: currentService.active,
                              ),
                            ),
                          )
                          .then((_) {
                            // Atualiza a lista ao retornar
                            searchServices();
                          });
                    },

                    child: Container(
                      margin: const EdgeInsets.only(
                        bottom: 18,
                      ),

                      padding: const EdgeInsets.all(18),

                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E).withValues(alpha: 0.92),

                        borderRadius: BorderRadius.circular(18),

                        border: Border.all(
                          color: const Color(0xFFD6B35A),
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .45),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),

                      child: Row(
                        children: [
                          //--------------------------------------------------
                          // Ícone do serviço
                          //--------------------------------------------------
                          Container(
                            width: 65,
                            height: 65,

                            decoration: BoxDecoration(
                              color: const Color(0xFFD6B35A),

                              borderRadius: BorderRadius.circular(15),
                            ),

                            child: const Icon(
                              Icons.content_cut,
                              color: Colors.black,
                              size: 32,
                            ),
                          ),

                          const SizedBox(width: 18),

                          //--------------------------------------------------
                          // Informações do serviço
                          //--------------------------------------------------
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                // Nome
                                Text(
                                  currentService.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // Descrição
                                Text(
                                  currentService.description,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Preço
                                Text(
                                  "R\$ ${currentService.price.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    color: Color(0xFFD6B35A),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //--------------------------------------------------
                          // Ícone de edição
                          //--------------------------------------------------
                          const Icon(
                            Icons.edit_rounded,
                            color: Color(0xFFD6B35A),
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),

      //--------------------------------------------------
      // Botão para cadastrar novo serviço
      //--------------------------------------------------
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFD6B35A),

        foregroundColor: Colors.black,

        icon: const Icon(Icons.add),

        label: const Text(
          "Novo Serviço",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (_) => const RegisterServicesScreen(),
                ),
              )
              .then((_) {
                // Atualiza a lista após cadastrar
                searchServices();
              });
        },
      ),
    );
  }
}
