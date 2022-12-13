import 'package:projetopontoturistico/database/database_provider.dart';
import 'package:projetopontoturistico/model/ponto.dart';

class PontoDao {
  final databaseProvider = DatabaseProvider.instance;

  Future<bool> salvar(Ponto ponto) async {
    final database = await databaseProvider.database;
    final valores = ponto.toMap();
    if (ponto.id == null) {
      ponto.id = await database.insert(Ponto.nomeTabela, valores );
      return true;
    } else {
      final registrosAtualizados = await database.update(
        Ponto.nomeTabela,
        valores,
        where: '${Ponto.ID} = ?',
        whereArgs: [ponto.id],
      );
      return registrosAtualizados > 0;
    }
  }
  Future<bool> remover(int id) async {
    final database = await databaseProvider.database;
    final registrosAtualizados = await database.delete(
      Ponto.nomeTabela,
      where: '${Ponto.ID} = ?',
      whereArgs: [id],
    );
    return registrosAtualizados > 0;
  }

  Future<List<Ponto>> listar({
    String filtro = '',
    String campoOrdenacao = Ponto.ID,
    bool usarOrdemDecrescente = false,
  }) async {
    String? where;
    if (filtro.isNotEmpty) {
      where = "UPPER(${Ponto.DESCRICAO}) LIKE '${filtro.toUpperCase()}%'";
    }
    var orderBy = campoOrdenacao;
    if (usarOrdemDecrescente) {
      orderBy += ' DESC';
    }
    final database = await databaseProvider.database;
    final resultado = await database.query(
      Ponto.nomeTabela,
      columns: [
        Ponto.ID,
        Ponto.NOME,
        Ponto.DESCRICAO,
        Ponto.DIFERENCIAl,
        Ponto.DATA,
        Ponto.LATITUDE,
        Ponto.LONGITUDE,
        Ponto.IMAGEN,
      ],
      where: where,
      orderBy: orderBy,
    );
    return resultado.map((m) => Ponto.fromMap(m)).toList();
  }
}