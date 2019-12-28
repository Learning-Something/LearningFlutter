import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance?format=json&key=6ace206a';

void main() {
  runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(hintColor: Colors.white, primaryColor: Colors.white)));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  bool _clearAll(String text) {
    if (text.isEmpty) {
      realController.text = '';
      dolarController.text = '';
      euroController.text = '';
      return false;
    }
    return true;
  }

  void _realChanged(String text) {
    if (_clearAll(text)) {
      double real = double.parse(text);
      dolarController.text = (real/dolar).toStringAsFixed(2);
      euroController.text = (real/euro).toStringAsFixed(2);
    }
  }

  void _dolarChanged(String text) {
    if (_clearAll(text)) {
      double dolar = double.parse(text);
      realController.text = (dolar * this.dolar * 1.04 * 1.0638).toStringAsFixed(2);
      euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    }
  }

  void _euroChanged(String text) {
    if (_clearAll(text)) {
      double euro = double.parse(text);
      realController.text = (euro * this.euro * 1.04 * 1.0638).toStringAsFixed(2);
      dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        title: Text('Compra Internacional NuBank',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    'Carregando Dados...',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erro ao carregar os dados :(',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  dolar = snapshot.data['results']['currencies']['USD']['buy'];
                  euro = snapshot.data['results']['currencies']['EUR']['buy'];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          size: 150,
                          color: Colors.white,
                        ),
                        buildTextField('Dolares', 'US\$', dolarController, _dolarChanged),
                        Divider(),
                        buildTextField('Euros', '€', euroController, _euroChanged),
                        Divider(),
                        Divider(),
                        buildTextField('Reais', 'R\$', realController, _realChanged, enabled: false)
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController controller, Function onChanged, {enabled: true}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
        ),
        border: OutlineInputBorder(),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white)
        ),
        prefixText: prefix
    ),
    style: TextStyle(color: Colors.white, fontSize: 25),
    onChanged: onChanged,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}
