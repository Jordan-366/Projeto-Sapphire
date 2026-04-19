import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'tela-inicial.dart';
import 'db_test.dart';

Database? _db;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _db = await iniciarBanco();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  void _login() {
    // Simples validação: verificar se os campos não estão vazios
    if (_loginController.text.isNotEmpty && _senhaController.text.isNotEmpty) {
      // Navegar para a próxima tela
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TelaInicial()),
      );
    } else {
      // Mostrar erro, por exemplo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(40),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            color: const Color(0xFF0D53B8).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20)
          ),//Borda arredondada
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              const Text(
                "Bem vindo!", 
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2
                ),
              ), //Texto bem vindo
              const SizedBox(height: 60,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: _loginController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Login",
                    hintStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )
                  ),
                ),
              ),//Entry do login/usuario
              const SizedBox(height: 60,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: _senhaController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Senha",
                    hintStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )
                  ),
                ),
              ),   //Entry da senha 
              const Spacer(),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Entrar'),
              ),
              const SizedBox(height: 10,),
              RichText(text: TextSpan(
                  text: "Não tem conta? ",
                  style: const TextStyle(color: Colors.white),
                  children: [
                    TextSpan(
                      text: "Cadastre-se",
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer() ..onTap = () {
                        print("Clicou");
                      }
                    )
                  ]
                )
              ),
              const SizedBox(height: 10,)
            ],
          ),
        ), // Fundo azul
      ),
    );
  }
}
