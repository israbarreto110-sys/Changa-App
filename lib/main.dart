import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://swpgngnutrejrmxdkbfn.supabase.co',
    anonKey: 'sb_publishable_rQTX59kU8JJhv2IXtw_Q_V9YwAdhJ',
  );
  runApp(ChangaApp());
}

class ChangaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Changa App Solano',
      theme: ThemeData(primaryColor: Color(0xFFFFC107)),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;
  List<dynamic> trabajadores = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargarTrabajadores();
  }

  Future<void> cargarTrabajadores() async {
    final res = await supabase
       .from('trabajadores')
       .select()
       .eq('disponible', true)
       .order('rating', ascending: false);
    setState(() {
      trabajadores = res;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFC107),
        title: Text('Changa App - Solano', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: loading
         ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: trabajadores.length,
              itemBuilder: (context, i) {
                final t = trabajadores[i];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: Text(t['oficio'][0].toUpperCase()),
                    ),
                    title: Text('${t['nombre']} - ${t['oficio']}'),
                    subtitle: Text('${t['zona']} - \$${t['precio_hora']}/hora ⭐${t['rating']}'),
                    trailing: Icon(Icons.whatsapp, color: Colors.green, size: 32),
                  ),
                );
              },
            ),
    );
  }
}
