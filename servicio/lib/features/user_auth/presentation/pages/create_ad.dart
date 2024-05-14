// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:servicio/features/user_auth/presentation/pages/my_ads.dart';
import 'package:servicio/features/user_auth/widgets/bottomBar_widget.dart';
import "package:google_places_flutter/google_places_flutter.dart";
import "package:geoflutterfire2/geoflutterfire2.dart";
import "package:image_picker/image_picker.dart";


/// ESTA PAGINA SE UTILIZA AL CREAR UN NUEVO ANUNCIO.
/// PARA ACCEDER A ELLA DESDE LA APLICACION TIENES QUE IR A MIS ANUNCIOS -> CREAR NUEVO ANUNCIO


FirebaseFirestore db = FirebaseFirestore.instance;
final uid = FirebaseAuth.instance.currentUser?.uid;
final geo = GeoFlutterFire();
FirebaseStorage _storage = FirebaseStorage.instance;



class Create_Ad extends StatefulWidget {
  const Create_Ad({super.key});

  @override
  State<Create_Ad> createState() => _Create_AdState();
}

class _Create_AdState extends State<Create_Ad> {
  TextEditingController _nombreAnuncioController = TextEditingController();

  TextEditingController _descripcionAnuncioController = TextEditingController();

  TextEditingController _telefono1Controller = TextEditingController();

  TextEditingController _telefono2Controller = TextEditingController();

  TextEditingController _empresaController = TextEditingController();

  TextEditingController _direccion = TextEditingController();

  late var Lat;
  late var Lon;
  bool isLoading = false;

