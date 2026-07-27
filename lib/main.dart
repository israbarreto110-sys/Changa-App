import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';

class NotiService {
  static final FlutterLocalNotificationsPlugin _noti = FlutterLocalNotificationsPlugin();

  static Future init() async {
    const AndroidInitializationSettings android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(android: android);

    await _noti.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) async {
        // CUANDO TOCAN LA NOTI SE ABRE GOOGLE MAPS
        String? payload = details.payload;
        if (payload!= null) {
          List coords = payload.split(',');
          double lat = double.parse(coords[0]);
          double lng = double.parse(coords[1]);
          _abrirGoogleMaps(lat, lng);
        }
      },
    );
  }

  // ABRIR GOOGLE MAPS CON LA UBICACIÓN
  static Future<void> _abrirGoogleMaps(double lat, double lng) async {
    String url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  // MANDAR NOTI CON UBICACIÓN
  static Future mostrarNotiChanga({
    required String titulo,
    required String body,
    required double lat,
    required double lng,
  }) async {

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'changa_channel',
      'Nuevas Changa',
      channelDescription: 'Notificaciones de changas cerca tuyo',
      importance: Importance.max,
      priority: Priority.high,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('ir', 'IR AHORA', showsUserInterface: true), // BOTÓN
      ],
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _noti.show(
      0,
      titulo, // Ej: "🔧 Plomería urgente"
      body, // Ej: "Palermo - A 1.2km - \$15000. Toca para ir"
      details,
      payload: '$lat,$lng', // Le pasamos la ubicación a la noti
    );
  }
}
