import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minhas_financas_app/model/RelatorioTransacoes.dart';
import 'package:minhas_financas_app/model/Transacao.dart';

class TransacaoService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  registrar(Transacao transacao) {
    try {
      db.collection('transacoes').add(transacao.toMap());
    } catch(e) {
      print('Erro ao registrar transação: $e');
    }
  }

  Future<RelatorioTransacoes> listarPorUsuarioEData(String usuarioId, DateTime data) async {
    QuerySnapshot querySnapshot;
    List<Transacao> transacoes = [];

    querySnapshot = await db
        .collection('transacoes')
        .where('usuarioId', isEqualTo: usuarioId)
        .where('data', isEqualTo: Timestamp.fromDate(data))
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var docRef in querySnapshot.docs.toList()) {
        transacoes.add(Transacao.fromMap(docRef.data() as Map<String, dynamic>));
      }
    }
  
    final creditoTotal = transacoes
        .where((transacao) => transacao.tipo == 'Crédito')
        .fold(0.0, (sum, transacao) => sum + transacao.valor);
    final debitoTotal = transacoes
        .where((transacao) => transacao.tipo == 'Débito')
        .fold(0.0, (sum, transacao) => sum + transacao.valor);

    return RelatorioTransacoes(
      transacoes: transacoes,
      creditoTotal: creditoTotal,
      debitoTotal: debitoTotal,
    );
  }
}
