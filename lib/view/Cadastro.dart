import 'package:flutter/material.dart';
import 'package:minhas_financas_app/service/AuthenticationHelper.dart';
import 'package:minhas_financas_app/view/Login.dart';
import 'package:minhas_financas_app/view/TelaPrincipal.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um email.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Senha",
                    labelText: "Senha",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma senha.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 23, 89, 233),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    "Cadastre-se",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      AuthenticationHelper()
                          .signUp(email: _emailController.text, password: _senhaController.text)
                          .then((result) {
                        if (result == null) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TelaPrincipal()));
                        } else {
                          print('Deu erro');
                          print(result);
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
                            builder: (context) => const LoginScreen()));
                  },
                  child: const Text('Já tenho uma conta.'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
