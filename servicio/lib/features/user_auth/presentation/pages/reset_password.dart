
// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:servicio/features/user_auth/widgets/form_container_widget.dart';

class ResetPassword extends StatefulWidget{
  const ResetPassword({super.key});



  /// ESTA PAGINA ES PARA RESTABLECER LA CONTRASEÑA EN CASO DE SER OLVIDADA POR EL USUARIO.



  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword>{

  TextEditingController _ResetPassword = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recuperar contraseña"),
        centerTitle: true,
      ),
    body: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          const SizedBox(height: 30,),
          const Text("Introduzca su email para recuperar la contraseña", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),textAlign: TextAlign.center),
          const SizedBox(height: 120),
          FormContainerWidget(hintText: "Email",
          controller: _ResetPassword,
          ),
          const SizedBox(height: 30),
          GestureDetector(onTap: send_password,
            child:
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                child: const Center(child: Text("Enviar email de recuperacion", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),)
              ),)
        ],
      ),
    ),
    );
  }



  Future<void> send_password() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _ResetPassword.text);

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Recuperar contraseña"),
              content: const Text("Revise la bandeja de entrada de su email para reestablecer la contraseña", textAlign: TextAlign.center),
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

    } catch(e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text("No se ha encontrado el email ${_ResetPassword.text}", textAlign: TextAlign.center),
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

