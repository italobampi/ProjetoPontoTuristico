import 'package:flutter/material.dart';
import 'package:projetopontoturistico/model/ponto.dart';

import '../cadastro_form_dialog.dart';


class DetalhePage extends StatefulWidget{
  static const ROUTE_NAME ='/teste';
  List<Ponto> pontos = <Ponto>[];
  int index;

  DetalhePage({  Key? key, required this.pontos, required this.index}): super(key: key) ;

  _DetalhePageState createState() => _DetalhePageState();
}
final double padding = 25;
final double spacing = 18;
final sidePadding = EdgeInsets.symmetric(horizontal: padding);

class _DetalhePageState extends State<DetalhePage>{


  final _formKey = GlobalKey<FormState>();

  void initState(){
    super.initState();
  }

  Widget build(BuildContext context){
    Ponto pontoAtual;
    return Scaffold(
      body: criarBody(),

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











}