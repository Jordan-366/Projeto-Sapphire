import 'package:flutter/material.dart';
import 'chat_ai.dart';
import 'cadastro_midia.dart';
import 'db_test.dart';

enum MediaType { livro, filme }

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  MediaType _tipoSelecionado = MediaType.livro;
  late Future<List<dynamic>> _futureRegistros;

  @override
  void initState() {
    super.initState();
    _futureRegistros = _carregarLivros();
  }

  void _selecionarTipo(MediaType tipo) {
    setState(() {
      _tipoSelecionado = tipo;
      _futureRegistros = tipo == MediaType.livro
          ? _carregarLivros()
          : _carregarFilmes();
    });
  }

  Future<List<Livro>> _carregarLivros() async {
    final db = await iniciarBanco();
    final resultado = await db.query('livro', orderBy: 'id DESC');
    return resultado.map((row) {
      return Livro(
        id: row['id'] as int,
        nome: row['nome'] as String,
        pagina: row['pagina'] as int,
        capitulo: row['capitulo'] as int,
      );
    }).toList();
  }

  Future<List<Filme>> _carregarFilmes() async {
    final db = await iniciarBanco();
    final resultado = await db.query('filmes', orderBy: 'id DESC');
    return resultado.map((row) {
      return Filme(
        id: row['id'] as int,
        nome: row['nome'] as String,
        hora: row['hora'] is int
            ? row['hora'] as int
            : int.parse(row['hora'].toString()),
        minuto: row['minuto'] is int
            ? row['minuto'] as int
            : int.parse(row['minuto'].toString()),
      );
    }).toList();
  }

  void _mostrarDialogEdicao(
    BuildContext context,
    dynamic registro,
    MediaType tipo,
  ) {
    final TextEditingController _controllerNome = TextEditingController(
      text: registro.nome,
    );
    final TextEditingController _controllerCapitulo = TextEditingController(
      text: tipo == MediaType.livro ? registro.capitulo.toString() : '',
    );
    final TextEditingController _controllerPagina = TextEditingController(
      text: tipo == MediaType.livro ? registro.pagina.toString() : '',
    );
    final TextEditingController _controllerHora = TextEditingController(
      text: tipo == MediaType.filme ? registro.hora.toString() : '',
    );
    final TextEditingController _controllerMinuto = TextEditingController(
      text: tipo == MediaType.filme ? registro.minuto.toString() : '',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar ${tipo == MediaType.livro ? 'Livro' : 'Filme'}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _controllerNome,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                if (tipo == MediaType.livro) ...[
                  TextField(
                    controller: _controllerCapitulo,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Capítulo'),
                  ),
                  TextField(
                    controller: _controllerPagina,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Página'),
                  ),
                ] else ...[
                  TextField(
                    controller: _controllerHora,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Hora'),
                  ),
                  TextField(
                    controller: _controllerMinuto,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Minuto'),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final nome = _controllerNome.text.trim();
                if (nome.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nome não pode estar vazio')),
                  );
                  return;
                }

                if (tipo == MediaType.livro) {
                  final capitulo = int.tryParse(_controllerCapitulo.text);
                  final pagina = int.tryParse(_controllerPagina.text);
                  if (capitulo == null || pagina == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Capítulo e página devem ser números'),
                      ),
                    );
                    return;
                  }
                  await atualizarLivro(registro.id, nome, capitulo, pagina);
                } else {
                  final hora = int.tryParse(_controllerHora.text);
                  final minuto = int.tryParse(_controllerMinuto.text);
                  if (hora == null || minuto == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Hora e minuto devem ser números'),
                      ),
                    );
                    return;
                  }
                  await atualizarFilme(registro.id, nome, hora, minuto);
                }

                setState(() {
                  _futureRegistros = tipo == MediaType.livro
                      ? _carregarLivros()
                      : _carregarFilmes();
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${tipo == MediaType.livro ? 'Livro' : 'Filme'} atualizado com sucesso',
                    ),
                  ),
                );
              },
              child: const Text('Salvar'),
            ),
            TextButton(
              onPressed: () async {
                final confirmar = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirmar exclusão'),
                      content: Text(
                        'Tem certeza que deseja excluir este ${tipo == MediaType.livro ? 'livro' : 'filme'}?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Excluir'),
                        ),
                      ],
                    );
                  },
                );

                if (confirmar == true) {
                  if (tipo == MediaType.livro) {
                    await deletarLivro(registro.id);
                  } else {
                    await deletarFilme(registro.id);
                  }
                  setState(() {
                    _futureRegistros = tipo == MediaType.livro
                        ? _carregarLivros()
                        : _carregarFilmes();
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${tipo == MediaType.livro ? 'Livro' : 'Filme'} excluído com sucesso',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D53B8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CadastroMidia(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ToggleButtons(
              isSelected: [
                _tipoSelecionado == MediaType.livro,
                _tipoSelecionado == MediaType.filme,
              ],
              onPressed: (index) {
                _selecionarTipo(index == 0 ? MediaType.livro : MediaType.filme);
              },
              borderRadius: BorderRadius.circular(12),
              selectedColor: Colors.white,
              color: Colors.white70,
              fillColor: const Color(0xFF0D53B8),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text('Livros'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text('Filmes'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _futureRegistros,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erro ao carregar registros: \\${snapshot.error}',
                    ),
                  );
                }

                final registros = snapshot.data ?? [];

                if (registros.isEmpty) {
                  return Center(
                    child: Text(
                      _tipoSelecionado == MediaType.livro
                          ? 'Nenhum livro cadastrado ainda.\nUse o menu para cadastrar uma mídia.'
                          : 'Nenhum filme cadastrado ainda.\nUse o menu para cadastrar uma mídia.',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: registros.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (_tipoSelecionado == MediaType.livro) {
                      final livro = registros[index] as Livro;
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF0D53B8)),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          title: Text(
                            livro.nome,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            'Capítulo ${livro.capitulo} • Página ${livro.pagina}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () => _mostrarDialogEdicao(
                              context,
                              livro,
                              MediaType.livro,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0D53B8),
                            ),
                            child: const Text('Editar'),
                          ),
                        ),
                      );
                    }

                    final filme = registros[index] as Filme;
                    final horaText = filme.hora.toString().padLeft(2, '0');
                    final minutoText = filme.minuto.toString().padLeft(2, '0');
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF0D53B8)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        title: Text(
                          filme.nome,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          'Horário $horaText:$minutoText',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => _mostrarDialogEdicao(
                            context,
                            filme,
                            MediaType.filme,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D53B8),
                          ),
                          child: const Text('Editar'),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CadastroMidia()),
          );
        },
        backgroundColor: const Color(0xFF0D53B8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
