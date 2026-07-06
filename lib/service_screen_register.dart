import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

/// =======================================================
/// TELA DE CADASTRO DE SERVIÇOS
/// Responsável por registrar novos serviços no banco
/// de dados (Supabase).
/// =======================================================
class RegisterServicesScreen extends StatefulWidget {
  const RegisterServicesScreen({super.key});

  @override
  State<RegisterServicesScreen> createState() =>
      _RegisterServicesScreenState();
}

class _RegisterServicesScreenState extends State<RegisterServicesScreen> {

  // =======================================================
  // FORMULÁRIO
  // =======================================================

  /// Chave responsável por validar o formulário
  final formKey = GlobalKey<FormState>();

  // =======================================================
  // CONTROLLERS DOS CAMPOS
  // =======================================================

  /// Nome do serviço
  final nameController = TextEditingController();

  /// Preço do serviço
  final priceController = TextEditingController();

  /// Descrição do serviço
  final descriptionController = TextEditingController();

  /// Status do serviço (não utilizado atualmente)
  bool ativo = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // =======================================================
      // APP BAR
      // =======================================================
      appBar: AppBar(
        title: const Text("Registrar Serviço"),
      ),

      // =======================================================
      // CORPO DA TELA
      // =======================================================
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Form(
          key: formKey,

          child: Column(
            children: [

              // =======================================================
              // CAMPO - NOME DO SERVIÇO
              // =======================================================
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Nome do Serviço",
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira o nome do serviço";
                  }
                  return null;
                },
              ),

              // =======================================================
              // CAMPO - PREÇO
              // =======================================================
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: "Preço",
                ),

                keyboardType: TextInputType.number,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira o preço";
                  }

                  if (double.tryParse(value) == null) {
                    return "Por favor, insira um número válido";
                  }

                  return null;
                },
              ),

              // =======================================================
              // CAMPO - DESCRIÇÃO
              // =======================================================
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "Descrição",
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 20),

              // =======================================================
              // BOTÃO DE REGISTRO
              // =======================================================
              ElevatedButton(

                onPressed: () async {

                  // Verifica se todos os campos estão válidos
                  if (formKey.currentState!.validate()) {

                    try {

                      // =======================================================
                      // CONEXÃO COM O SUPABASE
                      // =======================================================
                      final supabase = Supabase.instance.client;

                      // =======================================================
                      // INSERÇÃO DOS DADOS NO BANCO
                      // =======================================================
                      await supabase.from('service').insert({
                        'name': nameController.text,
                        'description': descriptionController.text,
                        'price': priceController.text,
                      });

                      // =======================================================
                      // MENSAGEM DE SUCESSO
                      // =======================================================
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Cadastro de serviço realizado com sucesso!",
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );

                      // Retorna para a tela anterior
                      Navigator.of(context).pop();

                    }

                    // =======================================================
                    // ERRO DE DUPLICIDADE (CHAVE ÚNICA)
                    // =======================================================
                    on PostgrestException catch (e) {

                      if (e.code == "23505") {

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Serviço já cadastrado"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }

                    }

                    // =======================================================
                    // OUTROS ERROS
                    // =======================================================
                    catch (e) {

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Falha ao realizar cadastro de serviço",
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );

                    }

                  }

                },

                child: const Text("Registrar"),
              ),

            ],
          ),
        ),
      ),
    );
  }

  // =======================================================
  // LIBERAÇÃO DOS CONTROLLERS
  // Evita vazamento de memória.
  // =======================================================
  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}