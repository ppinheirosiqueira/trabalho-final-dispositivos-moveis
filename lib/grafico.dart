import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'pessoa.dart';

class Grafico extends StatelessWidget {
  final List<Pessoa> pessoasSelecionadas;
  final String campeonatoIndex;
  final List<int> rodadasGrafico;

  const Grafico({super.key, required this.pessoasSelecionadas, required this.campeonatoIndex, required this.rodadasGrafico});

  List<LineChartBarData> gerarDadosGrafico(
    List<Pessoa> pessoasSelecionadas, List<int> rodadasGrafico, String indexCampeonato) {
  
  List<LineChartBarData> linhas = [];
  for (var pessoa in pessoasSelecionadas) {
      LineChartBarData aux = LineChartBarData(spots: [], color: pessoa.cor);
      for (var rodada in rodadasGrafico) {
        FlSpot pontoAux = FlSpot(rodada + 1,pessoa.pontuacoes[indexCampeonato]![rodada].toDouble());
        aux.spots.add(pontoAux);
      }
      linhas.add(aux);
  }
  return linhas;
  } 

  @override
  Widget build(BuildContext context) {
    return SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  minX: rodadasGrafico[0] + 1,
                  maxX: rodadasGrafico[rodadasGrafico.length - 1]  + 1,
                  minY: 0,
                  maxY: 30,
                  lineBarsData: gerarDadosGrafico(pessoasSelecionadas,rodadasGrafico,campeonatoIndex),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) => Text(value.toInt().toString()),
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (List<LineBarSpot> touchedSpots) {
                          return touchedSpots.map((spot) {
                            final barIndex = spot.barIndex;
                            final nomePessoa = pessoasSelecionadas[barIndex].nome;
                            return LineTooltipItem(
                              '$nomePessoa: ${spot.y}',
                              const TextStyle(color: Colors.white),
                            );
                          }).toList();
                        },
                      ),
                    ),
                ),
              ),
            );
  }
}

