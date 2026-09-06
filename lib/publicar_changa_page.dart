import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'enviar_changa.dart';

class PublicarChangaPage extends StatefulWidget {
  const PublicarChangaPage({super.key});

  @override
  State<PublicarChangaPage> createState() => _PublicarChangaPageState();
}

class _PublicarChangaPageState extends State<PublicarChangaPage> {
  final _tituloCtrl = TextEditingController();
  final _descCtrl = TextEditingController(text: "Se rompió caño plomería");
  final _precioCtrl = TextEditingController(text: "15000");
  bool _cargando = false;

  Future<void> _publicar() async {
    if (!mounted) return;
    setState(() => _cargando = true);

    try {
      // Verificar permiso y obtener ubicación
      bool permiso = await Geolocator.isLocationServiceEnabled();
      if (!permiso) {
        throw Exception("Activa la ubicación para publicar");
      }

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      final supabase = Supabase.instance.client;

      final res = await supabase.from('changa').insert({
        'titulo': _tituloCtrl.text,
        'descripcion': _descCtrl.text,
        'precio': double.tryParse(_precioCtrl.text) ?? 0,
        'lat': pos.latitude,
        'lng': pos.longitude,
        'estado': 'pendiente',
        'created_at': DateTime.now().toIso8601String(),
      }).select();

      if (!mounted) return;

      final changaId = res.isNotEmpty ? res.first['id'].toString() : '';

      // ✅ Corregida la escritura: Profesional
      if (changaId.isNotEmpty) {
        await EnviarChangaService.enviarAProfesionalesCerca(
          idChanga: changaId,
          lat: pos.latitude,
          lng: pos.longitude,
          titulo: _tituloCtrl.text,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Changa publicada! ID: $changaId")),
        );
        // Limpiar campos
        _tituloCtrl.clear();
        _descCtrl.text = "Se rompió caño plomería";
        _precioCtrl.text = "15000";
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Publicar Changa - V60")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _tituloCtrl,
              decoration: const InputDecoration(labelText: "Título"),
            ),
            TextField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: "Descripción"),
            ),
            TextField(
              controller: _precioCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Precio"),
            ),
            const SizedBox(height: 20),
            _cargando
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _publicar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    child: const Text(
                      "PUBLICAR CHANGA",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
