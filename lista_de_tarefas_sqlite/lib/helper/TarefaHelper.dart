import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/Tarefa.dart';

class TarefaHelper {
  static final _tarefaHelper = TarefaHelper.internal();
  static Database? _db;
  static final String tableName = "tarefas";

  TarefaHelper.internal();

  factory TarefaHelper() {
    return _tarefaHelper;
  }

  Future<Database> get db async {
    _db ??= await initDb();
    return _db!;
  }

  _onCreateDb(Database db, int version) {

    String sql = """
    CREATE TABLE tarefas(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      titulo VARCHAR,
      descricao TEXT,
      data DATETIME,
      realizada BOOLEAN
    );
    """;

    db.execute(sql);

  }

  initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "tarefas.db");

    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreateDb
    );

    return db;
  }

  getTarefas() async {
    var database = await db;

    String sql = "SELECT * FROM $tableName ORDER BY data ASC";
    List tarefas = await database.rawQuery(sql);

    return tarefas;
  }

  Future<int> insertTarefa(Tarefa tarefa) async{
    var database = await db;

    int result = await database.insert(tableName, tarefa.toMap());

    return result;

  }
  

  Future<int> deleteTarefa(int id) async {
    var database = await db;

    int result = await database.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id]
    );

    return result;
  }

  Future<int> updateTarefa(Tarefa tarefa) async {
    var database = await db;

    int result = await database.update(
      tableName,
      tarefa.toMap(),
      where: "id = ?",
      whereArgs: [tarefa.id]
    );

    return result;
  }

  //edita o atributo "realizada" da tarefa para 1 ou 0 de acordo com a interacao com a lista de tarefas
  Future<int> updateTarefa2(Tarefa tarefa, int realizada) async {
    var database = await db;

    int result = await database.rawUpdate(
      'UPDATE $tableName SET realizada = $realizada WHERE id = ${tarefa.id}'
    );

    return result;
  }
}