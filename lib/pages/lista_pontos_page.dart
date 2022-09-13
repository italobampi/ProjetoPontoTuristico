import 'package:flutter/material.dart';
import 'package:projetopontoturistico/model/ponto.dart';

class ListaPontosPage extends StatefulWidget{

  _ListaPontosPageState createState() => _ListaPontosPageState();
}

class _ListaPontosPageState extends State<ListaPontosPage>{
  final _pontos = <Ponto>[
    Ponto(id: 1, nome: 'jojo', descricao: 'descricao', data: DateTime.now()),
    Ponto(id: 1, nome: 'jojo', descricao: 'descricao', data: DateTime.now().add(Duration(days: 1))),
  ];

  Widget build (BuildContext context){
    return Scaffold(
      appBar: criarAppBar(),
      body: criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>{},
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
          onPressed: () {},
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
        return ListTile(
          title: Text('${ponto.nome}'),
          subtitle: Text('${ponto.descricao}')
        );
      }, separatorBuilder: (BuildContext context, int index) => Divider() ,
    );
  }
}
