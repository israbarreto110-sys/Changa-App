import 'package:cloud_firestore/cloud_firestore.dart';
import 'notificaciones.dart';
import 'dart:math';

class EnviarChangaService {
  static double _calcularDistancia(double lat1, double lng1, double lat2, double lng2) {
    var p = 0.017453292519943295;
    var a = 0.5 - cos((lat2 - lat1) * p)/2 +
          cos(lat1 * p) * cos(lat2 * p) *
          (1 - cos((lng2 - lng1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  static Future enviarNotiATrabajadoresCerca({
    required String titulo,
    required String body,
    required double latChanga,
    required double lngChanga,
    double radioKm = 5.0,
  }) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('trabajadores').get();

    for (var doc in snapshot.docs) {
      if(doc.data() != null && doc['lat'] != null && doc['lng'] != null){
        double latTrabajador = doc['lat'];
        double lngTrabajador = doc['lng'];
        double distancia = _calcularDistancia(latChanga, lngChanga, latTrabajador, lngTrabajador);

        if (distancia <= radioKm) {
          await NotiService.mostrarNotiChanga(
            titulo: titulo,
            body: "$body - A ${distancia.toStringAsFixed(1)}km",
            lat: latChanga,
            lng: lngChanga,
          );
        }
      }
    }
  }
}
