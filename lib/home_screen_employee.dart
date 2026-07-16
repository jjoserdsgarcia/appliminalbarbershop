import 'package:appliminalbarbershop/widget_draweradmin.dart';
import 'package:flutter/material.dart';

class HomeScreenEmployee extends StatefulWidget {
  const HomeScreenEmployee({super.key});

  @override
  State<HomeScreenEmployee> createState() => _HomeScreenEmployeeState();
}

class _HomeScreenEmployeeState extends State<HomeScreenEmployee> {
 @override
Widget build(BuildContext context) {
  return Scaffold(
    drawer: LateralMenuEmployee(),
    backgroundColor: const Color(0xFF121212),

    appBar: AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF1C1C1C),
      iconTheme: const IconThemeData(
        color: Color(0xFFD6B35A),
      ),
      centerTitle: true,
      title: const Text(
        "LIMINAL BARBERSHOP",
        style: TextStyle(
          color: Color(0xFFD6B35A),
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    ),

    body: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage(
            "assets/images/barber_backrooms.jpg",
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black87,
            BlendMode.darken,
          ),
        ),
      ),

      child: Center(
        child: Container(
          width: 650,
          padding: const EdgeInsets.all(35),

          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E).withOpacity(.92),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFD6B35A),
              width: 1.5,
            ),
          ),

          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Icon(
                Icons.content_cut,
                size: 80,
                color: Color(0xFFD6B35A),
              ),

              SizedBox(height: 25),

              Text(
                "Painel do Funcionário",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 15),

              Text(
                "Utilize o menu lateral para acessar os horários disponíveis, gerenciar os serviços e navegar pelas funcionalidades do sistema.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.6,
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