import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'notificaciones.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://swpgngnutrejrmxdkbfn.supabase.co',
    anonKey: 'sb_publishable_rQTX59oKUK8J1hzV2iXtw_Q_V9YWAdhJ',
  );
  await NotiService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Changa App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFFFC300),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;
  List<dynamic> changas = [];
  bool loading = true;

  final Map<String, IconData> iconos = {
    'Jardinería': Icons.grass,
    'Pintura': Icons.format_paint,
    'Limpieza': Icons.cleaning_services,
    'Albañilería': Icons.construction,
    'Flete': Icons.local_shipping,
    'Electricidad': Icons.electrical_services,
    'Plomería': Icons.plumbing,
    'Otros': Icons.handyman,
  };

  @override
  void initState() {
    super.initState();
    cargarChangas();
  }

  Future<void> cargarChangas() async {
    setState(() => loading = true);
    final data = await supabase
       .from('changas')
       .select()
       .order('created_at', ascending: false);
    setState(() {
      changas = data;
      loading = false;
    });
  }

  Future<void> crearChanga() async {
    final tituloCtrl = TextEditingController();
    final precioCtrl = TextEditingController();
    String categoria = 'Jardinería';

    await showDialog(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Pedir Changa tipo Uber'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: categoria,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: iconos.keys
                   .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Row(
                            children: [
                              Icon(iconos[cat], size: 20),
                              const SizedBox(width: 8),
                              Text(cat),
                            ],
                          ),
                        ))
                   .toList(),
                onChanged: (v) {
                  if (v!= null) setDialogState(() => categoria = v);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: tituloCtrl,
                decoration: const InputDecoration(
                    labelText: '¿Qué necesitas? Ej: cortar pasto'),
              ),
              TextField(
                controller: precioCtrl,
                decoration: const InputDecoration(labelText: 'Precio \$'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(c),
                child: const Text('Cancelar')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC300)),
              onPressed: () async {
                try {
                  await supabase.from('changas').insert({
                    'titulo': '[$categoria] ${tituloCtrl.text}',
                    'precio': int.tryParse(precioCtrl.text)?? 0,
                    'estado': 'pendiente',
                  });
                  await NotiService.mostrarNotificacion(
                      'Changa publicada!', '$categoria: ${tituloCtrl.text}');
                  if (mounted) Navigator.pop(c);
                  cargarChangas();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')));
                }
              },
              child: const Text('Publicar'),
            ),
          ],
        ),
      ),
    );
  }

  IconData getIcono(String titulo) {
    for (var cat in iconos.keys) {
      if (titulo.contains('[$cat]')) return iconos[cat]!;
    }
    return Icons.work;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFC300),
        title: Row(
          children: [
            Image.asset('assets/images/logo.png',
                width: 32,
                height: 32,
                errorBuilder: (c, e, s) => const Icon(Icons.handyman)),
            const SizedBox(width: 8),
            const Text('Changa App - Solano',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: loading
         ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: changas.length,
              itemBuilder: (c, i) {
                final ch = changas[i];
                final titulo = ch['titulo']?? '';
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                        backgroundColor: const Color(0xFFFFC300),
                        child: Icon(getIcono(titulo), color: Colors.black)),
                    title: Text(titulo,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('\$${ch['precio']} - ${ch['estado']}'),
                    trailing: Image.asset('assets/images/logo.png',
                        width: 28,
                        height: 28,
                        errorBuilder: (c, e, s) => const SizedBox()),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFFFC300),
        foregroundColor: Colors.black,
        onPressed: crearChanga,
        label: const Text('Pedir Changa',
            style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
