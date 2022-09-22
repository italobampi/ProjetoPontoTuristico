import 'package:intl/intl.dart';

class Ponto {
static const ID = '_id';
static const NOME ='_nome';
static const DESCRICAO ='_descricao';
static const DIFERENCIAIS ='_diferenciais';
static const DATA = '_data';
static const LONGITUDE = 'longitude';
static const LATITUDE = 'latitude';

 int id;
 String nome;
 String descricao;
 String diferencial;
DateTime data;
double? longitude;
double? latitude;


Ponto({required this.id, required this.nome, required this.descricao,required this.data,required this.diferencial});

String get dataFormatada{
  if(data == null){
    return '';
  }
  return DateFormat('dd/MM/yyyy').format(data!);
}

}