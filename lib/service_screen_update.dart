import 'package:appliminalbarbershop/service_class.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Tela para edição de um serviço já cadastrado
class UpdateServicesScreen extends StatefulWidget {
  const UpdateServicesScreen({
    super.key,
    this.serviceName,
    this.serviceDescription,
    this.servicePrice,
    this.serviceActive,
    this.serviceId,
  });

  // Dados do serviço recebidos da tela anterior
  final String? serviceName;
  final String? serviceDescription;
  final double? servicePrice;
  final bool? serviceActive;
  final int? serviceId;

  @override
  State<UpdateServicesScreen> createState() =>
      _UpdateServicesScreenState();
}

class _UpdateServicesScreenState
    extends State<UpdateServicesScreen> {
  // Lista de serviços
  List<ServiceClass> services = [];

  // Chave do formulário
  final formKey = GlobalKey<FormState>();

  // Controllers dos campos
  late final TextEditingController nameController;
  late final TextEditingController priceController;
  late final TextEditingController descriptionController;

  // Controla o estado do botão durante a atualização
  bool isLoading = false;

  // Indica se o serviço está ativo
  bool ativo = true;

  @override
  void initState() {
    super.initState();

    // Preenche os campos com os dados recebidos
    nameController =
        TextEditingController(text: widget.serviceName ?? '');

    priceController =
        TextEditingController(
      text: widget.servicePrice?.toString() ?? '',
    );

    descriptionController =
        TextEditingController(
      text: widget.serviceDescription ?? '',
    );

    ativo = widget.serviceActive ?? true;
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
              "Editar Serviço",
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
                      /// Ícone da tela
                      const Icon(
                        Icons.edit,
                        color: Color(0xFFD6B35A),
                        size: 55,
                      ),

                      const SizedBox(height: 15),

                      /// Título
                      const Text(
                        "Editar Serviço",
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
                      // Switch para ativar/desativar o serviço
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
                      // Botão para salvar alterações
                      //--------------------------------------------------

                      SizedBox(
                        height: 55,

                        child:
                            ElevatedButton.icon(
                          // Exibe indicador de carregamento
                          icon: isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child:
                                      CircularProgressIndicator(
                                    color:
                                        Colors.black,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(
                                  Icons.save),

                          label: Text(
                            isLoading
                                ? "SALVANDO..."
                                : "SALVAR ALTERAÇÕES",
                            style:
                                const TextStyle(
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

                          // Desabilita o botão durante o carregamento
                          onPressed: isLoading
                              ? null
                              : () async {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  if (formKey
                                      .currentState!
                                      .validate()) {
                                    try {
                                      final supabase =
                                          Supabase
                                              .instance
                                              .client;

                                      // Atualiza o serviço
                                      await supabase
                                          .from(
                                              "service")
                                          .update({
                                        "name":
                                            nameController
                                                .text,
                                        "description":
                                            descriptionController
                                                .text,
                                        "price": (double.parse(
                                                    priceController
                                                        .text) *
                                                100)
                                            .toInt(),
                                        "active":
                                            ativo,
                                      }).eq(
                                              "id",
                                              widget
                                                  .serviceId
                                                  .toString());

                                      // Mensagem de sucesso
                                      ScaffoldMessenger
                                              .of(
                                                  context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Serviço atualizado com sucesso!",
                                          ),
                                          backgroundColor:
                                              Colors
                                                  .green,
                                        ),
                                      );

                                      Navigator.pop(
                                          context);
                                    }

                                    // Serviço duplicado
                                    on PostgrestException catch (e) {
                                      if (e.code ==
                                          "23505") {
                                        ScaffoldMessenger.of(
                                                context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text(
                                              "Serviço já cadastrado.",
                                            ),
                                            backgroundColor:
                                                Colors
                                                    .red,
                                          ),
                                        );
                                      }
                                    }

                                    // Outros erros
                                    catch (e) {
                                      ScaffoldMessenger
                                              .of(
                                                  context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Erro ao atualizar serviço.",
                                          ),
                                          backgroundColor:
                                              Colors
                                                  .red,
                                        ),
                                      );
                                    }

                                    // Finaliza o carregamento
                                    finally {
                                      setState(() {
                                        isLoading =
                                            false;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      isLoading =
                                          false;
                                    });
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

  /// Retorna a decoração padrão dos campos de texto
  InputDecoration campo(
    String texto,
    IconData icone,
  ) {
    return InputDecoration(
      labelText: texto,

      labelStyle: const TextStyle(
        color: Color(0xFFD6B35A),
      ),

      prefixIcon: Icon(
        icone,
        color: const Color(0xFFD6B35A),
      ),

      filled: true,
      fillColor: Colors.black26,

      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),

        borderSide: const BorderSide(
          color: Color(0xFFD6B35A),
        ),
      ),

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