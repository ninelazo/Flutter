import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:servicio/features/user_auth/presentation/pages/home_page.dart';
import 'package:servicio/features/user_auth/widgets/bottomBar_widget.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

/// ESTA PAGINA ES LA PRIMERA PAGINA QUE SE MUESTRA AL USUARIO TRAS INICIAR SESION.
/// DESDE AQUI SE REALIZA LA BUSQUEDA DE ANUNCIOS COMPLETANDO LOS CAMPOS SOLICITADOS (Categoría, dirección, distancia máxima)

final geo = GeoFlutterFire();

late double Lat;
late double Lon;
late var Ubicacion;
String categoria = "";
RangeValues rango_distancia = const RangeValues(0, 300);
double radius = 100;

bool isLoading = false;

// Variables que al seleccionar una categoria, cambia de color el boton para indicar que categoria esta seleccionada
bool abogado = false;
bool arquitecto = false;
bool cerrajero = false;
bool decorador_interiores = false;
bool mecanico = false;
bool transportista = false;
bool limpieza = false;
bool programador = false;
bool diseno_grafico = false;
bool profesor = false;
bool asesor = false;
bool asesor_inmobiliario = false;
bool reparacion_ordenadores = false;
bool reparacion_moviles = false;
bool reparacion_electrodomesticos = false;

void default_color() {
  abogado = false;
  arquitecto = false;
  cerrajero = false;
  decorador_interiores = false;
  mecanico = false;
  transportista = false;
  limpieza = false;
  programador = false;
  diseno_grafico = false;
  profesor = false;
  asesor = false;
  asesor_inmobiliario = false;
  reparacion_ordenadores = false;
  reparacion_moviles = false;
  reparacion_electrodomesticos = false;
}

class Search_page extends StatefulWidget {
  const Search_page({super.key});

  @override
  State<Search_page> createState() => _Search_pageState();
}

