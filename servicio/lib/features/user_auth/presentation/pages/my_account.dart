import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servicio/features/user_auth/presentation/pages/edit_profile.dart';
import 'package:servicio/features/user_auth/presentation/pages/login_page.dart';
import 'package:servicio/features/user_auth/widgets/bottomBar_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



/// ESTA PAGINA MUESTRA LOS DATOS DEL USUARIO QUE HA INICIADO SESION.
/// ADEMÁS AQUI SE PUEDE CERRAR SESIÓN ASÍ COMO ACCEDER A LA PAGINA DE EDITAR PERFIL.



class My_Account extends StatefulWidget {
  const My_Account({super.key});

  @override
  State<My_Account> createState() => _My_AccountState();
}

class _My_AccountState extends State<My_Account> {
  final String? uid = FirebaseAuth.instance.currentUser?.uid;
  final String? email = FirebaseAuth.instance.currentUser?.email;
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Center(
        child: Text("Ajustes de cuenta"),
      )),
      body: SingleChildScrollView(
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
                    String apellido = snapshot.data!["apellidos"];
                    String telefono1 = snapshot.data!["telefono1"];
                    String telefono2 = snapshot.data!["telefono2"];
                    String empresa = snapshot.data!["empresa"];
                    String perfil = snapshot.data!["urlPerfil"];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Center(
                            child: CircleAvatar(
                              radius: 63,
                              backgroundColor: Colors.green,
                              child: CircleAvatar(
                                radius: 60,
                                foregroundImage: NetworkImage(perfil),
                                backgroundColor: Colors.white54,
                                child: const SpinKitWaveSpinner(color: Colors.black),
                              ),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Row(
                            children: [
                              const Icon(Icons.person_2_rounded),
                              Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: RichText(
                                    text: TextSpan(
                                        text: "Nombre: ",
                                        style: GoogleFonts.inter(
                                            textStyle: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600)),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: nombre,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.75)))
                                        ]),
                                  )),
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.black12,
                          thickness: 1,
                          height: 0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Row(
                            children: [
                              const Icon(Icons.supervised_user_circle),
                              Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: RichText(
                                    text: TextSpan(
                                        text: "Apellidos: ",
                                        style: GoogleFonts.inter(
                                            textStyle: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600)),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: apellido,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.75)))
                                        ]),
                                  )),
                            ],
                          ),
                        ),
                        const Divider(
                            color: Colors.black12, thickness: 1, height: 0),
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Row(
                            children: [
                              const Icon(Icons.email_outlined),
                              Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: RichText(
                                    text: TextSpan(
                                        text: "Email: ",
                                        style: GoogleFonts.inter(
                                            textStyle: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600)),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: email,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.75)))
                                        ]),
                                  )),
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.black12,
                          thickness: 1,
                          height: 0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Row(
                            children: [
                              const Icon(Icons.phone_android_rounded),
                              Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: RichText(
                                    text: TextSpan(
                                        text: "Telefono principal: ",
                                        style: GoogleFonts.inter(
                                            textStyle: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600)),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: telefono1,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.75)))
                                        ]),
                                  )),
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.black12,
                          thickness: 1,
                          height: 0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Row(
                            children: [
                              const Icon(Icons.phone),
                              Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: RichText(
                                    text: TextSpan(
                                        text: "Telefono 2: ",
                                        style: GoogleFonts.inter(
                                            textStyle: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600)),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: telefono2,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.75)))
                                        ]),
                                  )),
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.black12,
                          thickness: 1,
                          height: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Row(
                            children: [
                              const Icon(Icons.business),
                              Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: RichText(
                                    text: TextSpan(
                                        text: "Empresa: ",
                                        style: GoogleFonts.inter(
                                            textStyle: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600)),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: empresa,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.75)))
                                        ]),
                                  )),
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.black12,
                          thickness: 1,
                          height: 1,
                        ),
                      ],
                    );
                  } else {
                    return const Text(
                      "Error al cargar sus datos",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                    );
                  }
                }),
            const SizedBox(
              height: 35,
            ),
            TextButton(
                onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfile()))
                    },
                child: const Text(
                  "Editar perfil",
                  style: TextStyle(fontSize: 28, fontStyle: FontStyle.italic),
                )),
            const SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: () => {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                          (route) => false),
                      FirebaseAuth.instance.signOut(),
                    },
                child: const Text(
                  "  Cerrar sesión",
                  style: TextStyle(fontSize: 28, fontStyle: FontStyle.italic),
                ))
          ],
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
