import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:servicio/features/user_auth/presentation/pages/home_page.dart';
import 'package:servicio/features/user_auth/presentation/pages/new_review.dart';
import 'package:servicio/features/user_auth/widgets/bottomBar_widget.dart';



/// ESTA PAGINA MUESTRA LAS RESEÑAS DEL ANUNCIO SELECCIONADO
/// DESDE AQUI SE PUEDE ACCEDER A LA PAGINA DE CREAR UNA NUEVA RESEÑA.



class Review_page extends StatefulWidget {
  const Review_page({super.key});

  @override
  State<Review_page> createState() => _Review_pageState();
}

class _Review_pageState extends State<Review_page> {

  List id = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 0.9),
      bottomNavigationBar: const BottomBar(),
      appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Center(child: Text("Valoraciones"))),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
            stream: db
                .collection("anuncios")
                .doc(idUsuario)
                .collection("anuncios")
                .doc(idAnuncio)
                .collection("valoraciones")
                .snapshots(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: SizedBox(
                        height: 300,
                        child: SpinKitWaveSpinner(color: Colors.teal)));
              } else if (snapshot.hasData) {

                return Column(
                  children: [
                    const SizedBox(height: 10,),
                    ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {

                          double valoracion = (snapshot.data!.docs[index].get("nota")).toDouble();
                          id.add(snapshot.data!.docs[index].id);

                          return Column(
                            children: [
                              Container(
                                color: Colors.white,
                                child: ListTile(leading: CircleAvatar(backgroundImage: NetworkImage(snapshot.data!.docs[index].get("imagen")),),
                                  title: Text(snapshot.data!.docs[index].get("nombre")),
                                  subtitle: Text(snapshot.data!.docs[index].get("comentario")),
                                  trailing: RatingBar(
                                    initialRating: valoracion,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 15,
                                    glow: true,
                                    glowColor: Colors.red,
                                    ignoreGestures: true,
                                    ratingWidget: RatingWidget(
                                      full: const Icon(Icons.star, color: Colors.blue,),
                                      half: const Icon(Icons.star_half, color: Colors.blue),
                                      empty: const Icon(Icons.star_border),
                                    ),
                                    onRatingUpdate: (rating) {
                                      null;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10,),
                            ],
                          );
                        }),
                    GestureDetector(
                      onTap: () {
                        if (id.contains(uid)) {
                          showDialog(context: context, builder: (context) {
                            return AlertDialog(title: Text("Ya has publicado una reseña en este anuncio"),
                              content: Text("Solo se puede publicar una reseña por anuncio."),
                              actions: [
                                TextButton(onPressed: () {
                                  Navigator.of(context).pop();
                                }, child: Text("Volver"))
                              ],);
                          },);
                        } else {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (
                                  context) => const Create_review()));
                        }
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
                              "Publicar tu valoración",
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
              return const Text("Error");
            }),
      ),
    );
  }

}
