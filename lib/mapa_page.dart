import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapaPage extends StatefulWidget {
  const MapaPage({super.key});

  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  void initState() {
    super.initState();
    _guardarUbicacion();
  }

  Future _guardarUbicacion() async {
    Position position = await Geolocator.getCurrentPosition();
    String idTrabajador = "trabajador1";

    await FirebaseFirestore.instance.collection('trabajadores').doc(idTrabajador).set({
      'lat': position.latitude,
      'lng': position.longitude,
      'ultimaActualizacion': DateTime.now(),
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Changa App - Esperando changas")),
      body: Center(child: Text("Tu ubicación se está guardando...\nEspera notificaciones de changas cerca")),
    );
  }
}
