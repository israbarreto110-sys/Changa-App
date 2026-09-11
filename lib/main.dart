import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'notificaciones.dart'; // <-- tu archivo

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotiService.init(); // inicia notificaciones

  await Supabase.initialize(
    url: 'https://swpgngnutrejrmxdkbfn.supabase.co',
    anonKey: 'PEGA_AQUI_TU_KEY_COMPLETA_sb_publishable_...', // pegá la key completa acá
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Changa App',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.orange),
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

  @override
  void initState() {
    super.initState();
    cargarChangas();
  }

  Future<void> cargarChangas() async {
    setState(() => loading = true);
    final data = await supabase.from('changas').select().order('created_at', ascending: false);
    setState(() { changas = data; loading = false; });
  }

  Future<void> crearChanga() async {
    final tituloCtrl = TextEditingController();
    final precioCtrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Pedir Changa tipo Uber'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: tituloCtrl, decoration: const InputDecoration(labelText: '¿Qué necesitas?')),
          TextField(controller: precioCtrl, decoration: const InputDecoration(labelText: 'Precio \$'), keyboardType: TextInputType.number),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              await supabase.from('changas').insert({
                'titulo': tituloCtrl.text,
                'precio': int.tryParse(precioCtrl.text)?? 0,
                'estado': 'pendiente',
                'lat': -34.7, 'lng': -58.3,
              });
              await NotiService.mostrarNotificacion('Changa publicada!', '${tituloCtrl.text} se publicó correctamente');
              if(mounted) Navigator.pop(c);
              cargarChangas();
            },
            child: const Text('Publicar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Changa App - Changa cerca')),
      body: loading? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: changas.length,
              itemBuilder: (c, i) {
                final ch = changas[i];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(ch['titulo']?? ''),
                    subtitle: Text('Estado: ${ch['estado']} - \$${ch['precio']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.check_circle, color: Colors.green),
                      onPressed: () async {
                        await supabase.from('changas').update({'estado': 'tomada'}).eq('id', ch['id']);
                        await NotiService.mostrarNotificacion('¡Changa tomada!', 'Alguien tomó la changa: ${ch['titulo']}');
                        cargarChangas();
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: crearChanga,
        label: const Text('Pedir Changa'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
