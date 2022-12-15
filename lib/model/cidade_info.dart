import 'package:json_annotation/json_annotation.dart';
class CidadeInfo {
  String? area_km2;
  String? codigo_ibge;

  CidadeInfo({this.area_km2, this.codigo_ibge});

  factory CidadeInfo.fromJson(Map<String, dynamic> json){
    return CidadeInfo(
        area_km2: json['cidade_info']['area_km2'] as String,
        codigo_ibge:json['cidade_info']['codigo_ibge'] as String
    );
  }
}