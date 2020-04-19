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
//   return {
//   "by": "default",
//   "valid_key": true,
//   "results": {
//     "currencies": {
//       "source": "BRL",
//       "USD": {
//         "name": "Dollar",
//         "buy": 4.4619,
//         "sell": 4.4497,
//         "variation": 0.401
//       },
//       "EUR": {
//         "name": "Euro",
//         "buy": 4.8898,
//         "sell": 4.8442,
//         "variation": 0.931
//       },
//       "GBP": {
//         "name": "Pound Sterling",
//         "buy": 5.7553,
//         "sell": null,
//         "variation": 0.171
//       },
//       "ARS": {
//         "name": "Argentine Peso",
//         "buy": 0.0721,
//         "sell": null,
//         "variation": 0.278
//       },
//       "BTC": {
//         "name": "Bitcoin",
//         "buy": 41619.988,
//         "sell": 41619.988,
//         "variation": 0.058
//       }
//     },
//     "stocks": {
//       "IBOVESPA": {
//         "name": "BM&F BOVESPA",
//         "location": "Sao Paulo, Brazil",
//         "points": 105718.289,
//         "variation": -7.0
//       },
//       "NASDAQ": {
//         "name": "NASDAQ Stock Market",
//         "location": "New York City, United States",
//         "points": 8980.77,
//         "variation": 0.17
//       },
//       "CAC": {
//         "name": "CAC 40",
//         "location": "Paris, French",
//         "variation": -2.53
//       },
//       "NIKKEI": {
//         "name": "Nikkei 225",
//         "location": "Tokyo, Japan",
//         "variation": -2.13
//       }
//     },
//     "available_sources": [
//       "BRL"
//     ],
//     "bitcoin": {
//       "blockchain_info": {
//         "name": "Blockchain.info",
//         "format": [
//           "USD",
//           "en_US"
//         ],
//         "last": 8799.87,
//         "buy": 8799.87,
//         "sell": 8799.87,
//         "variation": 0.058
//       },
//       "coinbase": {
//         "name": "Coinbase",
//         "format": [
//           "USD",
//           "en_US"
//         ],
//         "last": 8787.015,
//         "variation": -0.097
//       },
//       "bitstamp": {
//         "name": "BitStamp",
//         "format": [
//           "USD",
//           "en_US"
//         ],
//         "last": 8795.0,
//         "buy": 8795.0,
//         "sell": 8789.12,
//         "variation": -0.021
//       },
//       "foxbit": {
//         "name": "FoxBit",
//         "format": [
//           "BRL",
//           "pt_BR"
//         ],
//         "last": 39911.01,
//         "variation": -0.174
//       },
//       "mercadobitcoin": {
//         "name": "Mercado Bitcoin",
//         "format": [
//           "BRL",
//           "pt_BR"
//         ],
//         "last": 40029.90001,
//         "buy": 40029.90001,
//         "sell": 40073.81554,
//         "variation": 1.342
//       },
//       "omnitrade": {
//         "name": "OmniTrade",
//         "format": [
//           "BRL",
//           "pt_BR"
//         ],
//         "last": 39866.57,
//         "buy": 39740.0,
//         "sell": 40200.0,
//         "variation": 0.877
//       },
//       "xdex": {
//         "name": "XDEX",
//         "format": [
//           "BRL",
//           "pt_BR"
//         ],
//         "last": 40406.24,
//         "variation": 1.016
//       }
//     },
//     "taxes": [
//       {
//         "date": "2020-02-20",
//         "cdi": 4.15,
//         "selic": 4.15,
//         "daily_factor": 1.00016137
//       }
//     ]
//   },
//   "execution_time": 0.0,
//   "from_cache": true
// };
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
