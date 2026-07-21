import 'package:appliminalbarbershop/utils.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Tela de cadastro de usuários
class RegisterAccountScreen extends StatefulWidget {
  const RegisterAccountScreen({super.key});

  @override
  State<RegisterAccountScreen> createState() =>
      _RegisterAccountScreenState();
}

class _RegisterAccountScreenState
    extends State<RegisterAccountScreen> {
  // Chave do formulário
  final formKey = GlobalKey<FormState>();

  // Controllers dos campos
  final fullNameController = TextEditingController();
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  // Controla a exibição da senha
  bool obscureText = true;

  /// Validação da senha
  /// Deve conter:
  /// - mínimo de 12 caracteres
  /// - letra maiúscula
  /// - letra minúscula
  /// - número
  /// - caractere especial
  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório!';
    }

    // Expressão regular utilizada na validação
    final regex = RegExp(
      r'^(?=.*[a-z])' // pelo menos 1 letra minúscula
      r'(?=.*[A-Z])' // pelo menos 1 letra maiúscula
      r'(?=.*\d)' // pelo menos 1 número
      r'(?=.*[@$!%*?&\-_#])' // pelo menos 1 caractere especial
      r'[A-Za-z\d@$!%*?&\-_#]{12,}$', // mínimo de 12 caracteres
    );

    if (!regex.hasMatch(value)) {
      return 'A senha deve ter no mínimo 12 caracteres, incluindo maiúsculas, minúsculas, números e caracteres especiais';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Imagem de fundo
          Positioned.fill(
            child: Image.asset(
              "assets/images/barber_backrooms.jpg",
              fit: BoxFit.cover,
            ),
          ),

          /// Camada escura sobre a imagem
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: .55),
                    Colors.black.withValues(alpha: .85),
                  ],
                ),
              ),
            ),
          ),

          /// Painel central
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Container(
                width: 450,
                padding: const EdgeInsets.all(30),

                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: .78),

                  borderRadius: BorderRadius.circular(25),

                  border: Border.all(
                    color: const Color(0xffD6B35A),
                    width: 2,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withValues(alpha: .15),
                      blurRadius: 30,
                      spreadRadius: 3,
                    ),
                  ],
                ),

                child: Form(
                  key: formKey,

                  child: Column(
                    children: [
                      /// Ícone principal
                      const Icon(
                        Icons.content_cut,
                        size: 65,
                        color: Color(0xffD6B35A),
                      ),

                      const SizedBox(height: 15),

                      /// Nome da barbearia
                      const Text(
                        "LIMINAL",
                        style: TextStyle(
                          color: Color(0xffD6B35A),
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 5,
                        ),
                      ),

                      const Text(
                        "BARBERSHOP",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          letterSpacing: 4,
                          fontWeight: FontWeight.w300,
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// Texto explicativo
                      Text(
                        "Crie sua conta para agendar seus horários.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                        ),
                      ),

                      const SizedBox(height: 35),

                      //--------------------------------------------------
                      // Campo de usuário
                      //--------------------------------------------------

                      TextFormField(
                        controller: loginController,

                        style: const TextStyle(
                          color: Colors.white,
                        ),

                        decoration: campo(
                          "Usuário",
                          Icons.account_circle_outlined,
                        ),

                        validator: (v) =>
                            v!.isEmpty
                                ? "Informe um usuário."
                                : null,
                      ),

                      const SizedBox(height: 18),

                      //--------------------------------------------------
                      // Campo de senha
                      //--------------------------------------------------

                      TextFormField(
                        controller: passwordController,
                        obscureText: obscureText,

                        style: const TextStyle(
                          color: Colors.white,
                        ),

                        decoration: campo(
                          "Senha",
                          Icons.lock_outline,
                        ).copyWith(
                          // Botão para mostrar/ocultar senha
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color:
                                  const Color(0xffD6B35A),
                            ),
                            onPressed: () {
                              setState(() {
                                obscureText =
                                    !obscureText;
                              });
                            },
                          ),
                        ),

                        validator: passwordValidator,
                      ),

                      const SizedBox(height: 30),

                      //--------------------------------------------------
                      // Botão de cadastro
                      //--------------------------------------------------

                      SizedBox(
                        width: double.infinity,
                        height: 55,

                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.app_registration,
                          ),

                          label: const Text(
                            "CRIAR CONTA",
                            style: TextStyle(
                              fontSize: 17,
                              letterSpacing: 2,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(
                                    0xffD6B35A),
                            foregroundColor:
                                Colors.black,

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(12),
                            ),
                          ),

                          onPressed: () async {
                            // Valida os campos
                            if (formKey.currentState!
                                .validate()) {
                              try {
                                final supabase =
                                    Supabase.instance
                                        .client;

                                // Insere o usuário no banco
                                await supabase
                                    .from("user")
                                    .insert({
                                  "full_name":
                                      fullNameController
                                          .text,
                                  "login":
                                      loginController
                                          .text,
                                  "password":
                                      Utils.gerarMd5(
                                    passwordController
                                        .text,
                                  ),
                                });

                                // Mensagem de sucesso
                                ScaffoldMessenger.of(
                                        context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Conta criada com sucesso!",
                                    ),
                                    backgroundColor:
                                        Colors.green,
                                  ),
                                );

                                // Retorna para a tela de login
                                Navigator.pop(
                                    context);
                              }

                              // Usuário já existe
                              on PostgrestException catch (e) {
                                if (e.code ==
                                    "23505") {
                                  ScaffoldMessenger.of(
                                          context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Usuário já existe.",
                                      ),
                                      backgroundColor:
                                          Colors.red,
                                    ),
                                  );
                                }
                              }
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 15),

                      /// Botão para voltar ao login
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Já possui conta? Entrar",
                          style: TextStyle(
                            color:
                                Color(0xffD6B35A),
                          ),
                        ),
                      ),

                      /// Linha divisória
                      const Divider(
                        color: Color(0xffD6B35A),
                        height: 35,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Retorna a decoração padrão dos campos de texto
  InputDecoration campo(
    String texto,
    IconData icon,
  ) {
    return InputDecoration(
      // Texto do campo
      labelText: texto,

      labelStyle: const TextStyle(
        color: Color(0xffD6B35A),
      ),

      // Ícone do campo
      prefixIcon: Icon(
        icon,
        color: const Color(0xffD6B35A),
      ),

      filled: true,
      fillColor: Colors.black.withValues(alpha: .35),

      // Borda quando o campo não está selecionado
      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),

        borderSide: const BorderSide(
          color: Color(0xffD6B35A),
        ),
      ),

      // Borda quando o campo recebe foco
      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),

        borderSide: const BorderSide(
          color: Colors.amber,
          width: 2,
        ),
      ),
    );
  }
}