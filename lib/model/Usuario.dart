class Usuario {
  final String id;
  final String email;
  final double creditoTotal;
  final double debitoTotal;


  Usuario({
    required this.id,
    required this.email,
    this.creditoTotal = 0,
    this.debitoTotal = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'creditoTotal': creditoTotal,
      'debitoTotal': creditoTotal,
    };
  }

  static Usuario fromMap(Map<String, dynamic> map, String id) {
    return Usuario(
      id: id,
      email: map['email'],
      creditoTotal: double.parse(map['creditoTotal'].toString()),
      debitoTotal: double.parse(map['debitoTotal'].toString()),
    );
  }

  @override
  String toString() {
    return 'Usuario{id: $id, email: $email, creditoTotal: $creditoTotal, debitoTotal: $debitoTotal}';
  }
}
