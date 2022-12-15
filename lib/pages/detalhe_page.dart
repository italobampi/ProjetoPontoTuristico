import 'package:flutter/material.dart';
import 'package:projetopontoturistico/model/cep.dart';
import 'package:projetopontoturistico/model/ponto.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:projetopontoturistico/service/cep_service.dart';
import 'package:projetopontoturistico/utils/util_geo.dart';

class DetalhePage extends StatefulWidget {
  static const ROUTE_NAME = '/teste';
  Ponto ponto ;


  DetalhePage({Key? key, required this.ponto, })
      : super(key: key);

  @override
  _DetalhePageState createState() => _DetalhePageState();
}

const double padding = 25;
const double spacing = 18;
const sidePadding = EdgeInsets.symmetric(horizontal: padding);

class _DetalhePageState extends State<DetalhePage> {
  final _formKey = GlobalKey<FormState>();
  Position? _localizacao;
  Cep? _cep ;
  CepService _service = CepService();
  double distancia = 1;
  late Ponto pontoAtual;


  @override
  void initState() {
    super.initState();
    _findCep();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: criarBody(),
    );
  }

  Widget criarBody() {
     pontoAtual = widget.ponto;
     _findCep();

    return Align(
      alignment: Alignment.center,
      child: SafeArea(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Image.network(
                              pontoAtual.imagen,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 4,
                              fit: BoxFit.fill),
                          Positioned(
                            width: MediaQuery.of(context).size.width,
                            //top: ,
                            child: Padding(
                              padding: sidePadding,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            const BorderRadius.all(
                                                Radius.circular(15.0)),
                                            border: Border.all(
                                                color: const Color.fromRGBO(
                                                    141, 141, 141, 1.0)
                                                    .withAlpha(40),
                                                width: 2)),
                                        padding: const EdgeInsets.all(8.0),
                                        child: const Center(
                                            child: Icon(
                                                Icons.keyboard_backspace,
                                                color: Colors.blue))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: sidePadding,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: spacing),
                                SizedBox(
                                    width: 300,
                                    child: Text(
                                      pontoAtual?.nome ?? '',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'Roboto',
                                        letterSpacing: 0.5,
                                        fontSize: 20,
                                        height: 1,
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: spacing),
                      Padding(
                          padding: sidePadding,
                          child: Row(
                            children: [
                              const IconTheme(
                                data: IconThemeData(color: Colors.grey),
                                child: Icon(Icons.description),
                              ),
                              const SizedBox(
                                width: spacing,
                              ),
                              Text(pontoAtual?.descricao ?? ''),
                            ],
                          )), const SizedBox(height: spacing),
                      Padding(
                          padding: sidePadding,
                          child: Row(
                            children: [
                              const IconTheme(
                                data: IconThemeData(color: Colors.grey),
                                child: Icon(Icons.difference),
                              ),
                              const SizedBox(
                                width: spacing,
                              ),
                              Text(pontoAtual?.diferencial ?? ''),
                            ],
                          )),
                      const SizedBox(height: spacing),
                      Padding(
                          padding: sidePadding,
                          child: Row(
                            children: [
                              const IconTheme(
                                data: IconThemeData(color: Colors.grey),
                                child: Icon(Icons.calendar_today_outlined),
                              ),
                              const SizedBox(
                                width: spacing,
                              ),
                              Text(pontoAtual?.dataFormatada ?? ''),
                            ],
                          )),
                      const SizedBox(height: spacing),
                      Padding(
                        padding: sidePadding,
                        child: Row(
                          children: [
                            IconTheme(data: IconThemeData(color: Colors.grey),
                                child: Icon(Icons.maps_home_work_outlined)),
                            const SizedBox(
                              width: spacing,
                            ),
                            Column(
                              children: [
                                Text(_cep?.estadoInfo?.nome ?? ''),
                                Text(_cep?.cidade ?? ''),
                                Text(_cep?.bairro ?? ''),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: spacing),


                      Padding(
                          padding: sidePadding,
                          child: Row(
                            children: [
                              const IconTheme(
                                data: IconThemeData(color: Colors.grey),
                                child: Icon(Icons.location_on_outlined),
                              ),
                              const SizedBox(
                                width: spacing,
                              ),
                              Text(' Latitude: ${pontoAtual?.latitude}'),

                            ],
                          )),

                      Padding(
                          padding: sidePadding,
                        child: Row(
                          children: [
                            const SizedBox(height: spacing, width: spacing*2.3,),
                            Text(' Logitude: ${pontoAtual?.longitude}'),
                          ],
                        ),
                      ),
                      const SizedBox(height: spacing),
                      Padding(
                          padding: sidePadding,
                          child: Row(
                            children: [
                              const IconTheme(
                                data: IconThemeData(color: Colors.grey),
                                child: Icon(Icons.map_outlined),
                              ),
                              const SizedBox(
                                width: spacing,
                              ),
                              Text('Maps'),
                              const SizedBox(
                                width: spacing*3,
                              ),
                              IconTheme(
                                data: IconThemeData(color: Colors.grey),
                                child: ElevatedButton(
                                  child:  Icon(Icons.map) ,
                                  onPressed: _abrirNoMapaEx,
                                ),
                              ),
                            ],
                          )
                      ),
                      Padding(
                          padding: sidePadding,
                          child: Row(
                            children: [

                              IconTheme(
                                data: IconThemeData(color: Colors.grey),
                                child: Icon(Icons.align_vertical_center)
                              ),
                              const SizedBox(
                                width: spacing*2,
                              ),
                              ElevatedButton(
                                child:  Text('Distacia') ,
                                onPressed: _distancia,
                              ),
                              const SizedBox(
                                width: spacing*2,
                              ),
                              Text('Distacia  ${distancia} metros'),
                            ],
                          )
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
  void  _abrirNoMapaEx(){
    if(widget.ponto.latitude == null || widget.ponto.longitude == null){
      return;
    }
    MapsLauncher.launchCoordinates(widget.ponto.latitude!.toDouble(), widget.ponto.longitude!.toDouble(),widget.ponto.nome);
  }

  Future<void> _findCep() async{
    try{
      var _rcep = await _service.findCepAsObject('89990000');
      setState(() {
        _cep = _rcep;
      });
    } catch(e){
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Ocorreu um erro ao consultar o CEP. Tente novamente'),
      ));
    }
  }
  Future<void> _distancia()async {
   if(pontoAtual.longitude !=null && pontoAtual.latitude !=null ){
     double resul = await utilDistancia(pontoAtual.latitude!,pontoAtual.longitude!) as double;
     setState(() {
       distancia = resul;
     });
   }

  }



}