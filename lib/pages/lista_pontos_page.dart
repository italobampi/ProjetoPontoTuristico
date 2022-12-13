import 'package:flutter/material.dart';
import 'package:projetopontoturistico/cadastro_form_dialog.dart';
import 'package:projetopontoturistico/dao/ponto_dao.dart';
import 'package:projetopontoturistico/model/ponto.dart';
import 'package:projetopontoturistico/pages/detalhe_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'filtro_page.dart';

class ListaPontosPage extends StatefulWidget{

  @override
  _ListaPontosPageState createState() => _ListaPontosPageState();
}

class _ListaPontosPageState extends State<ListaPontosPage>{

  static const ACAO_EDITAR = 'editar';
  static const ACAO_EXCLUIR = 'excluir';
  static const ACAO_DETALHES = 'detalhes';
  final _pontos = <Ponto>[];
  final _daoPonto = PontoDao();
  var _carregando = false;
  Position? _localizacaoAtual;

  @override
  void initState() {
    super.initState();
    _atualizarLista();

  }


  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: criarAppBar(),
      body: criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirForm,
        tooltip: 'Novo ponto turistico',
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar criarAppBar(){
    return AppBar(
      title: const Text('Pontos turisticos'),
      actions: [
        IconButton (
          icon: const Icon(Icons.filter_list),
          onPressed: _abrirPaginaFiltro,
        )
      ],
    );
  }

  Widget criarBody(){
    if (_carregando){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.center,
            child: CircularProgressIndicator(),
          ),
          Align(
            alignment: AlignmentDirectional.center,
            child: Padding(
              padding: EdgeInsets.only(top:10),
              child: Text('Carregando os Pontos Turisticos ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          )
        ],
      );
    }
    if(_pontos.isEmpty){
      return const Center(
        child: Text(
          'Nenhum Ponto Turistico Adicionado',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold
          ),
        ),
      );
    }
    return ListView.separated(
      itemCount: _pontos.length,
      itemBuilder: (BuildContext context, int index){
        final ponto = _pontos[index];
        return PopupMenuButton<String>(
          child:  ListTile(
        title: Text('${ponto.nome}'),
        subtitle: Text('${ponto.descricao}'),

        

        ),
          itemBuilder: (BuildContext context) => criarItensMenuPopup(),
          onSelected: (String valorSelecionado){
            if (valorSelecionado == ACAO_EDITAR){
              _abrirForm(pontoAtual: ponto,indice: index);
            }else if (valorSelecionado == ACAO_EXCLUIR){
              _excluir(ponto);
            }else {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => DetalhePage(ponto: ponto),
              ));
            }
          },
        );

      }, separatorBuilder: (BuildContext context, int index) => const Divider() ,
    );
  }

  void _abrirPaginaFiltro(){
    final navigator = Navigator.of(context);
    navigator.pushNamed(FiltroPage.ROUTE_NAME).then((alterouValores){
      if (alterouValores == true){
        _atualizarLista();
      }
    }
    );
  }
  void _abrirForm( {Ponto? pontoAtual, int? indice} ){
    final key = GlobalKey<CadastroFormDialogState>();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(pontoAtual == null ? 'Novo Ponto': 'Alterar Ponto ${pontoAtual.id}'),
            content: CadastroFormDialog(key: key, pontoAtual: pontoAtual,),
            actions: [
              TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () => Navigator.of(context).pop()),
              TextButton(
                child: const Text('Salvar'),
                onPressed: (){
                  if (key.currentState != null  && key.currentState!.dadosValidos()){
                    setState(() {
                      final novoPonto = key.currentState!.novoPonto;
                      _daoPonto.salvar(novoPonto).then((success) {
                        if (success) {
                          _atualizarLista();
                        }
                      });
                    });
                    Navigator.of(context).pop();
                  }
                },
              )

            ],
          );
        }
    );
  }

  List<PopupMenuEntry<String>> criarItensMenuPopup(){
    return[
      PopupMenuItem<String>(
        value: ACAO_DETALHES,
        child: Row(
          children: const [
            Icon(Icons.details, color: Colors.black),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text('Detalhes'),
            ),
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: ACAO_EDITAR,
        child: Row(
          children: const [
            Icon(Icons.edit, color: Colors.black),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text('Editar'),
            ),
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: ACAO_EXCLUIR,
        child: Row(
          children: const [
            Icon(Icons.delete, color: Colors.red),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text('Excluir'),
            ),
          ],
        ),

      ),
    ];
  }

  void _excluir(Ponto ponto){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Row(
              children: const [
                Icon(Icons.warning, color: Colors.red),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text('Atenção'),
                ),
              ],
            ),
            content: const Text('Esse registro será removido definitivamente'),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: (){
                  Navigator.of(context).pop();
                  if (ponto.id == null){
                    return;
                  }
                  _daoPonto.remover(ponto.id!).then((success){
                    if (success) {
                      _atualizarLista();
                    }
                  });

                },
              )
            ],
          );
        }
    );
  }




  void _atualizarLista() async {
    setState(() {
      _carregando = true;
    });
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
      _carregando = false;
      _pontos.clear();
      if (pontos.isNotEmpty) {
        _pontos.addAll(pontos);
      }
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
