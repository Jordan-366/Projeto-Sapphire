import 'package:flutter/material.dart';
import 'tela-inicial.dart';
import 'chat_ai.dart';
import 'db_test.dart';

enum MediaType { livro, filme }

class CadastroMidia extends StatefulWidget {
  const CadastroMidia({super.key});

  @override
  State<CadastroMidia> createState() => _CadastroMidiaState();
}

class _CadastroMidiaState extends State<CadastroMidia> {
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerCapitulo = TextEditingController();
  final TextEditingController _controllerPagina = TextEditingController();
  final TextEditingController _controllerHora = TextEditingController();
  final TextEditingController _controllerMinuto = TextEditingController();

  MediaType _tipoSelecionado = MediaType.livro;

  Future<void> _salvarMidia() async {
    final nome = _controllerNome.text.trim();

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha o nome antes de salvar.')),
      );
      return;
    }

    final db = await iniciarBanco();

    if (_tipoSelecionado == MediaType.livro) {
      final capituloTexto = _controllerCapitulo.text.trim();
      final paginaTexto = _controllerPagina.text.trim();

      if (capituloTexto.isEmpty || paginaTexto.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Preencha capítulo e página antes de salvar.'),
          ),
        );
        return;
      }

      final capitulo = int.tryParse(capituloTexto);
      final pagina = int.tryParse(paginaTexto);

      if (capitulo == null || pagina == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Capítulo e página devem ser números inteiros.'),
          ),
        );
        return;
      }

      await db.insert('livro', {
        'nome': nome,
        'capitulo': capitulo,
        'pagina': pagina,
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Livro salvo com sucesso.')));
      _controllerCapitulo.clear();
      _controllerPagina.clear();
    } else {
      final horaTexto = _controllerHora.text.trim();
      final minutoTexto = _controllerMinuto.text.trim();

      if (horaTexto.isEmpty || minutoTexto.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Preencha hora e minuto antes de salvar.'),
          ),
        );
        return;
      }

      final hora = int.tryParse(horaTexto);
      final minuto = int.tryParse(minutoTexto);

      if (hora == null || minuto == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hora e minuto devem ser números inteiros.'),
          ),
        );
        return;
      }

      await db.insert('filmes', {'nome': nome, 'hora': hora, 'minuto': minuto});

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Filme salvo com sucesso.')));
      _controllerHora.clear();
      _controllerMinuto.clear();
    }

    _controllerNome.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      // AppBar Principal (Topo)
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D53B8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF0D53B8)),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
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
              child: Center(
                child: Text(
                  _tipoSelecionado == MediaType.livro
                      ? 'Cadastro de Livros'
                      : 'Cadastro de Filmes',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Toggle entre livros e filmes
            ToggleButtons(
              isSelected: [
                _tipoSelecionado == MediaType.livro,
                _tipoSelecionado == MediaType.filme,
              ],
              onPressed: (index) {
                setState(() {
                  _tipoSelecionado = index == 0
                      ? MediaType.livro
                      : MediaType.filme;
                });
              },
              borderRadius: BorderRadius.circular(12),
              selectedColor: Colors.white,
              color: Colors.white70,
              fillColor: const Color(0xFF0D53B8),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  child: Text('Livro'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  child: Text('Filme'),
                ),
              ],
            ),

            const SizedBox(height: 30), // Espaço entre o banner e os inputs
            // Container dos TextFields com Padding MAIOR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Column(
                children: [
                  // Campo: Nome
                  TextField(
                    controller: _controllerNome,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: _tipoSelecionado == MediaType.livro
                          ? 'Nome do Livro'
                          : 'Nome do Filme',
                      labelStyle: const TextStyle(color: Colors.white),
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (_tipoSelecionado == MediaType.livro) ...[
                    // Campo: Capítulo
                    TextField(
                      controller: _controllerCapitulo,
                      keyboardType: TextInputType.number,
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
                          borderSide: BorderSide(
                            color: Color(0xFF0D53B8),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Campo: Página
                    TextField(
                      controller: _controllerPagina,
                      keyboardType: TextInputType.number,
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
                          borderSide: BorderSide(
                            color: Color(0xFF0D53B8),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    // Campo: Hora
                    TextField(
                      controller: _controllerHora,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Hora',
                        labelStyle: TextStyle(color: Colors.white),
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF0D53B8)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF0D53B8),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Campo: Minuto
                    TextField(
                      controller: _controllerMinuto,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Minuto',
                        labelStyle: TextStyle(color: Colors.white),
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF0D53B8)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF0D53B8),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: _salvarMidia,
        backgroundColor: const Color(0xFF0D53B8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
