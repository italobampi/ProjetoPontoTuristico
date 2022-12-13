import 'package:flutter/material.dart';
import 'package:projetopontoturistico/model/ponto.dart';
import 'package:geolocator/geolocator.dart';

class CadastroFormDialog extends StatefulWidget{
  final Ponto? pontoAtual;

  const CadastroFormDialog( {Key? key, this.pontoAtual}) : super(key: key);

  @override
  CadastroFormDialogState createState() => CadastroFormDialogState();
}

class CadastroFormDialogState extends State<CadastroFormDialog>{

  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _diferencialController = TextEditingController();
  Position? _localizacaoAtual;


  @override
  void initState(){
    super.initState();
    _obterLocalizacaoAtual();
    if (widget.pontoAtual != null){
      _descricaoController.text = widget.pontoAtual!.descricao;
      _nomeController.text= widget.pontoAtual!.nome;
      _diferencialController.text=widget.pontoAtual!.diferencial;


    }
  }

  @override
  Widget build(BuildContext context){
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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

        ],
      ),
    );
  }



  bool dadosValidos() => _formKey.currentState?.validate() == true;

  Ponto get novoPonto => Ponto(
    id: widget.pontoAtual?.id! ?? null,
    descricao: _descricaoController.text,
    data: DateTime.now(),
    nome: _nomeController.text,
    diferencial: _diferencialController.text,
      imagen: '',
      longitude: _localizacaoAtual?.longitude ,
      latitude: _localizacaoAtual?.latitude
  );



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