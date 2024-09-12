import 'package:flutter/material.dart';
import 'campeonato.dart';
import 'pessoa.dart';
import 'package:statistics/statistics.dart';

class RankingWidget extends StatelessWidget {
  final List<Pessoa> pessoas;
  final int campeonatoIndex;

  const RankingWidget({super.key, required this.pessoas, required this.campeonatoIndex});

  @override
  Widget build(BuildContext context) {
    String campeonatoAtual = campeonatoIndex.toString();

    List<Pessoa> pessoasComPontuacoes = pessoas
        .where((pessoa) => pessoa.pontuacoes[campeonatoAtual] != null)
        .toList();

    pessoasComPontuacoes.sort((a, b) {
      int somaA = a.pontuacoes[campeonatoAtual]!.reduce((value, element) => value + element);
      int somaB = b.pontuacoes[campeonatoAtual]!.reduce((value, element) => value + element);
      return somaB.compareTo(somaA);
    });

    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CampeonatoPage(
                  pessoas: pessoas,
                  campeonatoIndex: campeonatoIndex,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Ranking do Campeonato: $campeonatoAtual',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: pessoasComPontuacoes.length,
            itemBuilder: (context, index) {
              final pessoa = pessoasComPontuacoes[index];
              final int pontuacaoTotal = pessoa.pontuacoes[campeonatoAtual]!.reduce((value, element) => value + element);

              Widget leadingIcon;
              if (index == 0) {
                leadingIcon = const Icon(Icons.emoji_events, color: Colors.yellow, size: 40);
              } else if (index == 1) {
                leadingIcon = const Icon(Icons.emoji_events, color: Colors.grey, size: 40);
              } else if (index == 2) {
                leadingIcon = const Icon(Icons.emoji_events, color: Colors.brown, size: 40);
              } else {
                leadingIcon = Text('${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center,);
              }

              return ExpansionTile(
              title: ListTile(
                leading: leadingIcon,
                title: Text(pessoa.nome, style: const TextStyle(color: Colors.white)),
                subtitle: Text('Pontuação: $pontuacaoTotal', style: const TextStyle(color: Colors.white)),
              ),
              children: [
                Text('Média: ${pessoa.pontuacoes[campeonatoAtual]?.mean.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
                Text('Desvio Padrão: ${pessoa.pontuacoes[campeonatoAtual]?.standardDeviation.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
              ] 
            );},
          ),
        ),
      ],
    );
  }
}
