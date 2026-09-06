import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'mapa_page.dart';
import 'notificaciones.dart';
import 'screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  
  await Supabase.initialize(
    url: 'https://tnfqcmbeonzicqoipjxm.supabase.co',
    anonKey: 'TU_CLAVE_ANONIMA_AQUI', // ← poné tu clave real acá
  );
  
  await NotiService.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChangaApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      navigatorKey: NotiService.navigatorKey, // ← depende de notifications.dart
    );
  }
}
