import 'package:flutter/material.dart';
import 'pessoa.dart';
import 'ranking_slider.dart';
import 'grafico.dart';

class CampeonatoPage extends StatefulWidget {
  final List<Pessoa> pessoas;
  final int campeonatoIndex;

  const CampeonatoPage({super.key, required this.pessoas, required this.campeonatoIndex});

  @override
  State<CampeonatoPage> createState() => _CampeonatoPageState();
}

class _CampeonatoPageState extends State<CampeonatoPage> {
  RangeValues rodadasRanking = const RangeValues(0, 5);
  RangeValues rodadasGrafico = const RangeValues(0, 5);
  List<Pessoa> pessoas = [];
  List<Pessoa> pessoasComPontuacoes = [];
  List<String> pessoasSelecionadas = [];
  String campeonatoAtual = "";
  int totalRodadas = -1;

  @override
  void initState() {
    super.initState();
    campeonatoAtual = widget.campeonatoIndex.toString();
    pessoas = widget.pessoas;
    pessoasComPontuacoes = pessoas.where((pessoa) => pessoa.pontuacoes[campeonatoAtual] != null).toList();
    totalRodadas = pessoasComPontuacoes.first.pontuacoes[campeonatoAtual]?.length ?? 0;
    rodadasRanking = RangeValues(0, totalRodadas.toDouble()-1);
    rodadasGrafico = RangeValues(0, totalRodadas.toDouble()-1);
  }

  @override
  Widget build(BuildContext context) {
    pessoasComPontuacoes.sort((a, b) {
      int somaA = a.pontuacoes[campeonatoAtual]!.reduce((value, element) => value + element);
      int somaB = b.pontuacoes[campeonatoAtual]!.reduce((value, element) => value + element);
      return somaB.compareTo(somaA);
    });
  
    return Scaffold(
      appBar: AppBar(
        title: Text('Campeonato $campeonatoAtual'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rodadas do Ranking'),
            RangeSlider(
              values: rodadasRanking,
              min: 0,
              max: totalRodadas.toDouble() - 1,
              divisions: totalRodadas,
              labels: RangeLabels(
                (rodadasRanking.start.round() + 1).toString(),
                (rodadasRanking.end.round() + 1).toString(),
              ),
              onChanged: (RangeValues valores) {
                setState(() {
                  rodadasRanking = valores;
                });
              },
            ),

            RankingSlider(campeonatoIndex: campeonatoAtual, pessoasComPontuacoes: pessoasComPontuacoes, rodadaFinal: rodadasRanking.end.round(), rodadaInicial: rodadasRanking.start.round(),),

            const SizedBox(height: 20),

            const Text('Selecione as pessoas para o gráfico:'),
            Wrap(
              runSpacing: 10.0,
              children: pessoasComPontuacoes.map((pessoa) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return CheckboxListTile(
                      title: Text(pessoa.nome),
                      value: pessoasSelecionadas.contains(pessoa.nome),
                      onChanged: (bool? selecionado) {
                        setState(() {
                          if (selecionado == true) {
                            pessoasSelecionadas.add(pessoa.nome);
                          } else {
                            pessoasSelecionadas.remove(pessoa.nome);
                          }
                        });
                      },
                    );
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            const Text('Rodadas do Gráfico'),
            RangeSlider(
              values: rodadasGrafico,
              min: 0,
              max: totalRodadas.toDouble() - 1,
              divisions: totalRodadas,
              labels: RangeLabels(
                (rodadasGrafico.start.round() + 1).toString(),
                (rodadasGrafico.end.round() + 1).toString(),
              ),
              onChanged: (RangeValues valores) {
                setState(() {
                  rodadasGrafico = valores;
                });
              },
            ),
            
            const SizedBox(height: 20),

            Grafico(pessoasSelecionadas: pegarPessoasSelecionadas(pessoas, pessoasSelecionadas), campeonatoIndex: campeonatoAtual, rodadasGrafico: gerarRodadas(rodadasGrafico))
          ],
        ),
      ),
    );
  }

  List<Pessoa> pegarPessoasSelecionadas(List<Pessoa> pessoas, List<String> nomes){

    List<Pessoa> aux = [];

    for (var nomePessoa in nomes) {
      int indexPessoa = pessoas.indexWhere((pessoa) => pessoa.nome == nomePessoa);
      if (indexPessoa != -1) {
        aux.add(pessoas[indexPessoa]);
      }
    }
    return aux;
  }

  List<int> gerarRodadas(rangeValues){
    List<int> rangeList = List.generate(
    rangeValues.end.round() - rangeValues.start.round() + 1,
    (index) => rangeValues.start.round() + index,);
    return rangeList;
  }
}