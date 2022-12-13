import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:projetopontoturistico/pages/detalhe_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dao/ponto_dao.dart';
import '../model/ponto.dart';
import 'filtro_page.dart';

class MapaHomePage extends StatefulWidget {
  @override
  State<MapaHomePage> createState() => MapaHomePageState();
}

class MapaHomePageState extends State<MapaHomePage> {
  Completer<GoogleMapController> _controller = Completer();
  Position? _currentPosition;
  CameraPosition? _cameraPosition;
  late BitmapDescriptor customIcon;
  final Set<Marker> listMarkers = {};
  final _pontos = <Ponto>[];
  final _daoPonto = PontoDao();

  @override
  void initState() {
    super.initState();
    setCustomMarker();
    _determinePosition().then((value) {
      setState(() {
        _currentPosition = value;
        _cameraPosition = CameraPosition(
          target:
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom: 14.4746,
        );
      });
    });

      setState(() {
        _atualizarLista();
        fillMarkersList();
      });

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: _createBody());
  }

  Widget _createBody() {
    if (_cameraPosition == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return GoogleMap(
      mapType: MapType.normal,
      markers: listMarkers,
      initialCameraPosition: _cameraPosition!,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void setCustomMarker() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'images/custom_marker.png');
  }

  void fillMarkersList() {
    for (var ponto in _pontos) {
      listMarkers.add(
        Marker(
            markerId: MarkerId(_pontos.indexOf(ponto).toString()),
            position: LatLng(ponto.latitude!, ponto.longitude!),
            infoWindow: InfoWindow(title: ponto.nome),
            icon: BitmapDescriptor.defaultMarker,
            onTap: () {
              showCupertinoModalBottomSheet(
                context: context,
                builder: (context) => DetalhePage(ponto: ponto),
              );
            }),
      );
    }
  }



  void _atualizarLista() async {

    await Future.delayed(Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    final campoOrdenacao = prefs.getString(FiltroPage.chaveCampoOrdenacao) ?? Ponto.ID;
    final usarOrdemDecrescente = prefs.getBool(FiltroPage.chaveOrdenacaoDrescente) == true;
    final filtroDescricao = prefs.getString(FiltroPage.chaveFiltroDescricao) ?? '';

    final  pontos = await _daoPonto.listar(
      filtro: filtroDescricao,
      campoOrdenacao: campoOrdenacao,
      usarOrdemDecrescente: usarOrdemDecrescente,
    );
    setState(() {
      _pontos.clear();
      if (pontos.isNotEmpty) {
        _pontos.addAll(pontos);
      }
    });
}
}