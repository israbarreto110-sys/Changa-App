import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapaPage extends StatefulWidget {
  const MapaPage({super.key});

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  LatLng? _miUbicacion;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _obtenerUbicacion();
  }

  Future<void> _obtenerUbicacion() async {
    // 1. Pide permiso
    LocationPermission permission = await Geolocator.requestPermission();
    
    // 2. Obtiene ubicación actual
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    setState(() {
      _miUbicacion = LatLng(position.latitude, position.longitude);
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Changa App - Cerca tuyo'),
        backgroundColor: Colors.orange,
      ),
      body: _cargando
          ? Center(child: CircularProgressIndicator())
          : FlutterMap(
              options: MapOptions(
                initialCenter: _miUbicacion ?? LatLng(-38.4161, -63.6167),
                initialZoom: 12.0, // Zoom más cerca para ver tu zona
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(
                  markers: [
                    // PIN AZUL = VOS
                    Marker(
                      point: _miUbicacion!,
                      child: Icon(Icons.person_pin_circle, color: Colors.blue, size: 45),
                    ),
                    // PIN ROJO = EJEMPLO DE CHANGA
                    Marker(
                      point: LatLng(-34.6037, -58.3816), // Obelisco
                      child: Icon(Icons.work, color: Colors.red, size: 35),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
