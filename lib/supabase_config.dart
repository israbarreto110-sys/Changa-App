import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const url = 'https://swpgngnutrejrmxdkbfn.supabase.co';
  static const anonKey = 'sb_publishable_rQTX59ekU8JIhzV2IXtw_Q_V9YWAdhJ';
  
  static Future<void> init() async {
    await Supabase.initialize(url: url, anonKey: anonKey);
  }
  static SupabaseClient get client => Supabase.instance.client;
}
