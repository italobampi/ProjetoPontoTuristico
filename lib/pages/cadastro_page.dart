import 'package:flutter/material.dart';
import 'package:projetopontoturistico/model/cep.dart';
import 'package:projetopontoturistico/model/ponto.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:projetopontoturistico/service/cep_service.dart';
import 'package:projetopontoturistico/utils/util_geo.dart';
import 'dart:math';
import '../dao/ponto_dao.dart';

class CadastroPage extends StatefulWidget {
  static const ROUTE_NAME = '/cadastro';
  final Ponto? pontoAtual;


  CadastroPage({Key? key,  this.pontoAtual})
      : super(key: key);

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

const double padding = 25;
const double spacing = 18;
const sidePadding = EdgeInsets.symmetric(horizontal: padding);

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _daoPonto = PontoDao();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _diferencialController = TextEditingController();
  final _cepController = TextEditingController();
  Position? _localizacaoAtual;
  Ponto? pontoAtual ;
  String urlImagem ='';
  Random random = Random();


  @override
  void initState(){
    super.initState();
    _obterLocalizacaoAtual();
    if (widget.pontoAtual != null){
      _descricaoController.text = widget.pontoAtual!.descricao;
      _nomeController.text= widget.pontoAtual!.nome;
      _diferencialController.text=widget.pontoAtual!.diferencial;
      _cepController.text=widget.pontoAtual!.cep!;
    }
  }

  @override
  Widget build(BuildContext context) {
    imagem();
    return Scaffold(
      body: criarBody(),
    );
  }

  Widget criarBody() {
    pontoAtual = widget.pontoAtual;

    return Align(
      alignment: Alignment.center,
      child: SafeArea(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.9,
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
                             urlImagem,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 4,
                              fit: BoxFit.fill
                          ),
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
                                  Text(pontoAtual == null ? 'Novo Ponto': 'Alterar Ponto ${pontoAtual?.nome}',
                                    style: const TextStyle(
                                      color: Colors.purpleAccent,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'Roboto',
                                      letterSpacing: 0.5,
                                      fontSize: 30,
                                      height: 1,
                                    ),
                                  ),


                                  const SizedBox(height: spacing),
                                ],
                              ),

                            ),
                          ),

                        ],
                      ),

                      Row(
                        children: [
                          SizedBox(width: spacing*5,),
                          InkWell(
                            onTap: () {
                             imagem();
                            },

                            child: Container(
                                width: 200,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    const BorderRadius.all(
                                        Radius.circular(15.0)),
                                    border: Border.all(
                                        color: Color.fromARGB(20, 80, 12, 9),
                                        width: 2)),
                                padding: const EdgeInsets.all(8.0),
                                child: const Center(
                                    child: Text('Trocar Imagem'
                                    ))),
                          ),
                        ],
                      ),

                      Container(
                         width: MediaQuery.of(context).size.width,
                        padding: sidePadding,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _nomeController,
                                decoration: const InputDecoration(labelText: 'Nome',),
                                validator: (String? valor){
                                  if (valor == null || valor.isEmpty){
                                    return 'Informe O Nome';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _descricaoController,
                                decoration: const InputDecoration(labelText: 'Descrição',),
                                validator: (String? valor){
                                  if (valor == null || valor.isEmpty){
                                    return 'Informe a descrição';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _diferencialController,
                                decoration: const InputDecoration(labelText: 'Diferenciais',),
                                validator: (String? valor){
                                  if (valor == null || valor.isEmpty){
                                    return 'Informe os diferenciais';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _cepController,
                                decoration: const InputDecoration(labelText: 'Cep',),
                                validator: (String? valor){
                                  if (valor == null || valor.isEmpty){
                                    return 'Informe o Cep';
                                  }
                                  return null;
                                },
                              ),

                              Padding(
                                padding: sidePadding,
                                child: Row(children: [
                                  TextButton(
                                      child: const Text('Cancelar'),
                                      onPressed: () => Navigator.of(context).pop()),
                                  TextButton(
                                      child: const Text('Salvar'),
                                      onPressed: (){
                                        setState(() {
                                          _daoPonto.salvar(this.novoPonto).then((success) {
                                            if (success) {
                                              Navigator.of(context).pop();
                                            }
                                          });
                                        });
                                      }
                                  )
                                ],),
                              ),
                            ],
                          ),
                        ),
                      )


                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }




  Ponto get novoPonto => Ponto(
      id: widget.pontoAtual?.id! ?? null,
      descricao: _descricaoController.text,
      data: DateTime.now(),
      nome: _nomeController.text,
      diferencial: _diferencialController.text,
      imagen: urlImagem,
      longitude: _localizacaoAtual?.longitude ,
      latitude: _localizacaoAtual?.latitude,
      cep: _cepController.text
  );

  void imagem(){

    setState(() {
      urlImagem = 'https://picsum.photos/id/${random. nextInt(100)}/200/200.jpg';
    });
  }


  void _obterLocalizacaoAtual() async {
    bool servicoHabilitado = await _servicoHabilitado();
    if (!servicoHabilitado) {
      return;
    }
    bool permissoesPermitidas = await _permissoesPermitidas();
    if (!permissoesPermitidas) {
      return;
    }
    _localizacaoAtual = await Geolocator.getCurrentPosition();
    setState(() {

    });
  }
  Future<bool> _servicoHabilitado() async {
    bool servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilitado) {
      await _mostrarDialogMensagem('Para utilizar esse recurso, você deverá '
          'habilitar o serviço de localização do dispositivo');
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
        _mostrarMensagem(
            'Não será possível utilizar o recurso por falta de permissão');
        return false;
      }
    }
    if (permissao == LocationPermission.deniedForever) {
      await _mostrarDialogMensagem(
          'Para utilizar esse recurso, você deverá acessar as configurações '
              'do app e permitir a utilização do serviço de localização');
      Geolocator.openAppSettings();
      return false;
    }
    return true;
  }
  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mensagem),
    ));
  }

  Future<void> _mostrarDialogMensagem(String mensagem) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Atenção'),
        content: Text(mensagem),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }


}