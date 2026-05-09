
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Livro{
  final int id;
  final String nome;
  final int pagina;
  final int capitulo;

  Livro({required this.id, required this.nome, required this.pagina, required this.capitulo});

  Map<String, Object?> toMap(){
     return {
      'id': id,
      'nome': nome,
      'pagina': pagina,
      'capitulo': capitulo,
    };
  }

  @override
  String toString() {
    return "Livro (id: $id, nome $nome, página $pagina, capítulo $capitulo )";
  }

}




Future<Database> iniciarBanco() async{

  return openDatabase(
    join(await getDatabasesPath(), "Sapphire_database.db"),

    onCreate:(db, version){
      return db.execute(
        "CREATE TABLE livro(id INTEGER PRIMARY KEY, nome TEXT, pagina INTEGER, capitulo INTEGER)"
      );
    },
    version: 1,
  );

}

// Função para inserir um livro no banco de dados
Future<int> inserirLivro(Livro livro) async {
  final db = await iniciarBanco();
  return await db.insert('livro', livro.toMap());
}

// Função para recuperar todos os livros
Future<List<Livro>> obterTodosLivros() async {
  final db = await iniciarBanco();
  final List<Map<String, Object?>> livroMapa = await db.query('livro');
  return [
    for (final { 'id': id as int, 'nome': nome as String, 'pagina': pagina as int, 'capitulo': capitulo as int} in livroMapa)
      Livro(id: id, nome: nome, pagina: pagina, capitulo: capitulo),
  ];
}

// Função para atualizar um livro
Future<int> atualizarLivro(Livro livro) async {
  final db = await iniciarBanco();
  return await db.update('livro', livro.toMap(), where: 'id = ?', whereArgs: [livro.id]);
}

// Função para deletar um livro
Future<int> deletarLivro(int id) async {
  final db = await iniciarBanco();
  return await db.delete('livro', where: 'id = ?', whereArgs: [id]);
}