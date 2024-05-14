// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:servicio/features/user_auth/presentation/pages/create_ad.dart';
import 'package:servicio/features/user_auth/presentation/pages/edit_ad.dart';
import 'package:servicio/features/user_auth/widgets/bottomBar_widget.dart';


/// ESTA PAGINA MUESTRA LOS ANUNCIOS CREADOS PREVIAMENTE POR EL USUARIO.
/// DESDE AQUI SE PUEDE ACCEDER A EDITAR, ELIMINAR O CREAR UN NUEVO ANUNCIO.
/// SI EL USUARIO NO HA CREADO PREVIAMENTE NINGUN ANUNCIO ESTÁ PAGINA ESTARÁ VACÍA.



FirebaseFirestore db = FirebaseFirestore.instance;
var uid = FirebaseAuth.instance.currentUser?.uid;
late var contador;
late String nombreAnuncio;
late var anuncioSelecionado;

class My_ads extends StatefulWidget {
  const My_ads({super.key});

  @override
  State<My_ads> createState() => _My_adsState();
}

class _My_adsState extends State<My_ads> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomBar(),
      appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Center(
            child: Text("Tus anuncios"),
          )),
      body: StreamBuilder<QuerySnapshot>(
          stream: db
              .collection("anuncios")
              .doc(uid)
              .collection("anuncios")
              .where("nombre_anuncio", isNotEqualTo: "")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: SpinKitWaveSpinner(color: Colors.teal));
            } else if (snapshot.hasData) {
              return Column(
                children: [
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(3),
                                color: const Color.fromRGBO(0, 0, 0, 0.07),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        leading: Image(
                                            width: 90,
                                            height: 110,
                                            image: NetworkImage(snapshot
                                                .data!.docs[index]
                                                .get("imagen_principal"))),

                                        title: Text(
                                          snapshot.data!.docs[index]
                                              .get("nombre_anuncio"),
                                        ),
                                        subtitle: Text(snapshot
                                            .data!.docs[index]
                                            .get("Direccion")),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () => showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Center(
                                            child: Text(
                                                "Desea editar o eliminar el anuncio '${snapshot.data!.docs[index].get("nombre_anuncio")}'"),
                                          ),
                                          actions: [
                                            Row(children: [
                                              Expanded(child: TextButton(onPressed: () {
                                                // Editamos anuncio seleccionado.
                                                contador = snapshot.data!.docs[index].id.split("-")[1];
                                                Navigator.of(context).pop();
                                                anuncioSelecionado = snapshot.data!.docs[index].id;
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => const Edit_Ad()));
                                              },
                                                child: const Text("Editar"),)),

                                              Expanded(child: TextButton(onPressed:() {
                                                // Eliminamos anuncio seleccionado.
                                                anuncioSelecionado = snapshot.data!.docs[index].id;
                                                db.collection("anuncios").doc(uid).collection("anuncios").doc(anuncioSelecionado).delete();
                                                Navigator.of(context).pop();
                                              },
                                                child: const Text("Eliminar"),))
                                            ]),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                  GestureDetector(
                    onTap: () => crear_anuncio(),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                        child: const Center(
                          child: Text(
                            "Craer nuevo anuncio",
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
              );
            } else {
              return const Text("Error");
            }
          }),
    );
  }


  // Esta función crea un nuevo anuncio en la BBDD con unos datos por defecto.
  //Posteriormente nos redirige a la pagina "create_add.dart"
  void crear_anuncio() async {

    await db.collection("anuncios").doc(uid).get().then((DocumentSnapshot doc) {
      var data = doc.data() as Map<String, dynamic>;
      contador = data["anuncios"];
    });

    print(contador);

    try {
      await db
          .collection("anuncios")
          .doc(uid)
          .collection("anuncios")
          .doc("$uid-$contador")
          .get()
          .then((DocumentSnapshot doc) {
        var data = doc.data() as Map<String, dynamic>;

        nombreAnuncio = data["nombre_anuncio"];
        print(nombreAnuncio);
      });} catch (e) {
        nombreAnuncio = "";
      }

    if (nombreAnuncio.isNotEmpty) {
      try {
        var nuevoAnuncio = {
          "nombre_anuncio": "",
          "imagen_principal":
              "https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Google_Camera_Icon_%28November_2014-2017%29.svg/2048px-Google_Camera_Icon_%28November_2014-2017%29.svg.png",
          "imagen_1":
              "https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Google_Camera_Icon_%28November_2014-2017%29.svg/2048px-Google_Camera_Icon_%28November_2014-2017%29.svg.png",
          "imagen_2":
              "https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Google_Camera_Icon_%28November_2014-2017%29.svg/2048px-Google_Camera_Icon_%28November_2014-2017%29.svg.png",
          "imagen_3":
              "https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Google_Camera_Icon_%28November_2014-2017%29.svg/2048px-Google_Camera_Icon_%28November_2014-2017%29.svg.png",
          "imagen_4":
              "https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Google_Camera_Icon_%28November_2014-2017%29.svg/2048px-Google_Camera_Icon_%28November_2014-2017%29.svg.png",
          "valoracion" : 0.0,
          "total_valoraciones" : 0.0,
        };


        contador = contador + 1;

        print(contador);


        await db.collection("anuncios").doc(uid).set({"anuncios": contador});

        await db
            .collection("anuncios")
            .doc(uid)
            .collection("anuncios")
            .doc("$uid-$contador")
            .set(nuevoAnuncio);

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Create_Ad()));
      } catch (e) {
        showDialog(
            context: context,
            builder: (BuildContext context) => const AlertDialog(
                  title: Text("Error"),
                  content: Text(
                      "Se ha producido un error al tratar de crear un nuevo anuncio. Inténtalo más tarde"),
                ));
      }
    } else if (nombreAnuncio == "") {
      try {
        var nuevoAnuncio = {
          "nombre_anuncio": "",
          "imagen_principal":
          "https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Google_Camera_Icon_%28November_2014-2017%29.svg/2048px-Google_Camera_Icon_%28November_2014-2017%29.svg.png",
          "imagen_1":
          "https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Google_Camera_Icon_%28November_2014-2017%29.svg/2048px-Google_Camera_Icon_%28November_2014-2017%29.svg.png",
          "imagen_2":
          "https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Google_Camera_Icon_%28November_2014-2017%29.svg/2048px-Google_Camera_Icon_%28November_2014-2017%29.svg.png",
          "imagen_3":
          "https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Google_Camera_Icon_%28November_2014-2017%29.svg/2048px-Google_Camera_Icon_%28November_2014-2017%29.svg.png",
          "imagen_4":
          "https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Google_Camera_Icon_%28November_2014-2017%29.svg/2048px-Google_Camera_Icon_%28November_2014-2017%29.svg.png",
        };

        await db
            .collection("anuncios")
            .doc(uid)
            .collection("anuncios")
            .doc("$uid-$contador")
            .set(nuevoAnuncio);

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Create_Ad()));
      } catch (e) {
        showDialog(
            context: context,
            builder: (BuildContext context) =>
            const AlertDialog(
              title: Text("Error"),
              content: Text(
                  "Se ha producido un error al tratar de crear un nuevo anuncio. Inténtalo más tarde"),
            ));
      }
    }else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Create_Ad()));
    }
  }
}
