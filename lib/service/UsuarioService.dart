import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minhas_financas_app/model/Usuario.dart';

class UsuarioService {
  CollectionReference<Map<String, dynamic>> colecaoUsuarios =
      FirebaseFirestore.instance.collection('usuarios');

  Future<Usuario?> registrar(Usuario usuario) async {
    try {
      DocumentReference docRef = await colecaoUsuarios.add(usuario.toMap());
      DocumentSnapshot usuarioDoc = await docRef.get();
      if(usuarioDoc.exists) {
        Usuario usuario = Usuario.fromMap(usuarioDoc as Map<String, dynamic>, usuarioDoc.id);
        return usuario;
      } else {
        print('Erro ao buscar usuario criado');
        return null;
      }
    } catch (e) {
      print('Erro ao registrar usuário: $e');
      return null;
    }
  }

  Future<bool> atualizarSaldo(
      String id, double valor, String tipoTransacao) async {
    try {
      DocumentSnapshot usuarioSnapshot = await colecaoUsuarios.doc(id).get();
      if (usuarioSnapshot.exists) {
        if (tipoTransacao == 'Crédito') {
          var creditoAtual =
              double.parse(usuarioSnapshot['creditoTotal'].toString());
          colecaoUsuarios
              .doc(id)
              .update({'creditoTotal': creditoAtual + valor});
          return true;
        } else if (tipoTransacao == 'Débito') {
          var debitoAtual =
              double.parse(usuarioSnapshot['debitoTotal'].toString());
          colecaoUsuarios.doc(id).update({'debitoTotal': debitoAtual + valor});
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Erro ao adicionar credito ou debito: $e');
      return false;
    }
  }

  adicionarColaborador(String id, String colaboradorId) {
    try {
      colecaoUsuarios.doc(id).update({'colaboradorId': colaboradorId});
    } catch (e) {
      print('Erro ao adicionar colaborador: $e');
    }
  }

  Future<Usuario?> buscarPorId(String id) async {
    try {
      DocumentSnapshot documentSnapshot = await colecaoUsuarios.doc(id).get();

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

  Future<Usuario?> buscarPorEmail(String email) async {
    try {
      QuerySnapshot querySnapshot =
          await colecaoUsuarios.where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot usuarioDoc = querySnapshot.docs.first;
        Usuario usuario = Usuario.fromMap(
          usuarioDoc.data() as Map<String, dynamic>,
          usuarioDoc.id,
        );
        return usuario;
      } else {
        print('Nenhum usuário encontrado com esse email');
        return null;
      }
    } catch (e) {
      print('Erro ao buscar usuário: $e');
      return null;
    }
  }

  Future<List<Usuario>?> buscarTodos() async {
    try {
      List<Usuario> usuarios = [];
      QuerySnapshot querySnapshot = await colecaoUsuarios.get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var docRef in querySnapshot.docs.toList()) {
          usuarios.add(Usuario.fromMap(
              docRef.data() as Map<String, dynamic>, docRef.id));
        }
      }
      return usuarios;
    } catch (e) {
      print('Erro ao buscar usuários: $e');
      return null;
    }
  }
}
