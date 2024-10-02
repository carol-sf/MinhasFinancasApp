import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minhas_financas_app/model/Transacao.dart';
import 'package:minhas_financas_app/model/Usuario.dart';
import 'package:minhas_financas_app/service/UsuarioService.dart';

class RegistroTransacaoScreen extends StatefulWidget {
  final Function(Transacao) onNovaTransacao;

  const RegistroTransacaoScreen({super.key, required this.onNovaTransacao});

  @override
  _RegistroTransacaoScreenState createState() => _RegistroTransacaoScreenState();
}

class _RegistroTransacaoScreenState extends State<RegistroTransacaoScreen> {
  final UsuarioService usuarioService = UsuarioService();
  final _formKey = GlobalKey<FormState>();
  final _valorController = TextEditingController();
  final _dataController = TextEditingController();
  DateTime _data = DateTime.now();
  String _tipo = 'Crédito';
  String _motivo = 'Água';
  List<Usuario> _usuarios = [];
  Usuario? _usuarioSelecionado;

  final List<String> _tiposTransacao = ['Crédito', 'Débito'];
  final List<String> _motivos = ['Água', 'Luz', 'Internet', 'Lazer', 'Alimentação', 'Outros'];

  @override
  void initState() {
    super.initState();
    _dataController.text = DateFormat('dd/MM/yyyy').format(_data);
    _carregarUsuarios();
  }

  @override
  void dispose() {
    _valorController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  _carregarUsuarios() async {
    var usuarios = await usuarioService.buscarTodos() ?? [];
    setState(() {
      _usuarios = usuarios;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _data) {
      setState(() {
        _data = pickedDate;
        _dataController.text = DateFormat('dd/MM/yyyy').format(_data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _valorController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Valor',
                prefixText: 'R\$ ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira um valor.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _dataController,
              decoration: InputDecoration(
                labelText: 'Data',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _tipo,
              decoration: const InputDecoration(
                labelText: 'Tipo',
                border: OutlineInputBorder(),
              ),
              items: _tiposTransacao.map((tipo) {
                return DropdownMenuItem(
                  value: tipo,
                  child: Text(tipo),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _tipo = value!;
                });
              },
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _motivo,
              decoration: const InputDecoration(
                labelText: 'Motivo',
                border: OutlineInputBorder(),
              ),
              items: _motivos.map((motivo) {
                return DropdownMenuItem(
                  value: motivo,
                  child: Text(motivo),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _motivo = value!;
                });
              },
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<Usuario?>(
              value: _usuarioSelecionado,
              decoration: const InputDecoration(
                labelText: 'Colaborador',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<Usuario?>(
                  value: null, // Valor nulo para deixar o campo vazio
                  child: Text('Selecione um colaborador'), // Texto exibido quando não há seleção
                ),
                ..._usuarios.map((usuario) {
                  return DropdownMenuItem(
                    value: usuario,
                    child: Text(usuario.usuario),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _usuarioSelecionado = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final novaTransacao = Transacao(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      valor: double.parse(_valorController.text),
                      tipo: _tipo,
                      data: _data,
                      motivo: _motivo,
                      usuarioId: '',
                      compartilhada: false,
                    );

                    widget.onNovaTransacao(novaTransacao);

                    final snackBar = SnackBar(
                      content: Text(
                        'A transação número ${novaTransacao.id}, no valor de R\$${novaTransacao.valor} foi salva com sucesso!',
                      ),
                      duration: const Duration(seconds: 2),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    _formKey.currentState?.reset();
                    _valorController.clear();

                    setState(() {
                      _formKey.currentState?.reset();
                      _data = DateTime.now();
                      _dataController.text = DateFormat('dd/MM/yyyy').format(_data);
                      _valorController.clear();
                      _tipo = 'Crédito';
                      _motivo = 'Água';
                    });

                    print('Transação registrada: $novaTransacao');
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text('Salvar'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
