import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pessoa.dart';
import 'ranking_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Pessoa> listaPessoas = [];
  bool carregando = false;
  List<int> auxIndices = [];

  int getMaiorChave(List<Pessoa> pessoas) {
    int maiorChave = 0;

    for (var pessoa in pessoas) {
      for (var chave in pessoa.pontuacoes.keys) {
        int chaveInt = int.parse(chave);
        if (chaveInt > maiorChave) {
          maiorChave = chaveInt;
        }
      }
    }

    return maiorChave;
  }

  List<int> getVetorAteMaiorChave(List<Pessoa> pessoas) {
    int maiorChave = getMaiorChave(pessoas);

    return List<int>.generate(maiorChave, (index) => index + 1);
  }

  Future<bool> puxarLista() async {
    Uri uri = Uri.parse("https://api.json-generator.com/templates/kSYpAlNslcBd/data?access_token=k745iymizyh0zmdrnaetr13qz1nd6czdqfbot7xf");

    try {
      final response = await http.get(uri);

      if (response.statusCode == 404) {
        return false;
      } else if (response.statusCode == 500) {
        return false;
      } else if (response.statusCode == 200) {
        setState(() {
          List<dynamic> jsonData = json.decode(response.body);
          listaPessoas = jsonData.map((item) => Pessoa.fromJson(item)).toList();
        });
        auxIndices = getVetorAteMaiorChave(listaPessoas);
        return true;
      }
    } catch (error) {
      return false;
    }

    return false;
  }

  @override
  void initState() {
    super.initState();
    puxarLista().then((sucesso) {
      setState(() {
        carregando = sucesso;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Padding(
          padding: const EdgeInsets.only(top:30),
          child: Center(
            child: carregando
                ? CarouselSlider(options: CarouselOptions(autoPlay: false, height:double.infinity, viewportFraction: 1.0),items: auxIndices.map((indice) => Center(
                  child: RankingWidget(pessoas: listaPessoas, campeonatoIndex: indice),)).toList())
                : const Center(child: Icon(Icons.error,),)
          ),)
      ),
    );
  }
}