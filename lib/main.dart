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

class _HomePageState extends State<HomePage>{
  final supabase = Supabase.instance.client;
  List<dynamic> changas = [];
  bool loading = true;

  @override
  void initState(){
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
              try {
                await supabase.from('changas').insert({
                  'titulo': tituloCtrl.text,
                  'precio': int.tryParse(precioCtrl.text) ?? 0,
                  'estado': 'pendiente',
                });
                await NotiService.mostrarNotificacion('Changa publicada!', '${tituloCtrl.text} se publicó correctamente');
                if(mounted) Navigator.pop(c);
                cargarChangas();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
            child: const Text('Publicar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Image.asset('assets/images/logo.png', width: 32, height: 32),
          const SizedBox(width: 8),
          const Text('Changa App - Solano'),
        ]),
      ),
      body: loading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: changas.length,
        itemBuilder: (c,i){
          final ch = changas[i];
          return ListTile(
            leading: Image.asset('assets/images/logo.png', width: 40, height: 40),
            title: Text(ch['titulo'] ?? ''),
            subtitle: Text('\$${ch['precio']} - ${ch['estado']}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: crearChanga, label: const Text('Pedir Changa'), icon: const Icon(Icons.add)),
    );
  }
}
