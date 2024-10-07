import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minhas_financas_app/model/Transacao.dart';
import 'package:minhas_financas_app/model/Usuario.dart';
import 'package:minhas_financas_app/service/TransacaoService.dart';
import 'package:minhas_financas_app/service/UsuarioService.dart';

class ResumoTransacoesScreen extends StatefulWidget {
  final String usuarioId;

  const ResumoTransacoesScreen({super.key, required this.usuarioId});

  @override
  State<ResumoTransacoesScreen> createState() => _ResumoTransacoesScreenState();
}

class _ResumoTransacoesScreenState extends State<ResumoTransacoesScreen> {
  final DateTime hoje = DateTime.now();
  Usuario? usuario;
  List<Transacao> transacoesHoje = [];
  double saldoTotal = 0;

  @override
  void initState() {
    super.initState();
    _carregarTransacoes();
    _carregarUsuario();
  }

  _carregarTransacoes() {
    TransacaoService().listarPorUsuarioEData(widget.usuarioId, hoje).then((relatorio) {
      setState(() {
        transacoesHoje = relatorio.transacoes;
      });
    });
  }

  _carregarUsuario() {
    UsuarioService().buscarPorId(widget.usuarioId).then((result) {
      setState(() {
        usuario = result;
        saldoTotal = (usuario?.creditoTotal ?? 0) - (usuario?.debitoTotal ?? 0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.calendar_today),
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
                        transacao.compartilhada
                            ? Icons.person_add_sharp
                            : transacao.tipo == 'Crédito'
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: transacao.tipo == 'Crédito' ? Colors.green : Colors.red,
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
              'Total Crédito: R\$ ${usuario?.creditoTotal.toStringAsFixed(2) ?? 0}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Text(
              'Total Débito: R\$ ${usuario?.debitoTotal.toStringAsFixed(2) ?? 0}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            Text(
              'Saldo Total: R\$ ${saldoTotal.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
