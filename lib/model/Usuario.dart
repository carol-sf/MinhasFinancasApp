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
      'id' : id,
      'usuario' : usuario,
      'senha' : senha,
      'creditoTotal' : creditoTotal,
      'debitoTotal' : creditoTotal,
    };
  }
}