import 'package:intl/intl.dart';
class EstadoInfo{

  String? area_km2;
  String? codigo_ibge;
  String? nome;


  EstadoInfo({this.area_km2, this.codigo_ibge, this.nome});

  factory EstadoInfo.fromJson(Map<String,dynamic>json){
    return EstadoInfo(
        area_km2: json['estado_info']['area_km2'] as String,
      codigo_ibge:json['estado_info']['codigo_ibge'] as String,
      nome: json['estado_info']['nome'] as String
    );
  }

}

