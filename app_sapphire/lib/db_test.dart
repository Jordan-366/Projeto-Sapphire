
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
    return {'Id': id, "Nome": nome,"Página": pagina,"Capítulo": capitulo };
  }

  @override
  String toString() {
    return "Livro (id: $id, nome $nome, página $pagina, capítulo $capitulo )";
  }

}




void main() async{

  final database = await openDatabase(
    join(await getDatabasesPath(), "Sapphire_database.db"),

    onCreate:(db, version){
      return db.execute(
        "CREATE TABLE livro(id INTEGER PRIMARY KEY, nome TEXT, pagina INTEGER, capitulo INTEGER)"
      );
    },
    version: 1,
  );

}