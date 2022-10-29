import 'package:flutter/material.dart';
import 'package:projetopontoturistico/model/ponto.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Ponto pontoAtual;
    return Scaffold(
      body: criarBody(),
    );
  }

  Widget criarBody() {
    Ponto pontoAtual = widget.ponto;
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
                              'https://static6.depositphotos.com/1000244/600/i/950/depositphotos_6009429-stock-photo-sunbeam.jpg',
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
                                child: Icon(Icons.location_on_outlined),
                              ),
                              const SizedBox(
                                width: spacing,
                              ),
                              Text(pontoAtual?.descricao ?? ''),
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
                        child: Text(pontoAtual?.descricao ?? ''),
                      ),
                      const SizedBox(height: spacing * 3),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
