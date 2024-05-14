import 'package:flutter/material.dart';
import 'package:servicio/features/user_auth/widgets/bottomBar_widget.dart';

class My_favs extends StatelessWidget {
  const My_favs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomBar(),
      appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Center(
            child: Text("Favoritos"),
          )),
      body: const Center(
        child: Text("Favoritos"),
      ),

    );
  }
}