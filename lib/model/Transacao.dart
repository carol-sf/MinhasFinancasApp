class Transacao {
  String? id;
  final double valor;
  final String tipo;
  final DateTime data;
  final String motivo;
  final String usuarioId;
  final bool compartilhada;

  Transacao({
    this.id,
    required this.valor,
    required this.tipo,
    required this.data,
    required this.motivo,
    required this.usuarioId,
    required this.compartilhada,
  });

  Map<String, dynamic> toMap() {
    return {
      'valor': valor,
      'tipo': tipo,
      'data': data,
      'motivo': motivo,
      'usuarioId': usuarioId,
    };
  }

  static Transacao fromMap(Map<String, dynamic> map) {
    return Transacao(
      id: map['id'],
      valor: map['valor'],
      tipo: map['tipo'],
      data: map['data'].toDate(),
      motivo: map['motivo'],
      usuarioId: map['usuarioId'],
      compartilhada: map['compartilhada'] ?? false,
    );
  }

  @override
  String toString() {
    return 'Transacao(id: $id, valor: $valor, tipo: $tipo, data: $data, motivo: $motivo)';
  }
}
