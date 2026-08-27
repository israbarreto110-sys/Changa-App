
import 'package:flutter/material.dart';
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ChangaApp - Login')),
      body: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.work, size:80, color: Colors.blue),
        const SizedBox(height:20),
        const TextField(decoration: InputDecoration(labelText:'Email', border: OutlineInputBorder())),
        const SizedBox(height:12),
        const TextField(obscureText:true, decoration: InputDecoration(labelText:'Password', border: OutlineInputBorder())),
        const SizedBox(height:20),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed:(){}, child: const Text('Entrar a ChangaApp'))),
      ])),
    );
  }
}
