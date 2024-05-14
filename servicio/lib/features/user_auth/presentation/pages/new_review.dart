import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:servicio/features/user_auth/presentation/pages/home_page.dart';
import 'package:servicio/features/user_auth/presentation/pages/show_ad.dart';
import 'package:servicio/features/user_auth/widgets/bottomBar_widget.dart';



/// ESTA PAGINA CREA UNA NUEVA RESEÑA.



late String nombre;
late String apellidos;
late String imagen;
late double nota;

class Create_review extends StatefulWidget {
  const Create_review({super.key});

  @override
  State<Create_review> createState() => _Create_reviewState();
}

class _Create_reviewState extends State<Create_review> {
  TextEditingController _descripcionReview = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomBar(),
      appBar: AppBar(
          title: const Text("Nueva valoración"), backgroundColor: Colors.teal),
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
            stream: db.collection("usuarios").doc(uid).snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SpinKitWaveSpinner(color: Colors.teal);
              } else if (snapshot.hasData) {
                nombre = snapshot.data!["nombre"];
                apellidos = snapshot.data!["apellidos"];
                imagen = snapshot.data!["urlPerfil"];

                return Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircleAvatar(
                          radius: 48,
                          backgroundColor: Colors.green,
                          child: CircleAvatar(
                            radius: 45,
                            foregroundImage: NetworkImage(imagen),
                            backgroundColor: Colors.white54,
                            child:
                                const SpinKitWaveSpinner(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "$nombre $apellidos",
                      style: const TextStyle(fontSize: 25),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    RatingBar(
                      initialRating: 3,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 50,
                      glow: true,
                      glowColor: Colors.red,
                      ratingWidget: RatingWidget(
                        full: const Icon(
                          Icons.star,
                          color: Colors.blue,
                        ),
                        half: const Icon(Icons.star_half, color: Colors.blue),
                        empty: const Icon(Icons.star_border),
                      ),
                      onRatingUpdate: (rating) {
                        nota = rating;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          decoration: const InputDecoration(
                              hintText:
                                  "Describa con detalle su opinión (Puede incluir detalles sobre precio, rapidez del servicio, calidad del servicio...)",
                              border: OutlineInputBorder()),
                          controller: _descripcionReview,
                          maxLength: 1000,
                          minLines: 5,
                          maxLines: 10),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: () {
                        publicar_valoracion();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              "Publicar valoración",
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
              }
              return const Center(
                child: Text("Error"),
              );
            }),
      ),
    );
  }


  // Funcion que crea en la BBDD una nueva reseña.
  // Tambien actualiza los datos de reseñas totales y media de valoracion del anuncio.
  Future<void> publicar_valoracion() async {
    valoraciones += 1;
    valoracion = ((valoracion + nota) / valoracion);

    db
        .collection("anuncios")
        .doc(idUsuario)
        .collection("anuncios")
        .doc(idAnuncio)
        .update({
      "total_valoraciones": valoraciones,
      "valoracion": valoracion,
    });

    db
        .collection("anuncios")
        .doc(idUsuario)
        .collection("anuncios")
        .doc(idAnuncio)
        .collection("valoraciones")
        .doc(uid)
        .set({
      "nombre": "$nombre $apellidos",
      "imagen": imagen,
      "comentario": _descripcionReview.text,
      "nota": nota,
    });

    Navigator.pop(context);
  }
}
