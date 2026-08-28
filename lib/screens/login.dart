import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "../mapa_page.dart";
import "registro.dart";
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;
  Future<void> login() async {
    setState(()=> loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailCtrl.text.trim(), password: passCtrl.text.trim());
      if (mounted) { Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MapaPage())); }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
    } finally { if (mounted) setState(()=> loading = false); }
  }
  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('ChangaApp - Login')), body: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.work, size:80, color: Colors.blue), const SizedBox(height:20),
        TextField(controller: emailCtrl, decoration: const InputDecoration(labelText:'Email', border: OutlineInputBorder())), const SizedBox(height:12),
        TextField(controller: passCtrl, obscureText:true, decoration: const InputDecoration(labelText:'Password', border: OutlineInputBorder())), const SizedBox(height:20),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: loading ? null : login, child: Text(loading ? 'Entrando...' : 'Entrar'))), const SizedBox(height:10),
        TextButton(onPressed:(){ Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistroScreen())); }, child: const Text('No tenes cuenta? Crear cuenta')),
      ])),
    );
  }
}
