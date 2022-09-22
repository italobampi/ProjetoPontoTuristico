import 'package:flutter/material.dart';
import 'package:projetopontoturistico/model/ponto.dart';

import '../cadastro_form_dialog.dart';


class TestePage extends StatefulWidget{
  static const ROUTE_NAME ='/teste';
  List<Ponto> pontos = <Ponto>[];
  int index;

  TestePage({  Key? key, required this.pontos, required this.index}): super(key: key) ;

  _TestePageState createState() => _TestePageState();
}
final double padding = 25;
final double spacing = 18;
final sidePadding = EdgeInsets.symmetric(horizontal: padding);

class _TestePageState extends State<TestePage>{
  static const ACAO_EDITAR = 'editar';
  static const ACAO_EXCLUIR = 'excluir';

  final _formKey = GlobalKey<FormState>();

  void initState(){
    super.initState();
  }

  Widget build(BuildContext context){
    Ponto pontoAtual;
    return Scaffold(
      body: criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>{
         pontoAtual = widget.pontos[widget.index],
        PopupMenuButton<String>(

        itemBuilder: (BuildContext context) => criarItensMenuPopup(),
        onSelected: (String valorSelecionado){
        if (valorSelecionado == ACAO_EDITAR){
        _abrirForm(pontoAtual: pontoAtual,indice: widget.index);
        }else{
        _excluir(widget.index);
        }
        },
        ),
        },
        tooltip: 'Opiçoes',
        child: Icon(Icons.data_saver_on),
      ),
    );
  }


  Widget criarBody() {
    Ponto pontoAtual = widget.pontos[widget.index];
    return Align(
      alignment: Alignment.center,
      child: SafeArea(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Image.network('https://static6.depositphotos.com/1000244/600/i/950/depositphotos_6009429-stock-photo-sunbeam.jpg',
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.0)),
                                            border: Border.all(
                                                color: Color.fromRGBO(
                                                    141, 141, 141, 1.0)
                                                    .withAlpha(40),
                                                width: 2)),
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
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
                                SizedBox(
                                    width: 300,
                                    child: Text(
                                      pontoAtual?.nome ?? '',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'Roboto',
                                        letterSpacing: 0.5,
                                        fontSize: 20,
                                        height: 1,
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: spacing),
                      Padding(
                          padding: sidePadding,
                          child: Row(
                            children: [
                              IconTheme(
                                data: IconThemeData(color: Colors.grey),
                                child: Icon(Icons.location_on_outlined),
                              ),
                              SizedBox(width: spacing,),
                              Text( pontoAtual?.descricao??''
                                  ),
                            ],
                          )),
                      SizedBox(height: spacing),
                      Padding(
                          padding: sidePadding,
                          child: Row(
                            children: [
                              IconTheme(
                                data: IconThemeData(color: Colors.grey),
                                child: Icon(Icons.calendar_today_outlined),
                              ),
                              SizedBox(width: spacing,),
                              Text(pontoAtual?.dataFormatada ?? ''),
                            ],
                          )),
                      SizedBox(height: spacing),
                      Padding(
                        padding: sidePadding,
                        child: Text(
                            pontoAtual?.descricao??''),
                      ),
          SizedBox(height: spacing*3),

                    ],
                  ),
                )
              ],
            )),
      ),
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





  void _abrirForm( {Ponto? pontoAtual, int? indice} ){
    List<Ponto> pontos = widget.pontos;
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

                        pontos[widget.index] = novoPonto;

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
                    widget.pontos.removeAt(indice);
                  });

                },
              )
            ],
          );
        }
    );
  }
}