import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapaPage extends StatelessWidget {
  const MapaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Changa App - Argentina'),
        backgroundColor: Colors.orange,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(-38.4161, -63.6167), // Centro de Argentina
          initialZoom: 4.0, // Zoom chico para ver todo el país
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: [
              // Pin en CABA
              Marker(
                point: LatLng(-34.6037, -58.3816),
                child: Icon(Icons.location_on, color: Colors.red, size: 35),
              ),
              // Pin en Córdoba
              Marker(
                point: LatLng(-31.4201, -64.1888),
                child: Icon(Icons.location_on, color: Colors.blue, size: 35),
              ),
              // Pin en Rosario
              Marker(
                point: LatLng(-32.9468, -60.6393),
                child: Icon(Icons.location_on, color: Colors.green, size: 35),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
