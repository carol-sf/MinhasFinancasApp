import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minhas_financas_app/model/Transacao.dart';

class FiltroTransacoesScreen extends StatefulWidget {
  final List<Transacao> transacoes;

  FiltroTransacoesScreen({required this.transacoes});

  @override
  _FiltroTransacoesScreenState createState() => _FiltroTransacoesScreenState();
}

class _FiltroTransacoesScreenState extends State<FiltroTransacoesScreen> {
  DateTime _dataSelecionada = DateTime.now();
  List<Transacao> _transacoesFiltradas = [];

  @override
  void initState() {
    super.initState();
    _filtrarTransacoes();
    atualizarLista();
  }

  Future atualizarLista() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot;

    querySnapshot = await db.collection('contas').get();

    if(querySnapshot.docs.isNotEmpty) {
      for(var doc in querySnapshot.docs.toList()) {
        print(doc['usuario']);
        setState(() { });
      }
    }

  }

  void _filtrarTransacoes() {
    setState(() {
      _transacoesFiltradas = widget.transacoes
          .where((transacao) =>
              transacao.data.year == _dataSelecionada.year &&
              transacao.data.month == _dataSelecionada.month &&
              transacao.data.day == _dataSelecionada.day)
          .toList();
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
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
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
    final totalCredito = _transacoesFiltradas
        .where((transacao) => transacao.tipo == 'Crédito')
        .fold(0.0, (sum, transacao) => sum + transacao.valor);
    final totalDebito = _transacoesFiltradas
        .where((transacao) => transacao.tipo == 'Débito')
        .fold(0.0, (sum, transacao) => sum + transacao.valor);

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
              style: const  TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 88, 13, 219),
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: _transacoesFiltradas.length,
                itemBuilder: (context, index) {
                  final transacao = _transacoesFiltradas[index];
                  return Card(
                    elevation: 4.0,
                    margin: const  EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Icon(
                        transacao.tipo == 'Crédito'
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: transacao.tipo == 'Crédito'
                            ? Colors.green
                            : Colors.red,
                      ),
                      title:  Text(
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
