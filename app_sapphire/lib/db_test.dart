import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Livro {
  final int id;
  final String nome;
  final int pagina;
  final int capitulo;

  Livro({
    required this.id,
    required this.nome,
    required this.pagina,
    required this.capitulo,
  });

  Map<String, Object?> toMap() {
    return {'id': id, 'nome': nome, 'pagina': pagina, 'capitulo': capitulo};
  }

  @override
  String toString() {
    return "Livro (id: $id, nome $nome, página $pagina, capítulo $capitulo )";
  }
}

class Filme {
  final int id;
  final String nome;
  final int hora;
  final int minuto;

  Filme({
    required this.id,
    required this.nome,
    required this.hora,
    required this.minuto,
  });

  Map<String, Object?> toMap() {
    return {'id': id, 'nome': nome, 'hora': hora, 'minuto': minuto};
  }

  @override
  String toString() {
    return "Filme (id: $id, nome: $nome, hora: $hora, minuto: $minuto)";
  }
}

Future<Database> iniciarBanco() async {
  return openDatabase(
    join(await getDatabasesPath(), "Sapphire_database.db"),
    version: 2,
    onCreate: (db, version) async {
      await db.execute(
        "CREATE TABLE livro(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, pagina INTEGER, capitulo INTEGER)",
      );
      await db.execute(
        "CREATE TABLE filmes(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, hora INTEGER, minuto INTEGER)",
      );
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute(
          "CREATE TABLE filmes(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, hora INTEGER, minuto INTEGER)",
        );
      }
    },
  );
}

Future<void> atualizarLivro(
  int id,
  String nome,
  int capitulo,
  int pagina,
) async {
  final db = await iniciarBanco();
  await db.update(
    'livro',
    {'nome': nome, 'capitulo': capitulo, 'pagina': pagina},
    where: 'id = ?',
    whereArgs: [id],
  );
}

Future<void> deletarLivro(int id) async {
  final db = await iniciarBanco();
  await db.delete('livro', where: 'id = ?', whereArgs: [id]);
}

Future<void> atualizarFilme(int id, String nome, int hora, int minuto) async {
  final db = await iniciarBanco();
  await db.update(
    'filmes',
    {'nome': nome, 'hora': hora, 'minuto': minuto},
    where: 'id = ?',
    whereArgs: [id],
  );
}

Future<void> deletarFilme(int id) async {
  final db = await iniciarBanco();
  await db.delete('filmes', where: 'id = ?', whereArgs: [id]);
}
