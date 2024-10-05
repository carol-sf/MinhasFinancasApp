import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minhas_financas_app/model/Usuario.dart';
import 'package:minhas_financas_app/service/AuthenticationHelper.dart';
import 'package:minhas_financas_app/service/UsuarioService.dart';
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
  File? _imagemSelecionada;

  Future<void> _escolherImagem() async {
    final ImagePicker picker = ImagePicker();
    XFile? imagem = await picker.pickImage(source: ImageSource.gallery);

    if (imagem != null) {
      setState(() {
        _imagemSelecionada = File(imagem.path);
      });
    }
  }

  Future<UploadTask?> _upload(String usuarioId) async {
    if(_imagemSelecionada != null) {
      File file = File(_imagemSelecionada!.path);
      try {
        String ref = 'images/img-${DateTime.now().toString()}.jpeg';
        final storageRef = FirebaseStorage.instance.ref();
        return storageRef.child(ref).putFile(
          file,
          SettableMetadata(
            cacheControl: "public, max-age=300",
            contentType: "image/jpeg",
            customMetadata: {
              "usuarioId": usuarioId,
            },
          ),
        );
      } on FirebaseException catch (e) {
        throw Exception('Erro no upload: ${e.code}');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Selecione uma imagem',
          style: TextStyle(fontSize: 16),
        ),
      ));
      return null;
    }
  }

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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _imagemSelecionada != null
                      ? Image.file(_imagemSelecionada!, width: 300, height: 300)
                      : const Text('Nenhuma imagem selecionada.'),
                  ElevatedButton(
                    onPressed: _escolherImagem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 23, 89, 233),
                      foregroundColor: Colors.white,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.upload),
                        Text(
                          "Adicionar imagem",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
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
                            UsuarioService().registrar(Usuario(id: '', email: _emailController.text)).then((usuario) {
                              print('usuario:');
                              print(usuario);
                              if(usuario is Usuario) {
                                _upload(usuario.id);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TelaPrincipal(usuario: usuario,)));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text(
                                    'Usuario não encontrado',
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
                              builder: (context) => const LoginScreen()));
                    },
                    child: const Text('Já tenho uma conta.'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
