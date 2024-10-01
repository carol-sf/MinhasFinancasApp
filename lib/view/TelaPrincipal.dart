import 'package:flutter/material.dart';
import 'package:minhas_financas_app/model/Transacao.dart';
import 'package:minhas_financas_app/view/FiltroTransacoes.dart';
import 'package:minhas_financas_app/view/RegistroTransacoes.dart';
import 'package:minhas_financas_app/view/ResumoTransacoes.dart';

class TelaPrincipal extends StatefulWidget {
  final List<Transacao> transacoes;

  const TelaPrincipal({Key? key, required this.transacoes}) : super(key: key);

  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  void _adicionarTransacao(Transacao transacao) {
    setState(() {
      widget.transacoes.add(transacao);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Minhas Finanças"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.monetization_on), text: 'Resumo'),
              Tab(icon: Icon(Icons.add), text: 'Registrar'),
              Tab(icon: Icon(Icons.filter_list), text: 'Filtrar'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ResumoTransacoesScreen(transacoes: widget.transacoes),  
            RegistroTransacaoScreen(onNovaTransacao: _adicionarTransacao),  
            FiltroTransacoesScreen(transacoes: widget.transacoes),  
          ],
        ),
      ),
    );
  }
}
