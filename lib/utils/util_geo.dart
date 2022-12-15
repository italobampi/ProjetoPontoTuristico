import 'dart:ffi';

import 'package:geolocator/geolocator.dart';


Future<Position?> _utilObterLocalizacaoAtual() async {
  bool servicoHabilitado = await _servicoHabilitado();
  if (!servicoHabilitado) {
    return null;
  }
  bool permissoesPermitidas = await _permissoesPermitidas();
  if (!permissoesPermitidas) {
    return null;
  }
  return  await Geolocator.getCurrentPosition();
}

Future<double?> utilDistancia(double latitude, double longitude) async{
  Position position = await _utilObterLocalizacaoAtual() as Position;

  return Geolocator.distanceBetween(position.latitude, position.longitude, latitude, longitude);
}


Future<bool> _servicoHabilitado() async {
  bool servicoHabilitado = await Geolocator.isLocationServiceEnabled();
  if (!servicoHabilitado) {

    Geolocator.openLocationSettings();
    return false;
  }
  return true;
}
Future<bool> _permissoesPermitidas() async {
  LocationPermission permissao = await Geolocator.checkPermission();
  if (permissao == LocationPermission.denied) {
    permissao = await Geolocator.requestPermission();
    if (permissao == LocationPermission.denied) {
      return false;
    }
  }
  if (permissao == LocationPermission.deniedForever) {

    Geolocator.openAppSettings();
    return false;
  }
  return true;
}

