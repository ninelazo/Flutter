import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:servicio/features/user_auth/presentation/pages/login_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:servicio/features/user_auth/presentation/pages/search_page.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
final uid = FirebaseAuth.instance.currentUser?.uid;

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
      await Firebase.initializeApp(options: const FirebaseOptions(apiKey: "AIzaSyAh9AWJVHYinZWGThGhqWQLoeViJKOmhO0",
        appId: "1:376469018316:web:e6ce6dc7b7fb2c44ba9469",
        messagingSenderId: "376469018316",
        projectId: "servicio-e3883"));
  }
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Servicio',
      home: LoginPage(),
    );
  }
}


void anuncios_usuario() {
   var anuncio = db.collection("anuncios").doc(uid).get();
}