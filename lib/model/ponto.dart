import 'package:intl/intl.dart';

class Ponto {

  static const nomeTabela = 'ponto';
static const ID = '_id';
static const NOME ='_nome';
static const DESCRICAO ='_descricao';
static const DIFERENCIAl ='_diferenciais';
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
  required this.data,required this.diferencial , required this.latitude, required this.longitude, required this.imagen});

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
    DIFERENCIAl: diferencial,
    DATA:  DateFormat("yyyy-MM-dd").format(data),
    LONGITUDE: longitude,
    LATITUDE: latitude,
    IMAGEN: imagen == null ?
    'https://static6.depositphotos.com/1000244/600/i/950/depositphotos_6009429-stock-photo-sunbeam.jpg' : imagen ,
  };

factory Ponto.fromMap(Map<String, dynamic> map)=> Ponto(
    id: map[ID] is int ? map[ID] : null ,
    nome: map[NOME] is String ? map[NOME] : '' ,
    descricao: map[DESCRICAO] is String ? map[DESCRICAO] : '',
    latitude: map[LATITUDE] is double ? map[LATITUDE] : 0.0 ,
   longitude:  map[LONGITUDE] is double ? map[LONGITUDE] : 0.0 ,
    data: map[Ponto.DATA] is String ? DateFormat("yyyy-MM-dd").parse(map[DATA]): DateTime.now(),
    diferencial: map[DIFERENCIAl] is String ? map[DIFERENCIAl] : '',
  imagen: map[IMAGEN] is String ? map[IMAGEN] : 'https://static6.depositphotos.com/1000244/600/i/950/depositphotos_6009429-stock-photo-sunbeam.jpg',
);

}