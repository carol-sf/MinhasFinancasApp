class Usuario {
  final String id;
  final String usuario;
  final String senha;
  final double creditoTotal;
  final double debitoTotal;

  Usuario({
    required this.id,
    required this.usuario,
    required this.senha,
    this.creditoTotal = 0,
    this.debitoTotal = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'usuario': usuario,
      'senha': senha,
      'creditoTotal': creditoTotal,
      'debitoTotal': creditoTotal,
    };
  }

  static Usuario fromMap(Map<String, dynamic> map, String id) {
    return Usuario(
      id: id,
      usuario: map['usuario'],
      senha: map['senha'],
      creditoTotal: (map['creditoTotal'] as int).toDouble(),
      debitoTotal: (map['debitoTotal'] as int).toDouble(),
    );
  }

  @override
  String toString() {
    return 'Usuario{id: $id, usuario: $usuario, senha: $senha, creditoTotal: $creditoTotal, debitoTotal: $debitoTotal}';
  }
}
