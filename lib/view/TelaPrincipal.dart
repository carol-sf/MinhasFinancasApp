import 'package:flutter/material.dart';
import 'package:minhas_financas_app/model/Usuario.dart';
import 'package:minhas_financas_app/view/FiltroTransacoes.dart';
import 'package:minhas_financas_app/view/RegistroTransacoes.dart';
import 'package:minhas_financas_app/view/ResumoTransacoes.dart';

class TelaPrincipal extends StatelessWidget {
  const TelaPrincipal({super.key, required this.usuario});

  final Usuario usuario;

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
            ResumoTransacoesScreen(usuario: usuario),
            RegistroTransacaoScreen(
                usuario: usuario),
            FiltroTransacoesScreen(usuario: usuario),
          ],
        ),
      ),
    );
  }
}
