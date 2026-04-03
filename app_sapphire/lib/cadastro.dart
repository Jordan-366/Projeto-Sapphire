import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
  return MaterialApp(
    themeMode: ThemeMode.dark,
    darkTheme: ThemeData.dark(),
    home: Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(80),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            color: Color(0xFF172F51).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20)
          ),//Borda arredondada
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Text(
                "Bem vindo!", 
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2
                ),
              ), //Texto bem vindo
              SizedBox(height: 60,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Login",
                    hintStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )
                  ),
                ),
              ),//Entry do login/usuario
              SizedBox(height: 60,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Senha",
                    hintStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )
                  ),
                ),
              ),   //Entry da senha 
              Spacer(),
              RichText(text: TextSpan(
                  text: "Não tem conta? ",
                  style: TextStyle(color: Colors.white),
                  children: [
                    TextSpan(
                      text: "Cadastre-se",
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer() ..onTap = () {
                        print("Clicou");
                      }
                    )
                  ]
                )
              ),
              SizedBox(height: 10,)
            ],
          ),
        ), // Fundo azul
      ),
    ),
  );
  }
}
