

import "package:flutter/material.dart";
import "package:servicio/features/user_auth/presentation/pages/create_ad.dart";
import "package:servicio/features/user_auth/presentation/pages/fav_page.dart";
import "package:servicio/features/user_auth/presentation/pages/home_page.dart";
import "package:servicio/features/user_auth/presentation/pages/my_account.dart";
import "package:servicio/features/user_auth/presentation/pages/my_ads.dart";
import "package:servicio/features/user_auth/presentation/pages/search_page.dart";


int currentIndex = 0;


class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {





  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(items: const <BottomNavigationBarItem> [
      BottomNavigationBarItem(icon: Icon(Icons.search),
      label: "Buscar"),
      BottomNavigationBarItem(icon: Icon(Icons.list_rounded),
      label: "Mis anuncios"),
      BottomNavigationBarItem(icon: Icon(Icons.account_circle),
      label: "Menú"),
    ],
      iconSize: 20,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.teal,
      unselectedItemColor: Colors.white,
      currentIndex: currentIndex,
      selectedFontSize: 14,
      showSelectedLabels: true,
      selectedIconTheme: const IconThemeData(size: 33),
      selectedItemColor: Colors.amber,
      enableFeedback: true,
      unselectedFontSize: 11,
      onTap: (value) {
        setState(() {
          currentIndex = value;
        });
        if (currentIndex == 0) {
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => Search_page()), (route) => false);
        } else if (currentIndex == 1) {
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => My_ads()), (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => My_Account()), (route) => false);
        }
      },
    );
  }






}
