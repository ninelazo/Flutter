
// ignore_for_file: use_build_context_synchronously

import "dart:io";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:servicio/features/user_auth/presentation/pages/my_account.dart";
import "package:servicio/features/user_auth/widgets/bottomBar_widget.dart";
import 'package:image_picker/image_picker.dart';



/// EN ESTA PAGINA SE PUEDEN ACTUALIZAR LOS DATOS DEL USUARIO.
/// SE PUEDE ACCEDER A ELLA DESDE LA APLICACION ENTRANDO A MENU -> EDITAR PERFIL.


final uid = FirebaseAuth.instance.currentUser?.uid;
final FirebaseStorage _storage = FirebaseStorage.instance;
bool _isLoading = false;


class EditProfile extends StatefulWidget {
  EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {


  TextEditingController _nombreController = TextEditingController();
  TextEditingController _apellidosController = TextEditingController();
  TextEditingController _empresaController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();
  TextEditingController _telefono2Controller = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text("Editar información personal"),
          centerTitle: true,
        ),
        bottomNavigationBar: const BottomBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
                children: [
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("usuarios")
                          .doc(uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Column(
                            children: [
                              SizedBox(
                                height: 300,
                              ),
                              Center(child: SpinKitWaveSpinner(color: Colors.blue))
                            ],
                          );
                        } else if (snapshot.hasData) {
                          String nombre = snapshot.data!["nombre"];
                          String apellidos = snapshot.data!["apellidos"];
                          String empresa = snapshot.data!["empresa"];
                          String telefono1 = snapshot.data!["telefono1"];
                          String telefono2 = snapshot.data!["telefono2"];
                          String perfil = snapshot.data!["urlPerfil"];


                          _nombreController.text = nombre;
                          _apellidosController.text = apellidos;
                          _empresaController.text = empresa;
                          _telefonoController.text = telefono1;
                          _telefono2Controller.text = telefono2;



                          return Column(
                            children: [
                              Center(
                                child: GestureDetector(
                                    child: CircleAvatar(
                                      radius: 48,
                                      backgroundColor: Colors.green,
                                      child: Container(child: _isLoading ? const SpinKitWaveSpinner(color: Colors.black):CircleAvatar(
                                        radius: 45,
                                        foregroundImage: NetworkImage(perfil),
                                        backgroundColor: Colors.white54,
                                        child: const SpinKitWaveSpinner(color: Colors.black),),
                                        ),
                                      ),
                                    onTap: () => showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            color: Colors.black87,
                                            height: 200,
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 20),
                                                GestureDetector(
                                                  onTap: () => cameraPhoto(),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        color: Colors.blue,
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: const Center(
                                                        child: Text(
                                                          "Abrir cámara",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w500),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () => galeryPhoto(),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        color: Colors.blue,
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: const Center(
                                                        child: Text(
                                                          "Cargar desde el dispositivo",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w500),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        })),
                              ),
                              const Text("Pulsa en la foto para editar"),
                              const SizedBox(height: 25),
                              TextFormField(
                                decoration: InputDecoration(
                                    label: const Text("Nombre"),
                                    hintText: nombre,
                                    icon: const Icon(Icons.person_2_rounded)
                                ),
                                controller: _nombreController,
                                maxLength: 20,
                                inputFormatters: [FilteringTextInputFormatter.allow(
                                  RegExp(r"[a-zA-Z]+|\s"),
                                )],
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                   label: const Text("Apellidos"),
                                    hintText: apellidos,
                                    icon: const Icon(Icons.supervised_user_circle)),
                                controller: _apellidosController,
                                maxLength: 20,
                                inputFormatters: [FilteringTextInputFormatter.allow(
                                  RegExp(r"[a-zA-Z]+|\s"),
                                )],
                              ),
                              TextFormField(
                                  decoration: InputDecoration(
                                      label: const Text("Nombre de la empresa"),
                                      hintText: empresa,
                                      icon: const Icon(Icons.business)),
                                  controller: _empresaController,
                                  maxLength: 20),
                              TextFormField(
                                decoration: InputDecoration(
                                    label: const Text("Telefono principal"),
                                    hintText: telefono1,
                                    icon: const Icon(Icons.phone_android_rounded)),
                                controller: _telefonoController,
                                maxLength: 15,
                                inputFormatters: [FilteringTextInputFormatter.allow(
                                  RegExp(r"[0-9]"),
                                )],
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    label: const Text("Telefono 2"),
                                    hintText: telefono2,
                                    icon: const Icon(Icons.phone)),
                                controller: _telefono2Controller,
                                maxLength: 15,
                                inputFormatters: [FilteringTextInputFormatter.allow(
                                  RegExp(r"[0-9]"),
                                )],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              GestureDetector(
                                onTap: updateProfile,
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Actualizar datos",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Cancelar",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                             ],
                          );
                        } else {
                          return const Column(
                            children: [
                              SizedBox(
                                height: 150,
                              ),
                              Center(
                                child: Text(
                                    "Se ha producido un error. Intentalo nuevamenta más tarde o reinicia la aplicación si el error persiste",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 22)),
                              ),

                            ],

                          );
                        }
                      }),
                ],
              ),
            ),
          ),
    );
  }

  String? uid = FirebaseAuth.instance.currentUser?.uid;

  // Con esta funcion actualizamos los datos de nuestro perfil en la BBDD
  Future<void> updateProfile() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    var _perfil = <String, dynamic>{
      "nombre": _nombreController.text,
      "apellidos": _apellidosController.text,
      "empresa": _empresaController.text,
      "telefono1": _telefonoController.text,
      "telefono2": _telefono2Controller.text,
    };

    db.collection("usuarios").doc(uid).update(_perfil);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => My_Account()),
        (route) => false);
  }


  // Con esta funcion cargamos la foto de perfil desde la galería y la atualizamos en la BBDD
  Future galeryPhoto () async {

    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    Navigator.pop(context);



    try {

      setState(() {
        _isLoading = true;
      });

      File file = File(image.path);

      UploadTask uploadTask = _storage.ref().child("$uid/profilePicture.jpg").putFile(file);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      FirebaseFirestore db = FirebaseFirestore.instance;

      db.collection("usuarios").doc(uid).update({"urlPerfil" : downloadURL});

      setState(() {
        _isLoading = false;
      });

    } on Exception catch (e) {
      showDialog(context: (context), builder: (BuildContext context){
        return AlertDialog(
          title: const Text("Error",
              style: TextStyle(height: 20)),
          content: const Text(
              "Se ha producido un error al cargar la foto. Intentalo nuevamente más tarde"),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(context).pop();
            },
                child: const Text("Ok"))
          ],);
      });
    }
  }


  // Con esta funcion hacemos una foto con la camara y actualizamos la foto de perfil en nuestra BBDD
  Future cameraPhoto () async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image == null) {
      return;
    }

    Navigator.pop(context);

    try {

      setState(() {
        _isLoading = true;
      });

      File file = File(image.path);

      UploadTask uploadTask = _storage.ref()
          .child("$uid/profilePicture.jpg")
          .putFile(file);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      FirebaseFirestore db = FirebaseFirestore.instance;

      db.collection("usuarios").doc(uid).update({"urlPerfil": downloadURL});

      setState(() {
        _isLoading = false;
      });

    } on Exception catch (e) {
      showDialog(context: (context), builder: (BuildContext context){
        return AlertDialog(
          title: const Text("Error",
              style: TextStyle(height: 20)),
          content: const Text(
              "Se ha producido un error al cargar la foto. Intentalo nuevamente más tarde"),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(context).pop();
              },
                child: const Text("Ok"))
          ],);
    });
    }


  }

}
