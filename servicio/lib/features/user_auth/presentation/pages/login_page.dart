// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:servicio/features/user_auth/presentation/pages/reset_password.dart';
import 'package:servicio/features/user_auth/presentation/pages/search_page.dart';
import 'package:servicio/features/user_auth/presentation/pages/sign_up.dart';
import 'package:servicio/features/user_auth/widgets/form_container_widget.dart';

import 'home_page.dart';


/// ESTA ES LA PAGINA DE INICIO DE SESION.



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});


  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }


  // Esta funcion comprueba si el usuario y contraseña introducidos por el usuario
  // son validos y si es asi procede a iniciar sesion. En caso contrario muestra un error.
  void _LogIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (password.isEmpty || email.isEmpty){
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text("El campo de email o contraseña no puede estar vacío"),
              actions: [
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }else{
    try {
      final credencial = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.trim().toLowerCase(), password: password);

      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => const Search_page()),(route) => false,);
    } catch (e) {

      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text("Email o contraseña incorrecta"),
              actions: [
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Iniciar sesión"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  "Iniciar sesión",
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 30,
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
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: _LogIn,

                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "Entrar",
                      style: TextStyle(
                          fontSize: 20,color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("¿Eres nuevo?"),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp()));
                  },
                  child: const Text("Registrate", style: TextStyle(color: Colors.blue),),
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("¿Has olvidado la contraseña?"),
                  const SizedBox(width: 5,
                    height: 60,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ResetPassword()));
                    },
                    child: const Text("Recuperar contraseña", style: TextStyle(color: Colors.blue),),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