  String categoria = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear nuevo anuncio"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: const BottomBar(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Scrollbar(
            thickness: 7,
            radius: const Radius.circular(15),
            child: ListView(
              children: [
                Center(
                  child: isLoading
                      ? const SpinKitWaveSpinner(color: Colors.blue)
                      : StreamBuilder<DocumentSnapshot>(
                        stream: db.collection("anuncios").doc(uid).collection("anuncios").doc("$uid-$contador").snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: SpinKitWaveSpinner(color: Colors.teal),);
                          } else if (snapshot.hasData){
                          return Column(
                              children: [
                                Container(
                                    height: 55,
                                    width: double.infinity,
                                    decoration:
                                        const BoxDecoration(color: Colors.black12),
                                    child: const Center(
                                      child: Text("Datos principales",
                                          style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w600)),
                                    )),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      hintText: "Nombre del anuncio",
                                      icon: Icon(Icons.abc_rounded)),
                                  controller: _nombreAnuncioController,
                                  maxLength: 25,
                                ),
                                GooglePlaceAutoCompleteTextField(
                                  textEditingController: _direccion,
                                  googleAPIKey:
                                      "AIzaSyB_T-_oOzeMzp5b3COOWIs9_K08bGxayO0",
                                  inputDecoration: const InputDecoration(
                                      hintText: "Dirección",
                                      icon: Icon(Icons.pin_drop)),
                                  isLatLngRequired: true,
                                  getPlaceDetailWithLatLng:
                                      (Prediction prediction) {
                                    Lat = prediction.lat;
                                    Lon = prediction.lng;
                                  },
                                  itemClick: (Prediction prediction) {
                                    _direccion.text = prediction.description!;
                                  },
                                  boxDecoration: const BoxDecoration(),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      hintText: "Teléfono 1",
                                      icon: Icon(Icons.phone_android_rounded)),
                                  controller: _telefono1Controller,
                                  maxLength: 15,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      hintText: "Telefono 2 (opcional)",
                                      icon: Icon(Icons.phone)),
                                  controller: _telefono2Controller,
                                  maxLength: 15,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      hintText: "Empresa (Opcional)",
                                      icon: Icon(Icons.business_sharp)),
                                  controller: _empresaController,
                                  maxLength: 20,
                                ),
                                TextFormField(
                                    decoration: const InputDecoration(
                                        hintText: "Descripción del anuncio",
                                        border: OutlineInputBorder()),
                                    controller: _descripcionAnuncioController,
                                    maxLength: 1000,
                                    minLines: 5,
                                    maxLines: 10),
                                const SizedBox(height: 20),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black26),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Column(
                                    children: [
                                      Container(color: const Color.fromRGBO(0, 0, 0, 0.3),
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(context: context, builder: (context) {
                                              return Dialog(
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: <Widget>[
                                                          Expanded(child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                categoria = "Abogado";
                                                              });
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Container(
                                                              margin: const EdgeInsets.all(5),
                                                              height: 100,
                                                              decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(5)),
                                                              child: const Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.all(5.0),
                                                                    child: Icon(Octicons.law, size: 40,),
                                                                  ),
                                                                  Text("Abogado", style: TextStyle(fontSize: 16)),
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                          Expanded(child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                categoria = "Arquitecto";
                                                              });
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(5)),
                                                              margin: const EdgeInsets.all(5),
                                                              height: 100,
                                                              child: const Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.all(5.0),
                                                                    child: Icon(FontAwesome5.pencil_ruler, size: 40,),
                                                                  ),
                                                                  Text("Arquitecto", style: TextStyle(fontSize: 16)),
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Expanded(child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                categoria = "Cerrajero";
                                                              });
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Container(
                                                              margin: const EdgeInsets.all(5),
                                                              height: 100,
                                                              decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(5)),
                                                              child: const Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.all(5.0),
                                                                    child: Icon(Linecons.key, size: 40,),
                                                                  ),
                                                                  Text("Cerrajero", style: TextStyle(fontSize: 16)),
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                          Expanded(child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                categoria = "Decorador interiores";
                                                              });
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(5)),
                                                              margin: const EdgeInsets.all(5),
                                                              height: 100,
                                                              child: const Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.all(5.0),
                                                                    child: Icon(Icons.chair_rounded, size: 40,),
                                                                  ),
                                                                  Text("Decorador", style: TextStyle(fontSize: 16)),
                                                                  Text("interiores", style: TextStyle(fontSize: 16),),
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Expanded(child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                categoria = "Mecanico";
                                                              });
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Container(
                                                              margin: const EdgeInsets.all(5),
                                                              height: 100,
                                                              decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(5)),
                                                              child: const Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.all(5.0),
                                                                    child: Icon(FontAwesome5.car_crash, size: 40,),
                                                                  ),
                                                                  Text("Mecánico", style: TextStyle(fontSize: 16)),
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                          Expanded(child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                categoria = "Transportista";
                                                              });
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(5)),
                                                              margin: const EdgeInsets.all(5),
                                                              height: 100,
                                                              child: const Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.all(5.0),
                                                                    child: Icon(Icons.fire_truck, size: 40,),
                                                                  ),
                                                                  Text("Transportista", style: TextStyle(fontSize: 16)),
                                                                ],
                                                              ),
                                                            ),
                                                          )),

                                                        ],
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Expanded(child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                categoria = "Electricista";
                                                              });
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Container(
                                                              margin: const EdgeInsets.all(5),
                                                              height: 100,
                                                              decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(5)),
                                                              child: const Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.all(5.0),
                                                                    child: Icon(Icons.cable, size: 40,),
                                                                  ),
                                                                  Text("Electricista", style: TextStyle(fontSize: 16)),
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                          Expanded(child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                categoria = "Limpieza";
                                                              });
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Container(
                                                              margin: const EdgeInsets.all(5),
                                                              height: 100,
                                                              decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(5)),
                                                              child: const Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.all(5.0),
                                                                    child: Icon(Icons.cleaning_services, size: 40,),
                                                                  ),
                                                                  Text("Limpieza", style: TextStyle(fontSize: 16)),
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Expanded(child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                categoria = "Programador";
                                                              });
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Container(
                                                              margin: const EdgeInsets.all(5),
                                                              height: 100,
                                                              decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(5)),
                                                              child: const Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.all(5.0),
                                                                    child: Icon(FontAwesome5.laptop_code, size: 40,),
                                                                  ),
                                                                  Text("Programador", style: TextStyle(fontSize: 16)),
                                                                ],
                                                              ),
                                                            ),
                                                          )),

                                                          Expanded(child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                categoria = "Diseño grafico";
                                                              });
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(5)),
                                                              margin: const EdgeInsets.all(5),
                                                              height: 100,
                                                              child: const Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.all(5.0),
                                                                    child: Icon(Icons.design_services, size: 40,),
                                                                  ),
                                                                  Text("Diseño gráfico", style: TextStyle(fontSize: 16)),
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Expanded(child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                categoria = "Profesor";
                                                              });
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Container(
                                                              margin: const EdgeInsets.all(5),
                                                              height: 100,
                                                              decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(5)),
                                                              child: const Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.all(5.0),
                                                                    child: Icon(FontAwesome5.chalkboard_teacher, size: 40,),
                                                                  ),
                                                                  Text("Profesor", style: TextStyle(fontSize: 16)),
                                                                ],
                                                              ),
                                                            ),
                                                          )),

                                                          Expanded(child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                categoria = "Asesor";
                                                              });
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(5)),
                                                              margin: const EdgeInsets.all(5),
                                                              height: 100,
                                                              child: const Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.all(5.0),
                                                                    child: Icon(Entypo.book, size: 40,),
                                                                  ),
                                                                  Text("Asesor", style: TextStyle(fontSize: 18)),
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Expanded(child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                categoria = "Reparacion ordenadores";
                                                              });
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Container(
                                                              margin: const EdgeInsets.all(5),
                                                              height: 100,
                                                              decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(5)),
                                                              child: const Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.all(5.0),
                                                                    child: Icon(Icons.laptop_chromebook, size: 40,),
                                                                  ),
                                                                  Text("Reparación", style: TextStyle(fontSize: 16)),
                                                                  Text("ordenadores", style: TextStyle(fontSize: 16),)
                                                                ],
                                                              ),
                                                            ),
                                                          )),

                                                          Expanded(child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                categoria = "Reparacion moviles";
                                                              });
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(5)),
                                                              margin: const EdgeInsets.all(5),
                                                              height: 100,
                                                              child: const Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.all(5.0),
                                                                    child: Icon(Icons.smartphone, size: 40,),
                                                                  ),
                                                                  Text("Reparación", style: TextStyle(fontSize: 16)),
                                                                  Text("móviles", style: TextStyle(fontSize: 16)),
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Expanded(child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                categoria = "Reparacion electrodomesticos";
                                                              });
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Container(
                                                              margin: const EdgeInsets.all(5),
                                                              height: 100,
                                                              decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(5)),
                                                              child: const Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.all(5.0),
                                                                    child: Icon(Icons.microwave_outlined, size: 40,),
                                                                  ),
                                                                  Text("Reparación", style: TextStyle(fontSize: 16)),
                                                                  Text("electrodomésticos", style: TextStyle(fontSize: 16),)
                                                                ],
                                                              ),
                                                            ),
                                                          )),

                                                          Expanded(child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                categoria = "Asesor inmobiliario";
                                                              });
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(5)),
                                                              margin: const EdgeInsets.all(5),
                                                              height: 100,
                                                              child: const Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.all(5.0),
                                                                    child: Icon(FontAwesome5.building, size: 40,),
                                                                  ),
                                                                  Text("Asesor", style: TextStyle(fontSize: 16)),
                                                                  Text("inmobiliario", style: TextStyle(fontSize: 16)),
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),);
                                            },);
                                          },
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: SizedBox(
                                                    width: double.infinity,
                                                    height: 85,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: Column(
                                                        children: [
                                                          const Center(child: Text("Seleccionar categoría del anuncio:",style: TextStyle(fontSize: 20),)),
                                                          const SizedBox(height: 10,),
                                                          Center(child: Text(categoria, style: const TextStyle(fontSize: 20),),)
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                              Container(
                                                height: 50,
                                                margin: const EdgeInsetsDirectional.only(end: 10),
                                                child: const Icon(Icons.chevron_right, size: 25),)
                                            ],
                                          ),

                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all()),
                                  padding: const EdgeInsets.all(5),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        const Text("Imagen principal",
                                            style: TextStyle(
                                                fontSize: 26,
                                                fontWeight: FontWeight.w500)),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(onTap: imagen_principal,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: const Color.fromRGBO(0, 0, 0, 0.07)),
                                              child: Padding(
                                                padding: const EdgeInsets.all(5),
                                                child: Image.network(
                                                    snapshot.data!["imagen_principal"], loadingBuilder: (BuildContext context, Widget child,
                                                    ImageChunkEvent? loadingProgress) {
                                                  if (loadingProgress == null){
                                                    return child;
                                                  }
                                                  return const SpinKitWaveSpinner(color: Colors.teal);
                                                }),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Text("Pulsa en la foto para editar")
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Divider(
                                  color: Colors.black54,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text("Imagenes adicionales",
                                    style: TextStyle(fontSize: 18)),
                                const SizedBox(
                                  height: 12,
                                ),
                                Row(
                                    verticalDirection: VerticalDirection.down,
                                    textDirection: TextDirection.rtl,
                                    children: <Widget>[
                                      Expanded(
                                        child: GestureDetector(onTap: imagen_1,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all()),
                                              padding: const EdgeInsets.all(5),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(3.0),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    8),
                                                            color: const Color.fromRGBO(0, 0, 0, 0.07)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(5),
                                                          child: Image.network(
                                                              snapshot.data!["imagen_1"], loadingBuilder: (BuildContext context, Widget child,
                                                              ImageChunkEvent? loadingProgress) {
                                                            if (loadingProgress == null){
                                                              return child;
                                                            }
                                                            return const SpinKitWaveSpinner(color: Colors.teal);
                                                          },),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(onTap: imagen_2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all()),
                                              padding: const EdgeInsets.all(5),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(3.0),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    8),
                                                            color: const Color.fromRGBO(0, 0, 0, 0.07)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(5),
                                                          child: Image.network(
                                                              snapshot.data!["imagen_2"], loadingBuilder: (BuildContext context, Widget child,
                                                              ImageChunkEvent? loadingProgress) {
                                                            if (loadingProgress == null){
                                                              return child;
                                                            }
                                                            return const SpinKitWaveSpinner(color: Colors.teal);
                                                          },),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(onTap: imagen_3,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all()),
                                              padding: const EdgeInsets.all(5),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(3.0),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    8),
                                                            color: const Color.fromRGBO(0, 0, 0, 0.07)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(5),
                                                          child: Image.network(
                                                              snapshot.data!["imagen_3"], loadingBuilder: (BuildContext context, Widget child,
                                                              ImageChunkEvent? loadingProgress) {
                                                            if (loadingProgress == null){
                                                              return child;
                                                            }
                                                            return const SpinKitWaveSpinner(color: Colors.teal);
                                                          },),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(onTap: imagen_4,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all()),
                                              padding: const EdgeInsets.all(5),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(3.0),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    8),
                                                            color: const Color.fromRGBO(0, 0, 0, 0.07)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(5),
                                                          child: Image.network(
                                                              snapshot.data!["imagen_4"], loadingBuilder: (BuildContext context, Widget child,
                                                              ImageChunkEvent? loadingProgress) {
                                                            if (loadingProgress == null){
                                                              return child;
                                                            }
                                                            return const SpinKitWaveSpinner(color: Colors.teal);
                                                          },),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                                const SizedBox(
                                  height: 25,
                                ),
                                GestureDetector(
                                  onTap: () => publicar(),
                                  child: Container(
                                    width: double.infinity,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.teal,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Publicar anuncio",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );} else {
                            return const Center(child: Text(("Error al cargar sus datos"),style: TextStyle(fontSize: 30),));
                          }
                        }
                      ),
                ),
              ],
            )),
      ),
    );
  }


  // Esta funcion crea el anuncio en la BBDD y actualiza los datos del mismo con los parametros introducidos por el usuario.
  void publicar() async {

    if (_direccion.text.isEmpty) {

      showDialog(context: (context), builder: (BuildContext context){
        return AlertDialog(
          title: const Text("El campo 'Dirección' no puede estar vacío",),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(context).pop();
            },
                child: const Text("Ok"))
          ],);
      });

    } else {

    isLoading = true;

    double lat = double.parse(Lat);
    double lon = double.parse(Lon);

    GeoFirePoint miUbicacion = geo.point(latitude: lat, longitude: lon);

    var _anuncio = <String, dynamic>{
      "nombre_anuncio": _nombreAnuncioController.text,
      "Telefono1": _telefono1Controller.text,
      "Telefono2": _telefono2Controller.text,
      "email" : FirebaseAuth.instance.currentUser!.email,
      "Empresa": _empresaController.text,
      "Descripcion": _descripcionAnuncioController.text,
      "Categoria": categoria,
      "Direccion": _direccion.text,
      "Ubicacion": miUbicacion.data,
      "total_valoraciones" : 0,
      "valoracion" : 0,
    };

    try {
      db.collection("anuncios").doc(uid).collection("anuncios").doc("$uid-$contador").update(_anuncio);

      isLoading = false;

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Anuncio publicado con éxito"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const My_ads()),
                          (route) => false);

                      currentIndex = 1;
                    },
                    child: const Center(child: Text("Ok")))
              ],
            );
          });
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Se ha producido un error"),
              content: const Text(
                  "Tu anuncio no se ha publicado correctamente, vuelva a intentarlo más tarde."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(("Ok")),
                )
              ],
            );
          });

      isLoading = false;
    }}
  }


  // Imagen principal que aparece en la portada del anuncio.
  void imagen_principal() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }



    try {
      File file = File(image.path);

      UploadTask uploadTask = _storage.ref("$uid/anuncio-$contador/imagen_anuncio").putFile(file);

      TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() => null);

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      db.collection("anuncios").doc(uid).collection("anuncios").doc("$uid-$contador").update({"imagen_principal": downloadUrl});
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const AlertDialog(
                title: Text("Error"),
                content: Text(
                    "Se ha producido un error al cargar la imágen. Inténtalo más tarde"),
              ));
    }
  }

  void imagen_1() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    File file = File(image.path);

    UploadTask uploadTask = _storage.ref("$uid/anuncio-$contador/imagen_1").putFile(file);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    db.collection("anuncios").doc(uid).collection("anuncios").doc("$uid-$contador").update({"imagen_1": downloadUrl});

    try {} catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const AlertDialog(
                title: Text("Error"),
                content: Text(
                    "Se ha producido un error al cargar la imágen. Inténtalo más tarde"),
              ));
    }
  }

  void imagen_2() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    File file = File(image.path);

    UploadTask uploadTask = _storage.ref("$uid/anuncio-$contador/imagen_2").putFile(file);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    db.collection("anuncios").doc(uid).collection("anuncios").doc("$uid-$contador").update({"imagen_2": downloadUrl});

    try {} catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const AlertDialog(
            title: Text("Error"),
            content: Text(
                "Se ha producido un error al cargar la imágen. Inténtalo más tarde"),
          ));
    }
  }

  void imagen_3() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    File file = File(image.path);

    UploadTask uploadTask = _storage.ref("$uid/anuncio-$contador/3").putFile(file);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    db.collection("anuncios").doc(uid).collection("anuncios").doc("$uid-$contador").update({"imagen_3": downloadUrl});

    try {} catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const AlertDialog(
            title: Text("Error"),
            content: Text(
                "Se ha producido un error al cargar la imágen. Inténtalo más tarde"),
          ));
    }
  }

  void imagen_4() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    File file = File(image.path);

    UploadTask uploadTask = _storage.ref("$uid/anuncio-$contador/imagen_4").putFile(file);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    db.collection("anuncios").doc(uid).collection("anuncios").doc("$uid-$contador").update({"imagen_4": downloadUrl});

    try {} catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const AlertDialog(
            title: Text("Error"),
            content: Text(
                "Se ha producido un error al cargar la imágen. Inténtalo más tarde"),
          ));
    }
  }

  void imagen_5() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    Navigator.pop(context);

    File file = File(image.path);

    UploadTask uploadTask = _storage.ref().putFile(file);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    db.collection("anuncios").doc(uid).update({"imagen_5": downloadUrl});

    try {} catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const AlertDialog(
            title: Text("Error"),
            content: Text(
                "Se ha producido un error al cargar la imágen. Inténtalo más tarde"),
          ));
    }
  }
}
