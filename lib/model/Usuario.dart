class Usuario {
  final String id;
  final String usuario;
  final String senha;
  final double creditoTotal;
  final double debitoTotal;
  String? colaboradorId;

  Usuario({
    required this.id,
    required this.usuario,
    required this.senha,
    this.creditoTotal = 0,
    this.debitoTotal = 0,
    this.colaboradorId,
  });

  Map<String, dynamic> toMap() {
    return {
      'usuario': usuario,
      'senha': senha,
      'creditoTotal': creditoTotal,
      'debitoTotal': creditoTotal,
      'colaboradorId': colaboradorId,
    };
  }

  static Usuario fromMap(Map<String, dynamic> map, String id) {
    return Usuario(
      id: id,
      usuario: map['usuario'],
      senha: map['senha'],
      creditoTotal: (map['creditoTotal'] ?? 0) as double,
      debitoTotal: (map['debitoTotal'] ?? 0) as double,
      colaboradorId: map['colaboradorId'],
    );
  }
}
