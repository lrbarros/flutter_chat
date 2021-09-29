import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _getFirebase();
    return Container();

  }
  _getFirebase() async{
    await Firebase.initializeApp();
    FirebaseFirestore.instance.collection("col").doc("doc").set({"texto":"teste Luiz23"});
  }

}
