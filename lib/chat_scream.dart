import 'package:chat/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScream extends StatefulWidget {
  const ChatScream({Key? key}) : super(key: key);

  @override
  _ChatScreamState createState() => _ChatScreamState();
}

class _ChatScreamState extends State<ChatScream> {
  void _sendMessage(String text){
      FirebaseFirestore.instance.collection("messages").add({
        'text': text
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Olá "),
        elevation: 0,
      ),
      body: TextComposer(_sendMessage ),
    );
  }
}
