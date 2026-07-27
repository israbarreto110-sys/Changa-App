import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  final String idChanga;
  final String idTrabajador;
  
  const ChatPage({super.key, required this.idChanga, required this.idTrabajador});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();

  void _enviarMensaje() {
    if (_controller.text.isEmpty) return;
    
    // Anti-telefono: borra numeros
    String mensaje = _controller.text.replaceAll(RegExp(r'[0-9]'), '*');
    
    FirebaseFirestore.instance.collection('chats').doc(widget.idChanga).collection('mensajes').add({
      'texto': mensaje,
      'de': widget.idTrabajador,
      'fecha': DateTime.now(),
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat Changa #${widget.idChanga.substring(0,4)}")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                 .collection('chats').doc(widget.idChanga)
                 .collection('mensajes').orderBy('fecha').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    bool soyYo = doc['de'] == widget.idTrabajador;
                    return Align(
                      alignment: soyYo? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: soyYo? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(doc['texto'], style: TextStyle(color: soyYo? Colors.white : Colors.black)),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(child: TextField(
                  controller: _controller, 
                  decoration: InputDecoration(
                    hintText: "Escribe aquí... *Los números se ocultan*",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))
                  ),
                  onSubmitted: (_) => _enviarMensaje(),
                )),
                IconButton(icon: Icon(Icons.send, color: Colors.blue), onPressed: _enviarMensaje),
              ],
            ),
          )
        ],
      ),
    );
  }
}
