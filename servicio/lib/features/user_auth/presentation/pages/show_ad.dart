
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:servicio/features/user_auth/presentation/pages/home_page.dart';
import 'package:servicio/features/user_auth/presentation/pages/new_review.dart';
import 'package:servicio/features/user_auth/presentation/pages/reviews.dart';
import 'package:servicio/features/user_auth/presentation/pages/search_page.dart';
import 'package:servicio/features/user_auth/widgets/bottomBar_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';




/// ESTA PAGINA MUESTRA UN ANUNCIO PREVIAMENTE SELECCIONADO DESDE LA PAGINA DE ANUNCIOS.
/// AQUI PODRÁS VER TODOS LOS DATOS DEL ANUNCIO ASÍ COMO PODER CONTACTAR CON EL ANUNCIANTE.
/// ADEMÁS DESDE AQUI PUEDES ACCEDER A LAS RESEÑAS DEL ANUNCIO ASI COMO CREAR UNA NUEVA.



List<String> imagenes = [];
late String telefono1;
String telefono2 = "";
late String email;




class ShowAd extends StatefulWidget {
  const ShowAd({super.key});

  @override
  State<ShowAd> createState() => _ShowAdState();
}

class _ShowAdState extends State<ShowAd> {



  @override
  Widget build(BuildContext context) {

    bool llamar2 = true;

    if (telefono2 != "") {
      llamar2 = false;
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Center(
                      child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(telefono1, style: const TextStyle(letterSpacing: 0.8),)),
                          ElevatedButton(
                              onPressed: () {

                                  final Uri launchUri = Uri(
                                    scheme: 'tel',
                                    path: telefono1,
                                  );
                                  launchUrl(launchUri);


                          }, child: const Text("Llamar"))
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      llamar2 ? const SizedBox(height: 0,) : Row(
                        children: [
                          Expanded(child: Text(telefono2)),
                          ElevatedButton(onPressed: () {
                            final Uri launchUri = Uri(
                              scheme: 'tel',
                              path: telefono2,
                            );
                            launchUrl(launchUri);
                          }
                          , child: const Text("Llamar"))
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextButton(onPressed: () {
                        Uri uri = Uri.parse("mailto:$email");
                        launchUrl(uri);
                      }, child: Text(email, style: const TextStyle(fontSize: 20 ,color: Colors.blue),))
                    ],
                  )),
                  actions: [
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Volver"))
                  ],
                ),
              ),
          isExtended: true,
          backgroundColor: Colors.teal,
          child: const Icon(Icons.phone)),
      bottomNavigationBar: const BottomBar(),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(categoria, style: const TextStyle(letterSpacing: 2, fontSize: 22)),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
            stream: db
                .collection("anuncios")
                .doc(idUsuario)
                .collection("anuncios")
                .doc(idAnuncio)
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SpinKitWaveSpinner(color: Colors.teal),
                );
              } else if (snapshot.hasData) {

                String empresa = snapshot.data!["Empresa"];
                if (empresa != "") {
                  empresa = ("Empresa: $empresa");
                }

                telefono1 = (snapshot.data!["Telefono1"]);
                telefono2 = (snapshot.data!["Telefono2"]);
                email = (snapshot.data!["email"]);

                imagenes = [];

                if (snapshot.data!["imagen_principal"] !=
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Google_Camera_Icon_%28November_2014-2017%29.svg/2048px-Google_Camera_Icon_%28November_2014-2017%29.svg.png") {
                  imagenes.add(snapshot.data!["imagen_principal"]);
                }
                for (int i = 1; i < 5; i++) {
                  if (snapshot.data!["imagen_$i"] !=
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Google_Camera_Icon_%28November_2014-2017%29.svg/2048px-Google_Camera_Icon_%28November_2014-2017%29.svg.png") {
                    imagenes.add(snapshot.data!["imagen_$i"]);
                  }
                }

                List<Widget> imageSliders = imagenes
                    .map((item) => Container(
                  child: Container(
                    margin: const EdgeInsets.all(5.0),
                    child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                        child: Stack(
                          children: <Widget>[
                            Image.network(item, fit: BoxFit.cover, width: 1000.0),
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(200, 0, 0, 0),
                                      Color.fromARGB(0, 0, 0, 0)
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                child: Text(
                                  'No. ${imagenes.indexOf(item) + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ))
                    .toList();

                return Container(
                  color: const Color.fromRGBO(0, 0, 0, 0.05),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        CarouselSlider(
                          options: CarouselOptions(
                            aspectRatio: 2.0,
                            scrollDirection: Axis.horizontal,
                            enlargeCenterPage: true,
                            autoPlay: false,
                            height: 350
                          ),
                          items: imageSliders
                        ),
                        const SizedBox(height: 15,),
                        StreamBuilder<DocumentSnapshot>(
                          stream: db.collection("usuarios").doc(idUsuario).snapshots(),
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.hasData) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("${snapshot.data!.get("nombre")} ${snapshot.data!.get("apellidos")}",
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 1),),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10, right: 9),
                                    child: CircleAvatar(
                                      radius: 23,
                                      backgroundColor: Colors.teal,
                                      child: CircleAvatar(
                                        radius: 20,
                                        foregroundImage: NetworkImage(snapshot.data!.get("urlPerfil")),
                                        backgroundColor: Colors.white54,
                                        child: const SpinKitWaveSpinner(color: Colors.black),
                                      ),
                                    ),
                                  ),

                                ],
                              );
                            }
                            return const Text("Error");
                          }
                        ),
                        const SizedBox(height: 15,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                            child: Text(
                              snapshot.data!["nombre_anuncio"],
                              style: const TextStyle(
                                  fontSize: 34, fontWeight: FontWeight.w600,
                                  color: Colors.teal),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(end: 5),
                          child: Container(alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                MapsLauncher.launchQuery(snapshot.data!["Direccion"]);
                              },
                              child: Container(
                                decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 2, color: Colors.blue)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                  snapshot.data!["Direccion"],
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w600, color: Color.fromRGBO(0, 100, 255, 0.7))),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsetsDirectional.only(end: 12),
                          child: Text("Se encuentra a ${distance.toStringAsFixed(1)} km")),
                        const SizedBox(height: 30,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(7),border: Border.all(color: Colors.black)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                snapshot.data!["Descripcion"],
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            empresa,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Review_page()));
                            },
                            child: Text(
                                "Ver valoraciones (${valoraciones.toInt()})", style: const TextStyle(fontSize: 20),))
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: Text("Error"),
                );
              }
            }),
      ),
    );
  }
}
