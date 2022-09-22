import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projetopontoturistico/model/ponto.dart';

class CadastroFormDialog extends StatefulWidget{
  final Ponto? pontoAtual;

  CadastroFormDialog( {Key? key, this.pontoAtual}) : super(key: key);

  CadastroFormDialogState createState() => CadastroFormDialogState();
}

class CadastroFormDialogState extends State<CadastroFormDialog>{

  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _diferencialController = TextEditingController();


  void initState(){
    super.initState();
    if (widget.pontoAtual != null){
      _descricaoController.text = widget.pontoAtual!.descricao;
      _nomeController.text= widget.pontoAtual!.nome;
      _diferencialController.text=widget.pontoAtual!.diferencial;

    }
  }

  Widget build(BuildContext context){
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nomeController,
            decoration: InputDecoration(labelText: 'Nome',),
            validator: (String? valor){
              if (valor == null || valor.isEmpty){
                return 'Informe O Nome';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _descricaoController,
            decoration: InputDecoration(labelText: 'Descrição',),
            validator: (String? valor){
              if (valor == null || valor.isEmpty){
                return 'Informe a descrição';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _diferencialController,
            decoration: InputDecoration(labelText: 'Diferenciais',),
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
    id: widget.pontoAtual?.id ?? 0,
    descricao: _descricaoController.text,
    data: DateTime.now(),
    nome: _nomeController.text,
    diferencial: _diferencialController.text
  );

}