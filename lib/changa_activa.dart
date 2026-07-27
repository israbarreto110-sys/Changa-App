import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_page.dart'; // <-- ESTA LINEA NUEVA

class ChangaActivaPage extends StatelessWidget {
  final double precio;
  final double montoVisita; 
  final String idChanga;
  
  const ChangaActivaPage({super.key, required this.precio, required this.montoVisita, required this.idChanga});

  void _cobrar(BuildContext context, String tipo) async {
    double montoTotal = tipo == "visita" ? montoVisita : precio;
    double porcentajeComision = tipo == "visita" ? 0.10 : 0.15; // 10% visita, 15% trabajo
    double comision = montoTotal * porcentajeComision;
    double montoTrabajador = montoTotal - comision;
    
    await FirebaseFirestore.instance.collection('pagos').add({
      'idChanga': idChanga,
      'tipo': tipo,
      'montoTotal': montoTotal,
      'porcentajeComision': porcentajeComision * 100,
      'comisionApp': comision,
      'montoTrabajador': montoTrabajador,
      'fecha': DateTime.now(),
    });

    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text("✅ Cobro registrado"),
      content: Text("Total: \$${montoTotal.toStringAsFixed(0)}\nTu cobro: \$${montoTrabajador.toStringAsFixed(0)}\nComisión App: \$${comision.toStringAsFixed(0)}"),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))]
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Changa Activa")),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Precio total: \$${precio.toStringAsFixed(0)}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text("Monto visita: \$${montoVisita.toStringAsFixed(0)}", style: TextStyle(fontSize: 16, color: Colors.grey)),
          SizedBox(height: 30),
          
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: Size(250, 50)), 
            onPressed: () => _cobrar(context, "trabajo"), 
            child: Text("REALIZAR TRABAJO - \$${precio.toStringAsFixed(0)}")
          ),
          
          SizedBox(height: 15),
          
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: Size(250, 50)), 
            onPressed: () => _cobrar(context, "visita"), 
            child: Text("SOLO VISITA - \$${montoVisita.toStringAsFixed(0)}")
          ),
          
          SizedBox(height: 15),

          // BOTON NUEVO DEL CHAT
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, minimumSize: Size(250, 50)), 
            onPressed: () => Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => ChatPage(idChanga: idChanga, idTrabajador: "trabajador1"))
            ), 
            child: Text("💬 CHATEAR CON CLIENTE")
          ),
          
        ]),
      ),
    );
  }
}
