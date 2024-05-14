

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:servicio/features/user_auth/presentation/pages/home_page.dart';
import 'package:servicio/features/user_auth/presentation/pages/search_page.dart';


///ESTA PÁGINA SOLO APARECE TRAS COMPLETAR EL REGISTRO DEL USUARIO.
///AQUI SE COMPLETA LOS DATOS DEL USUARIO (NOMBRE, TLF, FOTO PERFIL...)

FirebaseFirestore db = FirebaseFirestore.instance;
final uid = FirebaseAuth.instance.currentUser?.uid;
FirebaseStorage _storage = FirebaseStorage.instance;

class Profile extends StatefulWidget {
  Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _telefono2Controller = TextEditingController();
  final TextEditingController _empresaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Información de usuario"), centerTitle: true, backgroundColor: Colors.teal,),
      body: SingleChildScrollView(
        child:
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          hintText: "Nombre", icon: Icon(Icons.person_2_rounded)),
                      controller: _nombreController,
                      maxLength: 20,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          hintText: "Apellidos",
                          icon: Icon(Icons.person_2_rounded)),
                      controller: _apellidoController,
                      maxLength: 20,
                    ),
                    TextFormField(
                        decoration: const InputDecoration(
                            hintText: "Nombre de la empresa (opcional)",
                            icon: Icon(Icons.business)),
                        controller: _empresaController,
                        maxLength: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                          hintText: "Teléfono 1",
                          icon: Icon(Icons.phone_android_rounded)),
                      controller: _telefonoController,
                      maxLength: 15,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          hintText: "Telefono 2 (opcional)",
                          icon: Icon(Icons.phone)),
                      controller: _telefono2Controller,
                      maxLength: 15,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: upload_profile,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                        child: const Center(
                          child: Text(
                            "Finalizar registro",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    ),
    );
            }

  String? uid = FirebaseAuth.instance.currentUser?.uid;

  // Esta funcion crea el perfil del usuario y lo actualiza con los datos previamente introducidos por él.
  Future<void> upload_profile() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    var _perfil = <String, dynamic>{
      "nombre": _nombreController.text,
      "apellidos": _apellidoController.text,
      "empresa": _empresaController.text,
      "telefono1": _telefonoController.text,
      "telefono2": _telefono2Controller.text,
      "urlPerfil": "https://cvhrma.org/wp-content/uploads/2015/07/default-profile-photo.jpg"
    };

    var _anuncios = <String, dynamic> {
      "anuncios" : 0,
    };

    db.collection("usuarios").doc(uid).set(_perfil);
    db.collection("anuncios").doc(uid).set(_anuncios);
    db.collection("anuncios").doc(uid).collection("anuncios").doc("$uid-0").set({"nombre_anuncio":"",
                                                                                  "imagen_principal":""});
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => const Search_page()), (route) => false);
  }
}
