
import 'dart:async';

import 'package:flutter/widgets.dart';
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