import 'package:flutter/material.dart';
import 'package:minhas_financas_app/model/Usuario.dart';
import 'package:minhas_financas_app/service/AuthenticationHelper.dart';
import 'package:minhas_financas_app/view/FiltroTransacoes.dart';
import 'package:minhas_financas_app/view/Login.dart';
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
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.monetization_on), text: 'Resumo'),
              Tab(icon: Icon(Icons.add), text: 'Registrar'),
              Tab(icon: Icon(Icons.filter_list), text: 'Filtrar'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                AuthenticationHelper()
                    .signOut()
                    .then((_) => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (contex) => const LoginScreen()),
                ));
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            ResumoTransacoesScreen(usuario: usuario),
            RegistroTransacaoScreen(usuario: usuario),
            FiltroTransacoesScreen(usuario: usuario),
          ],
        ),
      ),
    );
  }
}
