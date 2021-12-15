import 'dart:io';

import 'package:chat/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'chat_message.dart';

class ChatScream extends StatefulWidget {
  const ChatScream({Key? key}) : super(key: key);

  @override
  _ChatScreamState createState() => _ChatScreamState();
}

class _ChatScreamState extends State<ChatScream> {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  User? _currentUser;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    try {
      FirebaseAuth.instance.authStateChanges().listen((user) {
        setState(() {
          this._currentUser = user;
        });
      });
    } catch (e) {
      print(e);
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Problema ao carregar"),backgroundColor: Colors.red,));
    }
  }

  Future<User?> getUser() async {
    if (this._currentUser != null) return this._currentUser;
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication!.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );
      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = authResult.user;

      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  void _sendMessage({String? text, File? imageFile}) async {
    final User? user = await getUser();

    if (user == null) {
      print("Não foi possível fazer o login tente novamente");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Não foi possível fazer o login tente novamente",
        ),
        backgroundColor: Colors.red,
      ));
      return;
    }

    Map<String, dynamic> data = {
      "uid": user.uid,
      "senderName": user.displayName,
      "senderPhotoUrl": user.photoURL,
      "time":  Timestamp.now()
    };
    if (imageFile != null) {
      setState(() {
        this.isLoading = true;
      });
      TaskSnapshot task = await FirebaseStorage.instance
          .ref()
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(imageFile);

      String url = await task.ref.getDownloadURL();
      data['imageUrl'] = url;

      setState(() {
        this.isLoading = false;
      });
    }
    if (text != null) data['text'] = text;

    FirebaseFirestore.instance.collection("messages").add(data);

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(this._currentUser != null
              ? 'Olá ${this._currentUser!.displayName}'
              : 'Chat App '),
          elevation: 0,
          centerTitle: true,
          actions: [
            this._currentUser != null
                ? IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      googleSignIn.signOut();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Você saiu com sucesso!",
                        ),
                      ));
                    },
                    icon: Icon(Icons.exit_to_app))
                : Container()
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream:  FirebaseFirestore.instance.collection("messages").orderBy("time").snapshots(),
              builder: (BuildContext context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    List<DocumentSnapshot> documents =
                        snapshot.data!.docs.reversed.toList();

                    return ListView.builder(
                        itemCount: documents.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          return ChatMessage(
                              documents[index].data() as Map<String, dynamic>,
                              (documents[index].data() as Map<String,dynamic>)['uid'] == _currentUser?.uid);
                        });
                }
              },
            )),
            this.isLoading ?LinearProgressIndicator():Container(),
            TextComposer(_sendMessage),
          ],
        ));
  }
}
