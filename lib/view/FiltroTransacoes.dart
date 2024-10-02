import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minhas_financas_app/model/RelatorioTransacoes.dart';
import 'package:minhas_financas_app/model/Usuario.dart';
import 'package:minhas_financas_app/service/TransacaoService.dart';
import 'package:minhas_financas_app/utils/StringExtension.dart';

class FiltroTransacoesScreen extends StatefulWidget {
  final Usuario usuario;

  FiltroTransacoesScreen({required this.usuario});

  @override
  _FiltroTransacoesScreenState createState() => _FiltroTransacoesScreenState();
}

class _FiltroTransacoesScreenState extends State<FiltroTransacoesScreen> {
  final TransacaoService transacaoService = TransacaoService();
  DateTime _dataSelecionada = DateTime.now();
  RelatorioTransacoes _relatorio = RelatorioTransacoes(
    transacoes: [],
    creditoTotal: 0,
    debitoTotal: 0,
  );

  @override
  void initState() {
    super.initState();
    _filtrarTransacoes();
  }

  void _filtrarTransacoes() {
    transacaoService
        .listarPorUsuarioEData(widget.usuario.id, _dataSelecionada)
        .then((relatorio) {
      setState(() {
        _relatorio = relatorio;
      });
    });
  }

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? data = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF6200EE)),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (data != null && data != _dataSelecionada) {
      setState(() {
        _dataSelecionada = data;
        _filtrarTransacoes();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Filtro de Transações',
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
                onPressed: () => _selecionarData(context),
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  'Selecionar Data: ${DateFormat('dd/MM/yyyy').format(_dataSelecionada)}',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 88, 13, 219),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Transações no dia ${DateFormat('dd/MM/yyyy').format(_dataSelecionada)}',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 88, 13, 219),
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: _relatorio.transacoes.length,
                itemBuilder: (context, index) {
                  final transacao = _relatorio.transacoes[index];
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
              'Total Crédito: ${_relatorio.creditoTotal.toString().toFormattedBrlCurrency()}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Text(
              'Total Débito: ${_relatorio.debitoTotal.toString().toFormattedBrlCurrency()}',
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
