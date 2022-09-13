import 'package:intl/intl.dart';

class Ponto {
static const ID = '_id';
static const NOME ='_nome';
static const DESCRICAO ='_descricao';
static const DATA = '_data';

 int id;
 String nome;
 String descricao;
DateTime? data;

Ponto({required this.id, required this.nome, required this.descricao,required this.data});

String get dataFormatada{
  if(data == null){
    return '';
  }
  return DateFormat('dd/MM/yyyy').format(data!);
}

}