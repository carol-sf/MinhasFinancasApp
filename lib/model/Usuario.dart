class Usuario {
  final String id;
  final String email;
  final String senha;
  final double creditoTotal;
  final double debitoTotal;

  Usuario({
    required this.id,
    required this.email,
    required this.senha,
    this.creditoTotal = 0,
    this.debitoTotal = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'senha': senha,
      'creditoTotal': creditoTotal,
      'debitoTotal': creditoTotal,
    };
  }

  static Usuario fromMap(Map<String, dynamic> map, String id) {
    return Usuario(
      id: id,
      email: map['email'],
      senha: map['senha'],
      creditoTotal: double.parse(map['creditoTotal'].toString()),
      debitoTotal: double.parse(map['debitoTotal'].toString()),
    );
  }

  @override
  String toString() {
    return 'Usuario{id: $id, email: $email, senha: $senha, creditoTotal: $creditoTotal, debitoTotal: $debitoTotal}';
  }
}
