import 'package:appliminalbarbershop/agenda_screen_register_admin.dart';
import 'package:appliminalbarbershop/home_screen_employee.dart';
import 'package:appliminalbarbershop/services_showroom.dart';
import 'package:flutter/material.dart';

class LateralMenuEmployee extends StatelessWidget {
  const LateralMenuEmployee({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu do Funcionário',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return HomeScreenEmployee();
                  },
                ),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.history),
            title: Text('Horários Disponíveis'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return AgendaScreenRegisterAdmin();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Serviços'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return ServicesScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
