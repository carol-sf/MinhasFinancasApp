import 'package:cloud_firestore/cloud_firestore.dart';

class Transacao {
  final String id;
  final double valor;
  final String tipo;
  final DateTime data;
  final String motivo;
  final String usuarioId;

  Transacao({
    required this.id,
    required this.valor,
    required this.tipo,
    required this.data,
    required this.motivo,
    required this.usuarioId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'valor': valor,
      'tipo': tipo,
      'data': data,
      'motivo': motivo,
      'usuarioId': usuarioId,
    };
  }

  static Transacao fromDoc(QueryDocumentSnapshot<Object?> map) {
    return Transacao(
      id: map['id'],
      valor: map['valor'],
      tipo: map['tipo'],
      data: map['data'].toDate(),
      motivo: map['motivo'],
      usuarioId: map['usuarioId'],
    );
  }

  @override
  String toString() {
    return 'Transacao(id: $id, valor: $valor, tipo: $tipo, data: $data, motivo: $motivo)';
  }
}
