import 'package:intl/intl.dart';

class Ponto {

  static const nomeTabela = 'ponto';
static const ID = '_id';
static const NOME ='_nome';
static const DESCRICAO ='_descricao';
static const DIFERENCIAIS ='_diferenciais';
static const DATA = '_data';
static const LONGITUDE = 'longitude';
static const LATITUDE = 'latitude';
static const IMAGEN = 'imagen';

 int id;
 String nome;
 String descricao;
 String diferencial;
DateTime data;
double? longitude;
double? latitude;
String? imagen;


Ponto({required this.id, required this.nome, required this.descricao,
  required this.data,required this.diferencial });

String get dataFormatada{
  if(data == null){
    return '';
  }
  return DateFormat('dd/MM/yyyy').format(data);
}

 Map<String, dynamic> toMap() =>{
  ID: id,
   NOME : nome,
   DESCRICAO: descricao,
   DIFERENCIAIS: diferencial,
   DATA:  DateFormat("yyyy-MM-dd").format(data),
   LONGITUDE: longitude,
   LATITUDE: latitude,
   //IMAGEN: imagen,
 };

factory Ponto.fromMap(Map<String, dynamic> map)=> Ponto(
    id: map[ID] is int ? map[ID] : null ,
    nome: map[NOME] is String ? map[NOME] : '' ,
    descricao: map[DESCRICAO] is String ? map[DESCRICAO] : '',
    //latitude: map[LATITUDE] is double ? map[LATITUDE] : '' ,
  //
  // longitude:  map[LONGITUDE] is double ? map[LONGITUDE] : '' ,
    data: map[Ponto.DATA],
    diferencial: map[DIFERENCIAIS] is String ? map[DIFERENCIAIS] : '',
);

}