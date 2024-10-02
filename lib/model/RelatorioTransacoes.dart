
import 'package:minhas_financas_app/model/Transacao.dart';

class RelatorioTransacoes {
  final List<Transacao> transacoes;
  final double creditoTotal;
  final double debitoTotal;

  RelatorioTransacoes({
    required this.transacoes,
    required this.creditoTotal,
    required this.debitoTotal,
  });

  @override
  String toString() {
    return 'RelatorioTransacoes{transacoes: $transacoes, creditoTotal: $creditoTotal, debitoTotal: $debitoTotal}';
  }
}