import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minhas_financas_app/model/Transacao.dart';

class ResumoTransacoesScreen extends StatelessWidget {
  final List<Transacao> transacoes;

  const ResumoTransacoesScreen({super.key, required this.transacoes});

  @override
  Widget build(BuildContext context) {
    final hoje = DateTime.now();
    final transacoesHoje = transacoes.where((t) => t.data.year == hoje.year && t.data.month == hoje.month && t.data.day == hoje.day).toList();
    final totalCredito = transacoes.where((t) => t.tipo == 'Crédito').fold(0.0, (sum, t) => sum + t.valor);
    final totalDebito = transacoes.where((t) => t.tipo == 'Débito').fold(0.0, (sum, t) => sum + t.valor);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Resumo das Transações',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 88, 13, 219),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon:const Icon(Icons.calendar_today),
                label: Text(
                  'Transações do dia ${DateFormat('dd/MM/yyyy').format(hoje)}',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 88, 13, 219),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: transacoesHoje.length,
                itemBuilder: (context, index) {
                  final transacao = transacoesHoje[index];
                  return Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Icon(
                        transacao.tipo == 'Crédito'
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: transacao.tipo == 'Crédito'
                            ? Colors.green
                            : Colors.red,
                      ),
                      title: Text(
                        '${transacao.motivo} - R\$ ${transacao.valor.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        '${transacao.tipo} - ${DateFormat('dd/MM/yyyy').format(transacao.data)}',
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Total Crédito: R\$ ${totalCredito.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Text(
              'Total Débito: R\$ ${totalDebito.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
