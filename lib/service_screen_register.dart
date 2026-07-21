import 'package:appliminalbarbershop/service_class.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Tela de cadastro de serviços
class RegisterServicesScreen extends StatefulWidget {
  const RegisterServicesScreen({
    super.key,
    this.serviceName,
    this.serviceDescription,
    this.servicePrice,
    this.serviceActive,
    this.serviceId,
  });

  // Dados utilizados quando a tela for aberta para edição
  final String? serviceName;
  final String? serviceDescription;
  final double? servicePrice;
  final bool? serviceActive;
  final int? serviceId;

  @override
  State<RegisterServicesScreen> createState() =>
      _RegisterServicesScreenState();
}

class _RegisterServicesScreenState
    extends State<RegisterServicesScreen> {
  // Lista de serviços
  List<ServiceClass> services = [];

  // Chave do formulário
  final formKey = GlobalKey<FormState>();

  // Controllers dos campos
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  // Indica se o serviço está ativo
  bool ativo = true;

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
              "Registrar Serviço",
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

            // Escurece a imagem
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: .85),
              BlendMode.darken,
            ),
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: ConstrainedBox(
              // Limita a largura do formulário
              constraints: const BoxConstraints(
                maxWidth: 550,
              ),

              child: Container(
                padding: const EdgeInsets.all(25),

                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),

                  borderRadius:
                      BorderRadius.circular(20),

                  border: Border.all(
                    color: const Color(0xFFD6B35A),
                  ),
                ),

                child: Form(
                  key: formKey,

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,

                    children: [
                      /// Ícone principal
                      const Icon(
                        Icons.content_cut,
                        color: Color(0xFFD6B35A),
                        size: 55,
                      ),

                      const SizedBox(height: 15),

                      /// Título
                      const Text(
                        "Novo Serviço",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 30),

                      //--------------------------------------------------
                      // Campo nome
                      //--------------------------------------------------

                      TextFormField(
                        controller: nameController,

                        style: const TextStyle(
                          color: Colors.white,
                        ),

                        decoration: campo(
                          "Nome do Serviço",
                          Icons.content_cut,
                        ),

                        validator: (value) {
                          if (value == null ||
                              value.isEmpty) {
                            return "Informe o nome.";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      //--------------------------------------------------
                      // Campo preço
                      //--------------------------------------------------

                      TextFormField(
                        controller: priceController,

                        keyboardType:
                            TextInputType.number,

                        style: const TextStyle(
                          color: Colors.white,
                        ),

                        decoration: campo(
                          "Preço",
                          Icons.attach_money,
                        ),

                        validator: (value) {
                          if (value == null ||
                              value.isEmpty) {
                            return "Informe o preço.";
                          }

                          // Verifica se o valor é numérico
                          if (double.tryParse(
                                  value) ==
                              null) {
                            return "Preço inválido.";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      //--------------------------------------------------
                      // Campo descrição
                      //--------------------------------------------------

                      TextFormField(
                        controller:
                            descriptionController,

                        maxLines: 4,

                        style: const TextStyle(
                          color: Colors.white,
                        ),

                        decoration: campo(
                          "Descrição",
                          Icons.description,
                        ),
                      ),

                      const SizedBox(height: 20),

                      //--------------------------------------------------
                      // Switch para ativar/desativar serviço
                      //--------------------------------------------------

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius:
                              BorderRadius.circular(
                                  12),
                        ),

                        child: SwitchListTile(
                          activeThumbColor:
                              const Color(
                                  0xFFD6B35A),

                          title: const Text(
                            "Serviço Ativo",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),

                          value: ativo,

                          onChanged: (value) {
                            setState(() {
                              ativo = value;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 30),

                      //--------------------------------------------------
                      // Botão salvar
                      //--------------------------------------------------

                      SizedBox(
                        height: 55,

                        child:
                            ElevatedButton.icon(
                          icon:
                              const Icon(Icons.save),

                          label: const Text(
                            "REGISTRAR SERVIÇO",
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),

                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(
                                    0xFFD6B35A),
                            foregroundColor:
                                Colors.black,

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          12),
                            ),
                          ),

                          onPressed: () async {
                            // Valida o formulário
                            if (formKey
                                .currentState!
                                .validate()) {
                              try {
                                final supabase =
                                    Supabase.instance
                                        .client;

                                // Insere o serviço no banco
                                await supabase
                                    .from(
                                        'service')
                                    .insert({
                                  'name':
                                      nameController
                                          .text,
                                  'description':
                                      descriptionController
                                          .text,
                                  'price':
                                      priceController
                                          .text,
                                  'active': ativo,
                                });

                                // Mensagem de sucesso
                                ScaffoldMessenger.of(
                                        context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Cadastro realizado com sucesso!",
                                    ),
                                    backgroundColor:
                                        Colors.green,
                                  ),
                                );

                                // Retorna para a tela anterior
                                Navigator.pop(
                                    context);
                              }

                              // Registro duplicado
                              on PostgrestException catch (e) {
                                if (e.code ==
                                    "23505") {
                                  ScaffoldMessenger.of(
                                          context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Serviço já cadastrado.",
                                      ),
                                      backgroundColor:
                                          Colors.red,
                                    ),
                                  );
                                }
                              }

                              // Outros erros
                              catch (_) {
                                ScaffoldMessenger.of(
                                        context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Erro ao cadastrar serviço.",
                                    ),
                                    backgroundColor:
                                        Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Retorna a decoração padrão dos campos
  InputDecoration campo(
    String texto,
    IconData icone,
  ) {
    return InputDecoration(
      // Texto do campo
      labelText: texto,

      labelStyle: const TextStyle(
        color: Color(0xFFD6B35A),
      ),

      // Ícone do campo
      prefixIcon: Icon(
        icone,
        color: const Color(0xFFD6B35A),
      ),

      filled: true,
      fillColor: Colors.black26,

      // Borda quando o campo não possui foco
      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFD6B35A),
        ),
      ),

      // Borda quando o campo recebe foco
      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFD6B35A),
          width: 2,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Libera os controllers da memória
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}