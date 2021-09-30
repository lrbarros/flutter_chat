import 'package:chat/text_composer.dart';
import 'package:flutter/material.dart';

class ChatScream extends StatefulWidget {
  const ChatScream({Key? key}) : super(key: key);

  @override
  _ChatScreamState createState() => _ChatScreamState();
}

class _ChatScreamState extends State<ChatScream> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Olá "),
        elevation: 0,
      ),
      body: TextComposer(),
    );
  }
}
