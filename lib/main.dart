import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "http://data.fixer.io/api/latest?access_key=6f325895723dc4dd649ab68be991a508";

void main() async {

  //print(await getData());


  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.green
    ),
  ));
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
  final bitcoinController = TextEditingController();

  double dolar;
  double euro;
  double bitcoin;

  void _realChanged(String text) {
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
    bitcoinController.text = (real/bitcoin).toStringAsFixed(2);
  }
  void _dolarChanged(String text) {
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    bitcoinController.text = (bitcoin * this.bitcoin / euro).toStringAsFixed(2);
  }
  void _euroChanged(String text) {
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    bitcoinController.text = (bitcoin * this.bitcoin / dolar).toStringAsFixed(2);
  }

  void _bitcoinChanged(String text) {
    double bitcoin = double.parse(text);
    realController.text = (bitcoin * this.bitcoin).toStringAsFixed(2);
    dolarController.text = (bitcoin * this.bitcoin).toStringAsFixed(2);
    euroController.text = (euro * this.euro / bitcoin).toStringAsFixed(2);
  }


  void _moneyChanged() {

    //Colocar campo dinamico para selecionar outras moedas
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando Dados...",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25.0,
                    ),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if(snapshot.hasError){
                return Center(
                  child: Text("Erro ao Carregar dados... :(",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
//                print(snapshot.data["rates"]["USD"]);
                dolar = snapshot.data["rates"]["BRL"] / snapshot.data["rates"]["USD"] ?? 0.0;
                bitcoin = snapshot.data["rates"]["BRL"] / snapshot.data["rates"]["BTC"] ?? 0.0;
                euro = snapshot.data["rates"]["BRL"] ?? 0.0;

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 150.0, color: Colors.green,),
                      buildTextFild("Reais", "R\$", realController, _realChanged),
                      Divider(),
                      buildTextFild("Dolares", "US\$", dolarController, _dolarChanged),
                      Divider(),
                      buildTextFild("Euros", "€", euroController, _euroChanged),
                      Divider(),
                      buildTextFild("BitCoins", "B\$", bitcoinController, _bitcoinChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget buildTextFild(String label, String prefixo, TextEditingController control, Function funcao) {
  return TextField(
    controller: control,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber, fontSize: 15.0),
        border: OutlineInputBorder(),
        prefixText: prefixo
    ),
    style:  TextStyle(
        color: Colors.amber,
        fontSize: 25.0
    ),
    onChanged: funcao,
    keyboardType: TextInputType.number
  );
}

