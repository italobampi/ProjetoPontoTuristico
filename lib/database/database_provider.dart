import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import '../model/ponto.dart';


class DatabaseProvider {
  static const _dbName = 'cadastro_Pontos.db';
  static const _dbVersion = 3;

  DatabaseProvider._init();
  static final DatabaseProvider instance = DatabaseProvider._init();

  Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final dbPath = '$databasesPath/$_dbName';
    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE table ${Ponto.nomeTabela} (
        ${Ponto.ID} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Ponto.NOME} TEXT NOT NULL,
        ${Ponto.DESCRICAO} TEXT NOT NULL,
        ${Ponto.DIFERENCIAl} TEXT,
        ${Ponto.DATA} TEXT,
        ${Ponto.LONGITUDE} NUMERIC,
        ${Ponto.LATITUDE} NUMERIC,
        ${Ponto.IMAGEN} TEXT,
        ${Ponto.CEP} TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    switch (oldVersion) {
      case 3:
        await db.execute('''
          ALTER TABLE ${Ponto.nomeTabela}
          ADD ${Ponto.CEP} TEXT
        ''');

    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }
}