import 'package:flutter/material.dart';
import 'package:projetopontoturistico/cadastro_form_dialog.dart';
import 'package:projetopontoturistico/model/ponto.dart';
import 'package:projetopontoturistico/pages/detalhe_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'filtro_page.dart';

class ListaPontosPage extends StatefulWidget{

  _ListaPontosPageState createState() => _ListaPontosPageState();
}

class _ListaPontosPageState extends State<ListaPontosPage>{
  var _ultimoId = 0;
  static const ACAO_EDITAR = 'editar';
  static const ACAO_EXCLUIR = 'excluir';
  final _pontos = <Ponto>[
    Ponto(id: 1, nome: 'jojo', descricao: 'descricao',diferencial: 'tyftrd', data: DateTime.now()),
    Ponto(id: 1, nome: 'jojo', descricao: 'descricao',diferencial: 'tyftrd', data: DateTime.now().add(Duration(days: 1))),
  ];

  Widget build (BuildContext context){
    return Scaffold(
      appBar: criarAppBar(),
      body: criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirForm,
        tooltip: 'Novo ponto turistico',
        child: Icon(Icons.add),
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
    if(_pontos.isEmpty){
      return Center(
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
        onLongPress: () {
        showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => DetalhePage(pontos: _pontos,index: index,),

        );
        },
        

        ),
          itemBuilder: (BuildContext context) => criarItensMenuPopup(),
          onSelected: (String valorSelecionado){
            if (valorSelecionado == ACAO_EDITAR){
              _abrirForm(pontoAtual: ponto,indice: index);
            }else{
              _excluir(index);
            }
          },
        );

      }, separatorBuilder: (BuildContext context, int index) => Divider() ,
    );
  }

  void _abrirPaginaFiltro(){
    final navigator = Navigator.of(context);
    navigator.pushNamed(FiltroPage.ROUTE_NAME).then((alterouValores){
      if (alterouValores == true){

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
                      if(indice == null){
                        novoPonto.id = ++ _ultimoId;
                        _pontos.add(novoPonto);
                      }else{
                        _pontos[indice] = novoPonto;
                      }
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
        value: ACAO_EDITAR,
        child: Row(
          children: const [
            Icon(Icons.edit, color: Colors.black),
            Padding(
              padding: EdgeInsets.only(left: 10),
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
              padding: EdgeInsets.only(left: 10),
              child: Text('Excluir'),
            ),
          ],
        ),

      ),
    ];
  }

  void _excluir(int indice){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Row(
              children: const [
                Icon(Icons.warning, color: Colors.red),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('Atenção'),
                ),
              ],
            ),
            content: Text('Esse registro será removido definitivamente'),
            actions: [
              TextButton(
                child: Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text('OK'),
                onPressed: (){
                  Navigator.of(context).pop();
                  setState(() {
                    _pontos.removeAt(indice);
                  });

                },
              )
            ],
          );
        }
    );
  }
}
