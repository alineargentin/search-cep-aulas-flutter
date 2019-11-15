import 'package:flutter/material.dart';
import 'package:search_cep/services/via_cep_service.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:search_cep/theme.dart';
import 'package:flushbar/flushbar.dart';
import 'package:share/share.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _searchCepController = TextEditingController();
  bool _loading = false;
  bool _enableField = true;
  String _result;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _searchCepController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar CEP'),
        actions: <Widget>[
          IconButton(
            // DESAFIO 2: Criar um IconButton na AppBar para alternar entre os temas
            onPressed: () {
              if (DynamicTheme.of(context).data == myLightTheme) {
                DynamicTheme.of(context).setThemeData(myDarkTheme);
              } else {
                DynamicTheme.of(context).setThemeData(myLightTheme);
              }
            },
            icon: Icon(Icons.invert_colors),
          ),
          IconButton(
            // DESAFIO 6: Adicionar um IconButton na AppBar para compartilhar o CEP
            onPressed: () {
              if (_result.isEmpty) {
                Flushbar(
                  title: "Erro",
                  message: "Busque um CEP válido antes de compartilhar",
                  duration: Duration(seconds: 3),
                )..show(context);
                return;
              }
              Share.share(_result);
            },
            icon: Icon(Icons.share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSearchCepTextField(),
            _buildSearchCepButton(),
            _buildResultForm()
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCepTextField() {
    return Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                  autofocus: true,
                  maxLength: 8,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(labelText: 'Cep'),
                  controller: _searchCepController,
                  enabled: _enableField,
                  validator: (String value) {
                    // DESAFIO 4: Validar o campo de digitação de CEP
                    return value.length != 8
                        ? 'O cep deve conter 8 números'
                        : null;
                  })
            ]));
  }

  Widget _buildSearchCepButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: RaisedButton(
        onPressed: _searchCep,
        child: _loading ? _circularLoading() : Text('Consultar'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  void _searching(bool enable) {
    setState(() {
      _result = enable ? '' : _result;
      _loading = enable;
      _enableField = !enable;
    });
  }

  Widget _circularLoading() {
    return Container(
      height: 15.0,
      width: 15.0,
      child: CircularProgressIndicator(),
    );
  }

  Future _searchCep() async {
    _searching(true);
    if (_formKey.currentState.validate()) {
      final cep = _searchCepController.text;

      try {
        final resultCep = await ViaCepService.fetchCep(cep: cep);
        print(
            resultCep.localidade); // Exibindo somente a localidade no terminal

        setState(() {
          _result = resultCep.toJson();
        });
      } on Exception {
        // DESAFIO 5: Tratar todas exceções e utilize Flushbar para exibir os erros para o usuário
        Flushbar(
          title: "Erro",
          message: "Ocorreu um erro ao obter o CEP",
          duration: Duration(seconds: 3),
        )..show(context);

        // limpa o resultado em caso de erro
        setState(() {
          _result = '';
        });
      }
    }
    _searching(false);
  }

  Widget _buildResultForm() {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: Text(_result ?? ''),
    );
  }
}
