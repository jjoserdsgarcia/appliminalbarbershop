import 'package:appliminalbarbershop/home_screen_employee.dart';
import 'package:appliminalbarbershop/login_screen.dart';
import 'package:appliminalbarbershop/services_showroom.dart';
import 'package:flutter/material.dart';

class LateralMenuEmployee extends StatelessWidget {
  const LateralMenuEmployee({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 280,
      backgroundColor: const Color(0xFF121212),

      child: Column(
        children: [
          // CABEÇALHO
          Container(
            width: double.infinity,
            height: 250,
            padding: const EdgeInsets.fromLTRB(20, 45, 20, 20),
            decoration: const BoxDecoration(
              color: Color(0xFF1C1C1C),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6B35A),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.content_cut,
                    size: 32,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  "LIMINAL",
                  style: TextStyle(
                    color: Color(0xFFD6B35A),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 2),

                const Text(
                  "BARBERSHOP",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Painel do Funcionário",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const Divider(
            color: Color(0xFFD6B35A),
            height: 1,
          ),

          ListTile(
            leading: const Icon(
              Icons.home_rounded,
              color: Color(0xFFD6B35A),
            ),
            title: const Text(
              "Home",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HomeScreenEmployee(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(
              Icons.content_cut,
              color: Color(0xFFD6B35A),
            ),
            title: const Text(
              "Serviços",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ServicesScreen(),
                ),
              );
            },
          ),

          const Spacer(),

          const Divider(
            color: Color(0xFFD6B35A),
          ),

          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.redAccent,
            ),
            title: const Text(
              "Sair",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LoginScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
