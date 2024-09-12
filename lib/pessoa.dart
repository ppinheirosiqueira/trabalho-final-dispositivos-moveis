import 'dart:ui';

class Pessoa {
  String id;
  String nome;
  String email;
  Map<String, List<int>> pontuacoes;
  Color cor;

  Pessoa({
    required this.id,
    required this.nome,
    required this.email,
    required this.pontuacoes,
    required this.cor,
  });

  factory Pessoa.fromJson(Map<String, dynamic> json) {
    return Pessoa(
      id: json['id'] ?? '',
      nome: json['name'] ?? '',
      email: json['email'] ?? '',
      cor: _parseColorFromHex(json['cor'] ?? '#FFFFFF'),
      pontuacoes: json['pontuacoes'] != null
          ? (json['pontuacoes'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                key, 
                List<int>.from(value.map((item) => item as int)),
              ),
            )
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'pontuacoes': pontuacoes,
      'cor': '#${cor.value.toRadixString(16).padLeft(8, '0')}',
    };
  }

  static Color _parseColorFromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
