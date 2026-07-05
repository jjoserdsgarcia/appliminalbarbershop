import 'package:appliminalbarbershop/home_screen_employee.dart';
import 'package:appliminalbarbershop/home_screen_user.dart';
import 'package:appliminalbarbershop/register_account_screen.dart';
import 'package:appliminalbarbershop/utils.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var obscureText = true;
  final formKey = GlobalKey<FormState>();
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Faça login"),),
    body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 300,
            maxWidth: 300,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: [
                TextFormField(
                  controller: loginController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Login",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo obrigatório!";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Senha",
                    // suffixIcon: obscureText == true ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      icon: obscureText == true ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo obrigatório!";
                    }
                    return null;
                  },
                  obscureText: obscureText,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final supabase = Supabase.instance.client;
                      final usuarios = await supabase
                          .from("user") //
                          .select()
                          .eq("login", loginController.text)
                          .eq("password", Utils.gerarMd5(passwordController.text));
                      if (usuarios.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Credenciais inválidas"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Usuário autenticado com sucesso"),
                            backgroundColor: Colors.green,
                          ),
                        );
                        if (usuarios.first["is_employee"]) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) {
                                return HomeScreenEmployee();
                              },
                            ),
                          );
                        } else {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) {
                                return HomeScreenUser();
                              },
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: Text("Entrar"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return RegisterAccountScreen();
                        },
                      ),
                    );
                  },
                  child: Text("Cadastre-se"),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
}
