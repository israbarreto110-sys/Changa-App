import "package:flutter/material.dart";
class RegistroScreen extends StatelessWidget {
  const RegistroScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Cuenta')),
      body: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
        const TextField(decoration: InputDecoration(labelText:'Nombre', border: OutlineInputBorder())),
        const SizedBox(height:12),
        const TextField(decoration: InputDecoration(labelText:'Email', border: OutlineInputBorder())),
        const SizedBox(height:12),
        const TextField(obscureText:true, decoration: InputDecoration(labelText:'Password', border: OutlineInputBorder())),
        const SizedBox(height:20),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed:(){ Navigator.pop(context); }, child: const Text('Registrarse'))),
      ])),
    );
  }
}
