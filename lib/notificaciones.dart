import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotiService {
  static final FlutterLocalNotificationsPlugin _noti =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Inicialización simple sin parámetros extra
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _noti.initialize(settings);
  }

  static Future<void> mostrarNotificacion(String titulo, String mensaje) async {
    const detalles = NotificationDetails(
      android: AndroidNotificationDetails(
        'canal_changa',
        'Changa App',
        importance: Importance.high,
      ),
    );
    await _noti.show(0, titulo, mensaje, detalles);
  }
}
