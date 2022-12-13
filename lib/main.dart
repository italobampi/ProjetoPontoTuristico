import 'package:flutter/material.dart';
import 'package:projetopontoturistico/pages/filtro_page.dart';
import 'package:projetopontoturistico/pages/lista_pontos_page.dart';
import 'package:projetopontoturistico/pages/detalhe_page.dart';
import 'package:projetopontoturistico/pages/mapa_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(


        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ponto turistico',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListaPontosPage(),
      routes: {
        FiltroPage.ROUTE_NAME: (BuildContext context) => FiltroPage(),

      },
    );
  }
}
