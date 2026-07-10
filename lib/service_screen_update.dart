import 'package:appliminalbarbershop/service_class.dart';
import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateServicesScreen extends StatefulWidget {
  const UpdateServicesScreen({super.key, this.serviceName, this.serviceDescription, this.servicePrice, this.serviceActive, this.serviceId});

  final String? serviceName;
  final String? serviceDescription;
  final double? servicePrice;
  final bool? serviceActive;
  final int? serviceId;

  @override
  State<UpdateServicesScreen> createState() => _UpdateServicesScreenState();
}

class _UpdateServicesScreenState extends State<UpdateServicesScreen> {
  List<ServiceClass> services = [];
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;

  late final TextEditingController priceController;

  late final TextEditingController descriptionController;

  bool isLoading = false;

  bool ativo = true;

  @override
  initState() {
    super.initState();
    nameController = TextEditingController(text: widget.serviceName ?? '');
    priceController = TextEditingController(text: widget.servicePrice?.toString() ?? '');
    descriptionController = TextEditingController(text: widget.serviceDescription ?? '');
    ativo = widget.serviceActive ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Serviço"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Form(
          key: formKey,

          child: Column(
            children: [
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

              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "Descrição",
                ),
                maxLines: 3,
              ),

              SwitchListTile(
                title: Text("Ativo"),
                value: ativo,
                onChanged: (bool value) {
                  setState(() {
                    ativo = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  if (formKey.currentState!.validate()) {
                    try {
                      final supabase = Supabase.instance.client;
                      final servicesSupabase = await supabase
                          .from("service") //
                          .update({
                            "name": nameController.text,
                            "description": descriptionController.text,
                            "price": (double.parse(priceController.text) * 100).toInt(),
                            "active": ativo,
                          })
                          .eq("id", widget.serviceId.toString());

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Cadastro de serviço realizado com sucesso!",
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );

                      Navigator.of(context).pop();
                    } on PostgrestException catch (e) {
                      if (e.code == "23505") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Serviço já cadastrado"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      print(e);
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

                child: const Text("Editar"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
