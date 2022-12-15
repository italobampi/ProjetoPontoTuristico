import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:projetopontoturistico/model/cidade_info.dart';
import 'package:projetopontoturistico/model/estado_info.dart';
class Cep {
 String? bairro;
 String? cidade;
 String? logradouro;
 @JsonKey(name: 'estado_info')
 EstadoInfo? estadoInfo;
 String? cep;
 @JsonKey(name: 'cidade_info')
 CidadeInfo? cidadeInfo;
 String? estado;

 Cep({this.bairro, this.cidade, this.logradouro, this.estadoInfo, this.cep,
      this.cidadeInfo, this.estado});

 factory Cep.fromJson(Map<String, dynamic> json) {
  return Cep(
      bairro:json['bairro'] as String,
      cidade:json['cidade'] as String ,
      logradouro:json['logradouro'] as String,
      estadoInfo: new EstadoInfo.fromJson(json) , 
      cep: json['cep'] as String, 
      cidadeInfo: new CidadeInfo.fromJson(json),
      estado: json['estado'] as String
  );
 }


}
