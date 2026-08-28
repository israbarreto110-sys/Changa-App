import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});
  @override State<RegistroScreen> createState() => _RegistroScreenState();
}
class _RegistroScreenState extends State<RegistroScreen> {
  final nombreCtrl = TextEditingController(); final emailCtrl = TextEditingController(); final passCtrl = TextEditingController(); bool loading = false;
  Future<void> registrar() async {
    setState(()=> loading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailCtrl.text.trim(), password: passCtrl.text.trim());
      await FirebaseAuth.instance.currentUser?.updateDisplayName(nombreCtrl.text.trim());
      if (mounted) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cuenta creada!'))); Navigator.pop(context); }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
    } finally { if (mounted) setState(()=> loading = false); }
  }
  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Crear Cuenta')), body: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
        TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText:'Nombre', border: OutlineInputBorder())), const SizedBox(height:12),
        TextField(controller: emailCtrl, decoration: const InputDecoration(labelText:'Email', border: OutlineInputBorder())), const SizedBox(height:12),
        TextField(controller: passCtrl, obscureText:true, decoration: const InputDecoration(labelText:'Password min 6', border: OutlineInputBorder())), const SizedBox(height:20),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: loading ? null : registrar, child: Text(loading ? 'Creando...' : 'Registrarse'))),
      ])),
    );
  }
}
