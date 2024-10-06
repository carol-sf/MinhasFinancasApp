
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:minhas_financas_app/model/Usuario.dart';


class PerfilUsuarioScreen extends StatefulWidget {
  final Usuario usuario;

  const PerfilUsuarioScreen({super.key, required this.usuario});

  @override
  State<PerfilUsuarioScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilUsuarioScreen> {
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      
      ListResult result = await FirebaseStorage.instance.ref('images/').listAll();

      for (var ref in result.items) {
        // Obtém a metadata da imagem
        FullMetadata metadata = await ref.getMetadata();
        
        if (metadata.customMetadata != null &&
            metadata.customMetadata!['usuarioId'] == widget.usuario.id) {
          
          String downloadUrl = await ref.getDownloadURL();
          setState(() {
            _imageUrl = downloadUrl; 
          });
          break; 
        }
      }
    } catch (e) {
      print("Erro ao carregar a imagem: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
        backgroundColor: const Color.fromARGB(255, 23, 89, 233),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _imageUrl != null
                  ? CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(_imageUrl!), 
                    )
                  : const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 40),
                    ),
              const SizedBox(height: 16),
              Text(
                widget.usuario.email,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Senha: ********", 
                style:  TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}