class _Search_pageState extends State<Search_page> {
  TextEditingController _direccion = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(230, 255, 255, 255),
      bottomNavigationBar: const BottomBar(),
      appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Center(
            child: Text("Buscar anuncio"),
          )),
      body: isLoading
          ? const SpinKitWaveSpinner(color: Colors.teal)
          : SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder<DocumentSnapshot>(
                      stream: db.collection("usuarios").doc(uid).snapshots(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.hasData) {
                          String nombre = snapshot.data!["nombre"];
                          isLoading = false;

                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                const Text(
                                  "Bienvenid@",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 32),
                                ),
                                Text(
                                  "$nombre!",
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 32),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(30.0),
                                  child: Center(
                                      widthFactor: BorderSide.strokeAlignCenter,
                                      child: Text(
                                        "Para buscar anuncios seleccione una categoría y su ubicación.",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontStyle: FontStyle.italic),
                                      )),
                                ),
                                Container(
                                  height: 120,
                                  child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            default_color();

                                            setState(() {
                                              categoria = "Abogado";
                                              abogado = true;
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(5),
                                            height: 110,
                                            width: 140,
                                            decoration: BoxDecoration(
                                                color: abogado
                                                    ? Colors.teal
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: abogado ? Border.all(color: Colors.black,width: 3): const Border.symmetric()),
                                            child: const Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Icon(
                                                    Octicons.law,
                                                    size: 40,
                                                  ),
                                                ),
                                                Text("Abogado",
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            default_color();

                                            setState(() {
                                              categoria = "Arquitecto";
                                              arquitecto = true;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: arquitecto
                                                    ? Colors.teal
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                    border: arquitecto ? Border.all(color: Colors.black,width: 3): const Border.symmetric()),
                                            margin: const EdgeInsets.all(5),
                                            height: 110,
                                            width: 140,
                                            child: const Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Icon(
                                                    FontAwesome5.pencil_ruler,
                                                    size: 40,
                                                  ),
                                                ),
                                                Text("Arquitecto",
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            default_color();

                                            setState(() {
                                              categoria = "Cerrajero";
                                              cerrajero = true;
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(5),
                                            height: 110,
                                            width: 140,
                                            decoration: BoxDecoration(
                                                color: cerrajero ? Colors.teal:Colors.white,
                                                borderRadius: BorderRadius.circular(5),
                                                border: cerrajero ? Border.all(color: Colors.black,width: 3): const Border.symmetric()),
                                            child: const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Icon(
                                                    Linecons.key,
                                                    size: 40,
                                                  ),
                                                ),
                                                Text("Cerrajero",
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {

                                            default_color();

                                            setState(() {
                                              categoria = "Decorador interiores";
                                              decorador_interiores = true;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: decorador_interiores ?  Colors.teal : Colors.white,
                                                borderRadius: BorderRadius.circular(5), border: decorador_interiores ? Border.all(color: Colors.black,width: 3): const Border.symmetric()),
                                            margin: const EdgeInsets.all(5),
                                            height: 110,
                                            width: 140,
                                            child: const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Icon(
                                                    Icons.chair_rounded,
                                                    size: 40,
                                                  ),
                                                ),
                                                Text("Decorador",
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                                Text(
                                                  "interiores",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {

                                            default_color();

                                            setState(() {
                                              categoria = "Mecanico";
                                              mecanico = true;
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(5),
                                            height: 110,
                                            width: 140,
                                            decoration: BoxDecoration(
                                                color: mecanico ? Colors.teal:Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                    border: mecanico ? Border.all(color: Colors.black,width: 3): const Border.symmetric()),
                                            child: const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Icon(
                                                    FontAwesome5.car_crash,
                                                    size: 40,
                                                  ),
                                                ),
                                                Text("Mecánico",
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {

                                            default_color();

                                            setState(() {
                                              categoria = "Transportista";
                                              transportista = true;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: transportista ? Colors.teal:Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                    border: transportista ? Border.all(color: Colors.black,width: 3): const Border.symmetric()),
                                            margin: const EdgeInsets.all(5),
                                            height: 110,
                                            width: 140,
                                            child: const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Icon(
                                                    Icons.fire_truck,
                                                    size: 40,
                                                  ),
                                                ),
                                                Text("Transportista",
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {

                                            default_color();

                                            setState(() {
                                              categoria = "Limpieza";
                                              limpieza = true;
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(5),
                                            height: 110,
                                            width: 140,
                                            decoration: BoxDecoration(
                                                color: limpieza ? Colors.teal:Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                    border: limpieza ? Border.all(color: Colors.black,width: 3): const Border.symmetric()),
                                            child: const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Icon(
                                                    Icons.cleaning_services,
                                                    size: 40,
                                                  ),
                                                ),
                                                Text("Limpieza",
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {

                                            default_color();

                                            setState(() {
                                              categoria = "Programador";
                                              programador = true;
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(5),
                                            height: 110,
                                            width: 140,
                                            decoration: BoxDecoration(
                                                color: programador ? Colors.teal:Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                    border: programador ? Border.all(color: Colors.black,width: 3): const Border.symmetric()),
                                            child: const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Icon(
                                                    FontAwesome5.laptop_code,
                                                    size: 40,
                                                  ),
                                                ),
                                                Text("Programador",
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {

                                            default_color();

                                            setState(() {
                                              categoria = "Diseño grafico";
                                              diseno_grafico = true;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: diseno_grafico ? Colors.teal:Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                    border: diseno_grafico ? Border.all(color: Colors.black,width: 3): const Border.symmetric()),
                                            margin: const EdgeInsets.all(5),
                                            height: 110,
                                            width: 140,
                                            child: const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Icon(
                                                    Icons.design_services,
                                                    size: 40,
                                                  ),
                                                ),
                                                Text("Diseño",
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                                Text(
                                                  "gráfico",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {

                                            default_color();

                                            setState(() {
                                              categoria = "Profesor";
                                              profesor = true;
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(5),
                                            height: 110,
                                            width: 140,
                                            decoration: BoxDecoration(
                                                color: profesor ? Colors.teal:Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                    border: profesor ? Border.all(color: Colors.black,width: 3): const Border.symmetric()),
                                            child: const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Icon(
                                                    FontAwesome5
                                                        .chalkboard_teacher,
                                                    size: 40,
                                                  ),
                                                ),
                                                Text("Profesor",
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {

                                            default_color();

                                            setState(() {
                                              categoria = "Asesor";
                                              asesor = true;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: asesor ? Colors.teal:Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                    border: asesor ? Border.all(color: Colors.black,width: 3): const Border.symmetric()),
                                            margin: const EdgeInsets.all(5),
                                            height: 110,
                                            width: 140,
                                            child: const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Icon(
                                                    Entypo.book,
                                                    size: 40,
                                                  ),
                                                ),
                                                Text("Asesor",
                                                    style: TextStyle(
                                                        fontSize: 18)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {

                                            default_color();

                                            setState(() {
                                              categoria = "Asesor inmobiliario";
                                              asesor_inmobiliario = true;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: asesor_inmobiliario ? Colors.teal:Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                    border: asesor_inmobiliario ? Border.all(color: Colors.black,width: 3): const Border.symmetric()),
                                            margin: const EdgeInsets.all(5),
                                            height: 110,
                                            width: 140,
                                            child: const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Icon(
                                                    FontAwesome5.building,
                                                    size: 40,
                                                  ),
                                                ),
                                                Text("Asesor",
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                                Text("inmobiliario",
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {

                                            default_color();

                                            setState(() {
                                              categoria ="Reparacion ordenadores";
                                              reparacion_ordenadores = true;
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(5),
                                            height: 110,
                                            width: 140,
                                            decoration: BoxDecoration(
                                                color: reparacion_ordenadores ? Colors.teal:Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                    border: reparacion_ordenadores ? Border.all(color: Colors.black,width: 3): const Border.symmetric()),
                                            child: const Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Icon(
                                                    Icons.laptop_chromebook,
                                                    size: 40,
                                                  ),
                                                ),
                                                Text("Reparación",
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                                Text(
                                                  "ordenadores",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {

                                            default_color();

                                            setState(() {
                                              categoria = "Reparacion moviles";
                                              reparacion_moviles = true;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: reparacion_moviles ? Colors.teal:Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                    border: reparacion_moviles ? Border.all(color: Colors.black,width: 3): const Border.symmetric()),
                                            margin: const EdgeInsets.all(5),
                                            height: 110,
                                            width: 140,
                                            child: const Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Icon(
                                                    Icons.smartphone,
                                                    size: 40,
                                                  ),
                                                ),
                                                Text("Reparación",
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                                Text("móviles",
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {

                                            default_color();

                                            setState(() {
                                              categoria = "Reparacion electrodomesticos";
                                              reparacion_electrodomesticos = true;
                                            });
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(5),
                                            height: 110,
                                            width: 140,
                                            decoration: BoxDecoration(
                                                color: reparacion_electrodomesticos ? Colors.teal:Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                    border: reparacion_electrodomesticos ? Border.all(color: Colors.black,width: 3): const Border.symmetric()),
                                            child: const Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Icon(
                                                    Icons.microwave_outlined,
                                                    size: 40,
                                                  ),
                                                ),
                                                Text("Reparación",
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                                Text(
                                                  "electrodomésticos",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ]),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  color: const Color.fromRGBO(255, 255, 255, 1),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GooglePlaceAutoCompleteTextField(
                                      textEditingController: _direccion,
                                      googleAPIKey:
                                          "AIzaSyB_T-_oOzeMzp5b3COOWIs9_K08bGxayO0",
                                      inputDecoration: const InputDecoration(
                                          hintText: "Tu dirección",
                                          icon: Icon(Icons.pin_drop)),
                                      isLatLngRequired: true,
                                      getPlaceDetailWithLatLng:
                                          (Prediction prediction) {
                                        Lat = double.parse(prediction.lat!);
                                        Lon = double.parse(prediction.lng!);
                                        GeoFirePoint Ubicacion = geo.point(
                                            latitude: Lat, longitude: Lon);
                                      },
                                      itemClick: (Prediction prediction) {
                                        _direccion.text =
                                            prediction.description!;
                                      },
                                      boxDecoration: const BoxDecoration(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          isLoading = false;

                          return Container(
                            margin: const EdgeInsetsDirectional.all(
                                BorderSide.strokeAlignCenter),
                            child: const Column(
                              children: [
                                Text("Se ha producido un error."),
                                Text("Intentelo nuevamente más tarde.")
                              ],
                            ),
                          );
                        } else {
                          isLoading = true;

                          return Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: BorderSide.strokeAlignCenter),
                              child:
                                  const SpinKitWaveSpinner(color: Colors.teal));
                        }
                      }),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black45),
                        borderRadius: const BorderRadius.all(Radius.circular(10))),
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                            "Seleccione la distancia máxima para mostrar anuncios."),
                        Slider(
                          min: 0.0,
                          max: 300.0,
                          value: radius,
                          divisions: 300,
                          activeColor: Colors.teal,
                          onChanged: (value) {
                            setState(() {
                              radius = value;
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text("${radius.toStringAsFixed(1)} Km",
                              style: const TextStyle(fontSize: 20)),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (categoria == "") {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const Text(
                                    "Debe seleccionar una categoría"),
                                actions: [
                                  Center(
                                    child: TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text("Ok")),
                                  )
                                ],
                              );
                            });
                      } else if (_direccion.text.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const Text(
                                    "Debe introducir su dirección para ofrecerle los anuncios disponibles más cercanos"),
                                actions: [
                                  Center(
                                    child: TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text("Ok")),
                                  )
                                ],
                              );
                            });
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
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
                            border: Border.all(color: Colors.black)),
                        child: const Center(
                          child: Text(
                            "Buscar anuncios",
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
            ),
    );
  }
}
