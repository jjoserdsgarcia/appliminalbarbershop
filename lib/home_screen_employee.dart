import 'package:appliminalbarbershop/widget_draweradmin.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Tela inicial do funcionário
class HomeScreenEmployee extends StatefulWidget {
  const HomeScreenEmployee({super.key});

  @override
  State<HomeScreenEmployee> createState() => _HomeScreenEmployeeState();
}

class _HomeScreenEmployeeState extends State<HomeScreenEmployee> {
  final SupabaseClient supabase = Supabase.instance.client;

  List<Map<String, dynamic>> _appointments = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    try {
      final response = await supabase
          .from('appointments')
          .select()
          .eq('status', 'scheduled')
          .order('appointment_date', ascending: true)
          .order('appointment_time', ascending: true);

      setState(() {
        _appointments = List<Map<String, dynamic>>.from(response);
        _loading = false;
      });
    } catch (e) {
      debugPrint("Erro: $e");

      setState(() {
        _loading = false;
      });
    }
  }

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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
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
              color: const Color(0xFF1E1E1E).withValues(alpha: .92),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFD6B35A),
                width: 1.5,
              ),
            ),

            child: Column(
              children: [
                const Icon(
                  Icons.content_cut,
                  size: 80,
                  color: Color(0xFFD6B35A),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Painel do Funcionário",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                if (_loading)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFD6B35A),
                      ),
                    ),
                  )
                else if (_appointments.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Nenhum agendamento encontrado.",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: _appointments.length,
                      itemBuilder: (context, index) {
                        final appointment = _appointments[index];

                        return Card(
                          color: const Color(0xFF1C1C1C),
                          margin: const EdgeInsets.only(bottom: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(
                              color: Color(0xFFD6B35A),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appointment['customer_name'],
                                  style: const TextStyle(
                                    color: Color(0xFFD6B35A),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  "Profissional: ${appointment['professional_name']}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  "Serviço: ${appointment['service_description']}",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  "Telefone: ${appointment['customer_phone']}",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  "Data: ${appointment['appointment_date']}",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  "Horário: ${appointment['appointment_time']}",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  "Valor: R\$ ${appointment['service_price']}",
                                  style: const TextStyle(
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  "Status: ${appointment['status']}",
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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