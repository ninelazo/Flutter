// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:servicio/features/user_auth/presentation/pages/complete_profile.dart';
import 'package:servicio/features/user_auth/widgets/form_container_widget.dart';



/// ESTA PAGINA REGISTRA UN NUEVO USUARIO. TRAS COMPLETAR LOS CAMPOS SOLICITADOS
/// EL USUARIO SERÁ REDIGIRIDO A LA PAGINA DE COMPLETAR PERFIL.



final uid = FirebaseAuth.instance.currentUser?.uid;
FirebaseStorage _storage = FirebaseStorage.instance;
FirebaseFirestore db = FirebaseFirestore.instance;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: const Text("Registro"),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "Crear cuenta",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const SizedBox(
              height: 10,
            ),
            FormContainerWidget(
              controller: _emailController,
              hintText: "Email",
              isPasswordField: false,
            ),
            const SizedBox(
              height: 10,
            ),
            FormContainerWidget(
              controller: _passwordController,
              hintText: "Contraseña",
              isPasswordField: true,
              validator: (value) {
                if (value!.length < 8) {
                  return "Enter valid name";
                }
              },
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: (_signUp),
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "Registrarse",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // Funcion que crea un nuevo usuario. Comprueba si el email no ha sido utilizado previamente
  // y además si la contraseña es del formato requerido.
  void _signUp() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error", textAlign: TextAlign.center),
              content: const Text(
                  "El campo email o contraseña no puede estar vacio",
                  textAlign: TextAlign.center),
              actions: [
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    } else if (password!.length < 8) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                  "La contraseña debe contener al menos 8 caracteres",
                  textAlign: TextAlign.center),
              actions: [
                TextButton(
                  child: const Text("Reintentar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    } else {
      try {
        final credencital = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Profile()));
      } catch (e) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Error", textAlign: TextAlign.center),
                content: const Text("El email ya está en uso",
                    textAlign: TextAlign.center),
                actions: [
                  TextButton(
                    child: const Text("Ok"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            });
      }
    }
  }
}
