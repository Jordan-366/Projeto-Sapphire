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
        appBar: AppBar(
          backgroundColor: Color(0xFF0D53B8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Itens vão ficar por aqui"),

            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("Cadastrar itens: ");
          },
          backgroundColor: Color(0xFF0D53B8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),

      ),
    );
  }
}
