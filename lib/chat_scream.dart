import 'dart:io';

import 'package:chat/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ChatScream extends StatefulWidget {
  const ChatScream({Key? key}) : super(key: key);

  @override
  _ChatScreamState createState() => _ChatScreamState();
}

class _ChatScreamState extends State<ChatScream> {
  void _sendMessage({String? text, File? imageFile}) async {
    Map<String, dynamic> data = {};
    if (imageFile != null) {
      TaskSnapshot task = await FirebaseStorage.instance
          .ref()
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(imageFile);

      String url = await task.ref.getDownloadURL();
      data['imageUrl'] = url;
    }
    if (text != null) data['text'] = text;

    FirebaseFirestore.instance.collection("messages").add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Olá "),
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("messages").snapshots(),
              builder: (BuildContext context, snapshot) {
                switch(snapshot.connectionState){
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    List<DocumentSnapshot> documents = snapshot.data!.docs.reversed.toList();
                    
                    return ListView.builder(
                        itemCount:  documents.length,
                        reverse: true,
                        itemBuilder: (context,index){
                          return ListTile(
                            title: Text(documents[index].get('text')),
                          );
                        });
                }
              },
            )),
            TextComposer(_sendMessage),
          ],
        ));
  }
}
