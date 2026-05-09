import 'package:flutter/material.dart';
import 'tela-inicial.dart';
import 'chat_ai.dart';
import 'db_test.dart';

class CadastroMidia extends StatefulWidget {
  const CadastroMidia({super.key});

  @override
  State<CadastroMidia> createState() => _CadastroMidiaState();
}

class _CadastroMidiaState extends State<CadastroMidia> {
  final TextEditingController _controllerLivro = TextEditingController();
  final TextEditingController _controllerCapitulo = TextEditingController();
  final TextEditingController _controllerPagina = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 34, 34),
      // AppBar Principal (Topo)
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D53B8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF0D53B8),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Tela Inicial'),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaInicial()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Chat AI'),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatAI()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Cadastro de Mídia'),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer
              },
            ),
          ],
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
                color: const Color(0xFF0D53B8),
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
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Nome do Livro',
                      labelStyle: TextStyle(color: Colors.white),
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Campo: Capítulo
                  TextField(
                    controller: _controllerCapitulo,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Capítulo',
                      labelStyle: TextStyle(color: Colors.white),
                      floatingLabelAlignment: FloatingLabelAlignment.center,
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
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Página',
                      labelStyle: TextStyle(color: Colors.white),
                      floatingLabelAlignment: FloatingLabelAlignment.center,
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
        onPressed: () async {
          // Validar se todos os campos estão preenchidos
          if (_controllerLivro.text.isEmpty || _controllerCapitulo.text.isEmpty || _controllerPagina.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Preencha todos os campos!'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          try {
            // Criar objeto Livro com os dados do formulário
            final novoLivro = Livro(
              id: DateTime.now().millisecondsSinceEpoch, // Usar timestamp como ID único
              nome: _controllerLivro.text,
              capitulo: int.parse(_controllerCapitulo.text),
              pagina: int.parse(_controllerPagina.text),
            );

            // Inserir no banco de dados
            await inserirLivro(novoLivro);

            // Limpar os campos após sucesso
            _controllerLivro.clear();
            _controllerCapitulo.clear();
            _controllerPagina.clear();

            // Mostrar mensagem de sucesso
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Livro salvo com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } catch (e) {
            // Mostrar mensagem de erro
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erro ao salvar: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        backgroundColor: const Color(0xFF0D53B8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}