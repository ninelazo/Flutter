

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:servicio/features/user_auth/presentation/pages/search_page.dart';
import 'package:servicio/features/user_auth/presentation/pages/show_ad.dart';
import 'package:servicio/features/user_auth/widgets/bottomBar_widget.dart';



/// ESTA PAGINA ES LA PAGINA QUE SE MUESTRA TRAS REALIZAR EL FILTRADO Y BUSQUEDA DE ANUNCIO.
/// AQUI SE MOSTRARÁ LOS ANUNCIOS BUSCADOS POR EL USUARIO.


final String? uid = FirebaseAuth.instance.currentUser?.uid;
final db = FirebaseFirestore.instance;

late var idAnuncio;
late var idUsuario;
late double valoracion;
late double valoraciones;
late double distance;




bool _isLoading = true;

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    GeoFirePoint center = geo.point(latitude: Lat, longitude: Lon);
    String field = "Ubicacion";
    var filter = db.collectionGroup("anuncios").where("Categoria", isEqualTo: categoria);
    var geoRef = geo.collection(collectionRef:filter).within(center: center, radius: radius, field: field);


    return Scaffold(
      bottomNavigationBar: const BottomBar(),
      appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Center(
            child: Text("Página de inicio"),
          )),
      body: SingleChildScrollView(
          child: StreamBuilder<List<DocumentSnapshot>>(
            stream: geoRef.asBroadcastStream(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                    height: 250,
                    child: Center(child: SpinKitWaveSpinner(color: Colors.teal)));
              }
              if(snapshot.hasData){

              return Column(
                children: [
                  const SizedBox(height: 10,),
                  ListView.builder(
                      itemCount: snapshot.data!.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index){

                        double estrellas = snapshot.data![index]["valoracion"].toDouble();
                        String distancia = center.distance(lat: snapshot.data![index]["Ubicacion.geopoint"].latitude, lng: snapshot.data![index]["Ubicacion.geopoint"].longitude).toStringAsFixed(1);
                        
                        if (double.parse(distancia) <= radius) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            onTap: () {
                              idAnuncio = snapshot.data![index].id;
                              idUsuario = idAnuncio.split("-")[0];
                              valoracion = estrellas;
                              valoraciones = snapshot.data![index]["total_valoraciones"].toDouble();
                              distance = center.distance(lat: snapshot.data![index]["Ubicacion.geopoint"].latitude, lng: snapshot.data![index]["Ubicacion.geopoint"].longitude);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const ShowAd()));
                            },
                            child: Container(
                              color: const Color.fromRGBO(0, 0, 0, 0.07),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 7),
                                    child: Image(image: NetworkImage(snapshot.data![index]["imagen_principal"]),height: 125,width: 90,loadingBuilder: (BuildContext context, Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null){
                                        return child;
                                      }
                                      return const SpinKitWaveSpinner(color: Colors.teal);
                                    },),
                                  ),
                                  Expanded(child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(children: [
                                      AspectRatio(aspectRatio: 8/1,
                                        child: Container(
                                          margin: const EdgeInsets.only(bottom: 10,),
                                            color: Color.fromRGBO(0, 150, 136, 0.8),
                                            child: Center(child: Text(snapshot.data![index]["nombre_anuncio"], style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500, letterSpacing: 0.5),))),
                                      ),
                                      Text(snapshot.data![index]["Descripcion"] + "...",maxLines: 3),
                                      const SizedBox(height: 15,),
                                      Container(
                                        color: const Color.fromRGBO(
                                            0, 0, 0, .1),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Row(
                                            children: [
                                              Expanded(child: Text("${distancia} Km", style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 18,fontWeight: FontWeight.w500),)),
                                              RatingBar(
                                                initialRating: estrellas,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 18,
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
                                            ],
                                          ),
                                        ),
                                      )
                                    ],),
                                  )),

                                ],
                              ),
                            ),
                          ),
                        );}
                        }

                  )
                ],
      );
            } else if (snapshot.hasError){
                print(snapshot.error);
                return Text("${snapshot.error}");
              } else  {
                ;
                return Text("Hola");
              }
            }
          )),
    );
  }

  // Esta funcion filtra y muestra los anuncios que el usuario está interesado en ver.
  Future<void> documentos() async {

    await db.collection("anuncios").get().then(((querySnaphot) {
      for(var docSnaphot in querySnaphot.docs) {
        db.collection("anuncios").doc(docSnaphot.id).collection("anuncios").where("Categoria", isNotEqualTo: "Fontanería").get().then((querySnaphot_1) {
          for (var docSnapshot_1 in querySnaphot_1.docs) {
            print(docSnapshot_1["imagen_principal"]);
          }
        });
      }
    }));
  }

}
