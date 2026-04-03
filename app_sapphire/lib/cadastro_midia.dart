import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final TextEditingController _controllerLivro = TextEditingController();
  final TextEditingController _controllerCapitulo = TextEditingController();
  final TextEditingController _controllerPagina = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        // AppBar Principal (Topo)
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
              // Segunda AppBar (Banner com Label)
              Container(
                width: double.infinity,
                height: 60,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Color(0xFF0D53B8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    'Tipo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40), // Espaço entre o banner e os inputs

              // Container dos TextFields com Padding MAIOR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0), 
                child: Column(
                  children: [
                    // Campo: Nome do Livro
                    TextField(
                      controller: _controllerLivro,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Nome do Livro',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF0D53B8)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF0D53B8), width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Campo: Capítulo
                    TextField(
                      controller: _controllerCapitulo,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Capítulo',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF0D53B8)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF0D53B8), width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Campo: Página
                    TextField(
                      controller: _controllerPagina,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Página',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF0D53B8)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF0D53B8), width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Floating Action Button
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("Livro: ${_controllerLivro.text}");
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