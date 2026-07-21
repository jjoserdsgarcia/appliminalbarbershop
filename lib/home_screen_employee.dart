import 'package:appliminalbarbershop/widget_draweradmin.dart';
import 'package:flutter/material.dart';

/// Tela inicial do funcionário
class HomeScreenEmployee extends StatefulWidget {
  const HomeScreenEmployee({super.key});

  @override
  State<HomeScreenEmployee> createState() => _HomeScreenEmployeeState();
}

class _HomeScreenEmployeeState extends State<HomeScreenEmployee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menu lateral da aplicação
      drawer: LateralMenuEmployee(),

      // Cor de fundo principal
      backgroundColor: const Color(0xFF121212),

      // Barra superior
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1C1C1C),

        // Cor do ícone do menu
        iconTheme: const IconThemeData(
          color: Color(0xFFD6B35A),
        ),

        // Centraliza o título
        centerTitle: true,

        // Nome da barbearia
        title: const Text(
          "LIMINAL BARBERSHOP",
          style: TextStyle(
            color: Color(0xFFD6B35A),
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),

      // Corpo da tela
      body: Container(
        width: double.infinity,

        // Imagem de fundo da tela
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/barber_backrooms.jpg",
            ),

            // Faz a imagem ocupar toda a tela
            fit: BoxFit.cover,

            // Escurece a imagem para melhorar a leitura
            colorFilter: ColorFilter.mode(
              Colors.black87,
              BlendMode.darken,
            ),
          ),
        ),

        // Centraliza o painel
        child: Center(
          child: Container(
            // Largura fixa do painel
            width: 650,

            // Espaçamento interno
            padding: const EdgeInsets.all(35),

            // Estilo do painel
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E).withValues(alpha: .92),

              borderRadius: BorderRadius.circular(20),

              border: Border.all(
                color: const Color(0xFFD6B35A),
                width: 1.5,
              ),
            ),

            // Conteúdo do painel
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ícone representando a barbearia
                Icon(
                  Icons.content_cut,
                  size: 80,
                  color: Color(0xFFD6B35A),
                ),

                SizedBox(height: 25),

                // Título da tela
                Text(
                  "Painel do Funcionário",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 15),

                // Texto explicativo
                Card(
                  color: Color(0xFF1C1C1C),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Bem-vindo ao painel do funcionário da Liminal Barbershop! Aqui você pode gerenciar seus horários, visualizar agendamentos e muito mais. Use o menu lateral para navegar pelas diferentes funcionalidades.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
