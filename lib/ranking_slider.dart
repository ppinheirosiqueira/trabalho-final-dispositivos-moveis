import 'package:flutter/material.dart';
import 'pessoa.dart';

class RankingSlider extends StatelessWidget {
  final List<Pessoa> pessoasComPontuacoes;
  final String campeonatoIndex;
  final int rodadaInicial;
  final int rodadaFinal;

  const RankingSlider({super.key, required this.pessoasComPontuacoes, required this.campeonatoIndex, required this.rodadaInicial, required this.rodadaFinal});

  @override
  Widget build(BuildContext context) {
    List<int> filtrarPontuacoes(List<int> pontuacoes) {
      return pontuacoes.sublist(rodadaInicial, rodadaFinal + 1);
    }

    pessoasComPontuacoes.sort((a, b) {
      int somaA = filtrarPontuacoes(a.pontuacoes[campeonatoIndex]!).reduce((value, element) => value + element);
      int somaB = filtrarPontuacoes(b.pontuacoes[campeonatoIndex]!).reduce((value, element) => value + element);
      return somaB.compareTo(somaA);
    });

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: pessoasComPontuacoes.length,
      itemBuilder: (context, index) {
        final pessoa = pessoasComPontuacoes[index];
        final List<int> pontuacoesFiltradas = filtrarPontuacoes(pessoa.pontuacoes[campeonatoIndex]!);
        final int pontuacaoTotal = pontuacoesFiltradas.reduce((value, element) => value + element);

        Widget leadingIcon;
        if (index == 0) {
          leadingIcon = const Icon(Icons.emoji_events, color: Colors.yellow, size: 40); // Troféu
        } else if (index == 1) {
          leadingIcon = const Icon(Icons.emoji_events, color: Colors.grey, size: 40);  // Prata
        } else if (index == 2) {
          leadingIcon = const Icon(Icons.emoji_events, color: Colors.brown, size: 40); // Bronze
        } else {
          leadingIcon = Text('${index + 1}', style: const TextStyle(color: Colors.black, fontSize: 20), textAlign: TextAlign.center); // Apenas a posição
        }

        return ListTile(
            leading: leadingIcon,
            title: Text(pessoa.nome, style: const TextStyle(color: Colors.black)),
            subtitle: Text('Pontuaçao: $pontuacaoTotal', style: const TextStyle(color: Colors.black)),
          );      
      },
    );
  }
}
