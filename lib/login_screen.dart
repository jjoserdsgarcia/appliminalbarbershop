import 'package:appliminalbarbershop/home_screen_employee.dart';
import 'package:appliminalbarbershop/home_screen_user.dart';
import 'package:appliminalbarbershop/register_account_screen.dart';
import 'package:appliminalbarbershop/utils.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

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
  return Scaffold(
    body: Stack(
      children: [

        /// BACKGROUND
        Positioned.fill(
          child: Image.asset(
            "assets/videos/Login.mp4",
            fit: BoxFit.cover,
          ),
        ),

        /// Overlay escuro
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(.45),
                  Colors.black.withOpacity(.75),
                ],
              ),
            ),
          ),
        ),

        /// Painel
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 12,
                  sigmaY: 12,
                ),
                child: Container(
                  width: 430,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.75),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xffE7D56D),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.yellow.withOpacity(.20),
                        blurRadius: 30,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        /// LOGO
                        CircleAvatar(
                          radius: 45,
                          backgroundColor:
                              const Color(0xffE7D56D).withOpacity(.15),
                          child: const Icon(
                            Icons.travel_explore,
                            size: 50,
                            color: Color(0xffE7D56D),
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "M.E.G",
                          style: TextStyle(
                            color: Color(0xffE7D56D),
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 5,
                          ),
                        ),

                        const SizedBox(height: 5),

                        const Text(
                          "INTERNAL ACCESS TERMINAL",
                          style: TextStyle(
                            color: Colors.greenAccent,
                            letterSpacing: 3,
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Authorized Personnel Only",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                          ),
                        ),

                        const SizedBox(height: 35),

                        /// LOGIN
                        TextFormField(
                          controller: loginController,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Color(0xffE7D56D),
                            ),
                            labelText: "Operator ID",
                            labelStyle: const TextStyle(
                              color: Colors.greenAccent,
                            ),
                            filled: true,
                            fillColor: Colors.black.withOpacity(.45),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xffE7D56D),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.greenAccent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Informe o login";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        /// SENHA
                        TextFormField(
                          controller: passwordController,
                          obscureText: obscureText,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Color(0xffE7D56D),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.greenAccent,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                            ),
                            labelText: "Security Key",
                            labelStyle: const TextStyle(
                              color: Colors.greenAccent,
                            ),
                            filled: true,
                            fillColor: Colors.black.withOpacity(.45),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xffE7D56D),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.greenAccent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Informe sua senha";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 30),

                        /// BOTÃO LOGIN
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.login),
                            label: const Text(
                              "AUTHORIZE ACCESS",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffE7D56D),
                              foregroundColor: Colors.black,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                final supabase = Supabase.instance.client;

                                final usuarios = await supabase
                                    .from("user")
                                    .select()
                                    .eq("login", loginController.text)
                                    .eq(
                                      "password",
                                      Utils.gerarMd5(
                                          passwordController.text),
                                    );

                                if (usuarios.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "ACCESS DENIED"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "ACCESS GRANTED"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );

                                  if (usuarios.first["is_employee"]) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            HomeScreenEmployee(),
                                      ),
                                    );
                                  } else {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            HomeScreenUser(),
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                          ),
                        ),

                        const SizedBox(height: 25),

                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    RegisterAccountScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "REGISTER NEW OPERATOR",
                            style: TextStyle(
                              color: Color(0xffE7D56D),
                            ),
                          ),
                        ),

                        const Divider(
                          color: Color(0xffE7D56D),
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ),    
            ),
          ),
        ),
      ],
    ),
  );
}
}