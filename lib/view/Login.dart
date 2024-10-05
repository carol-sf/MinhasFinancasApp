import 'package:flutter/material.dart';
import 'package:minhas_financas_app/model/DadosLogin.dart';
import 'package:minhas_financas_app/model/Usuario.dart';
import 'package:minhas_financas_app/service/AuthenticationHelper.dart';
import 'package:minhas_financas_app/service/UsuarioService.dart';
import 'package:minhas_financas_app/view/Cadastro.dart';
import 'package:minhas_financas_app/view/TelaPrincipal.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final DadosLogin _dadosLogin = DadosLogin();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.network(
              "https://img.icons8.com/material-outlined/24/000000/pie-chart.png",
              width: 40,
            ),
            const SizedBox(width: 10),
            const Text(
              'Controle Financeiro',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 23, 89, 233),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (String? inValue) {
                  if (inValue!.isEmpty) {
                    return "Por favor, insira o usuário";
                  }
                  return null;
                },
                onSaved: (String? inValue) {
                  _dadosLogin.email = inValue!;
                },
                decoration: const InputDecoration(
                  hintText: "Nome de usuário",
                  labelText: "Usuário",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                obscureText: true,
                validator: (String? inValue) {
                  if (inValue!.isEmpty) {
                    return "A senha informada não é válida";
                  }
                  return null;
                },
                onSaved: (String? inValue) {
                  _dadosLogin.senha = inValue!;
                },
                decoration: const InputDecoration(
                  hintText: "Senha",
                  labelText: "Senha",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 23, 89, 233),
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    AuthenticationHelper()
                        .signIn(
                            email: _dadosLogin.email,
                            password: _dadosLogin.senha)
                        .then((result) {
                      print(result);
                      if (result == null) {
                        UsuarioService()
                            .buscarPorEmail(_dadosLogin.email)
                            .then((usuario) {
                          if (usuario is Usuario) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TelaPrincipal(usuario: usuario),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                'Erro ao tentar logar',
                                style: TextStyle(fontSize: 16),
                              ),
                            ));
                          }
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            AuthenticationHelper().traduzirRetorno(result),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ));
                      }
                    });
                  }
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CadastroScreen()));
                },
                child: const Text('Não tenho uma conta.'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
