import 'package:appliminalbarbershop/agenda_screen_select.dart';
import 'package:appliminalbarbershop/service_class.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Tela responsável por exibir os serviços disponíveis
/// para o barbeiro selecionado.
class ServicesScreenSelect extends StatefulWidget {
  const ServicesScreenSelect({
    super.key,
    required this.professionalName,
    required this.professionalId,
  });

  // Nome do barbeiro selecionado
  final String professionalName;

  // ID do barbeiro selecionado
  final int professionalId;

  @override
  State<ServicesScreenSelect> createState() => _ServicesScreenSelectState();
}

class _ServicesScreenSelectState extends State<ServicesScreenSelect> {
  // Lista de serviços disponíveis
  List<ServiceClass> services = [];

  @override
  void initState() {
    super.initState();

    // Busca os serviços cadastrados
    searchServices();
  }

  /// Busca todos os serviços no Supabase
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
      // Cor de fundo
      backgroundColor: const Color(0xFF121212),

      // Barra superior
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
              "Escolha um Serviço",
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
          image: DecorationImage(
            image: const AssetImage(
              "assets/images/barber_backrooms.jpg",
            ),
            fit: BoxFit.cover,

            // Escurece o fundo
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: .82),
              BlendMode.darken,
            ),
          ),
        ),

        child: Column(
          children: [
            //----------------------------------------------------
            // Card do barbeiro selecionado
            //----------------------------------------------------
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),

                borderRadius: BorderRadius.circular(18),

                border: Border.all(
                  color: const Color(0xFFD6B35A),
                ),
              ),

              child: Row(
                children: [
                  // Ícone do barbeiro
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(0xFFD6B35A),

                    child: const Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Text(
                          "Barbeiro Selecionado",
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 5),

                        // Nome do barbeiro
                        Text(
                          widget.professionalName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Ícone indicando seleção
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                ],
              ),
            ),

            //----------------------------------------------------
            // Lista de serviços
            //----------------------------------------------------
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),

                itemCount: services.length,

                itemBuilder: (context, index) {
                  final currentService = services[index];

                  return GestureDetector(
                    // Ao selecionar um serviço,
                    // abre a tela de agenda
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AgendaScreenSelect(
                            professionalId: widget.professionalId,
                            professionalName: widget.professionalName,
                            serviceId: currentService.id,
                            serviceDescription: currentService.description,
                            servicePrice: currentService.price,
                          ),
                        ),
                      );
                    },

                    child: Container(
                      margin: const EdgeInsets.only(bottom: 18),

                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),

                        borderRadius: BorderRadius.circular(18),

                        border: Border.all(
                          color: const Color(0xFFD6B35A),
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
                          padding: const EdgeInsets.only(top: 8),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              // Preço
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
                                "Toque para escolher este serviço.",
                                style: TextStyle(
                                  color: Colors.white60,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Ícone indicando navegação
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFFD6B35A),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
