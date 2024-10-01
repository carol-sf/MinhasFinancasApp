import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minhas_financas_app/model/Usuario.dart';

class UsuarioService {
  CollectionReference<Map<String, dynamic>> usuarios =
      FirebaseFirestore.instance.collection('usuarios');

  registrar(Usuario usuario) {
    try {
      usuarios.add(usuario.toMap());
    } catch(e) {
      print('Erro ao registrar usuário: $e');
    }
  }

  adicionarColaborador(String id, String colaboradorId) {
    try {
      usuarios.doc(id).update({'colaboradorId': colaboradorId});
    } catch(e) {
      print('Erro ao adicionar colaborador: $e');
    }
  }

  Future<Usuario?> buscarPorId(String id) async {
    try {
      DocumentSnapshot documentSnapshot = await usuarios.doc(id).get();

      if (documentSnapshot.exists) {
        return Usuario.fromMap(documentSnapshot.data() as Map<String, dynamic>,
            documentSnapshot.id);
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao buscar usuário: $e');
      return null;
    }
  }
}
