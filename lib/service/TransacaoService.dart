import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minhas_financas_app/model/Participacao.dart';
import 'package:minhas_financas_app/model/RelatorioTransacoes.dart';
import 'package:minhas_financas_app/model/Transacao.dart';
import 'package:minhas_financas_app/model/Usuario.dart';
import 'package:minhas_financas_app/service/UsuarioService.dart';

class TransacaoService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Participacao calcularParticipacao(double valorTotal, Usuario usuario, Usuario colaborador) {
    double somaSalarios = usuario.creditoTotal + colaborador.creditoTotal;
    double porcentagemUsuario = usuario.creditoTotal / somaSalarios;
    double parteUsuario = valorTotal * porcentagemUsuario;
    double parteColaborador = valorTotal - parteUsuario;

    return Participacao(
      idUsuario: usuario.id,
      nomeUsuario: usuario.usuario,
      parteUsuario: parteUsuario,
      idColaborador: colaborador.id,
      nomeColaborador: colaborador.usuario,
      parteColaborador: parteColaborador,
    );
  }

  registrar(Transacao transacao) async {
    try {
      UsuarioService usuarioService = UsuarioService();
      if(await usuarioService.atualizarSaldo(transacao.usuarioId, transacao.valor, transacao.tipo)) {
        await db.collection('transacoes').add(transacao.toMap());
      } else {
        print('Transação não realizada. Erro ao atualizar saldo do usuário.');
      }
    } catch (e) {
      print('Erro ao registrar transação: $e');
    }
  }

  Future<RelatorioTransacoes> listarPorUsuarioEData(
      String usuarioId, DateTime data) async {
    QuerySnapshot querySnapshot;
    List<Transacao> transacoes = [];

    querySnapshot = await db
        .collection('transacoes')
        .where('usuarioId', isEqualTo: usuarioId)
        .where('data', isEqualTo: Timestamp.fromDate(data))
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var docRef in querySnapshot.docs.toList()) {
        transacoes
            .add(Transacao.fromMap(docRef.data() as Map<String, dynamic>));
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
