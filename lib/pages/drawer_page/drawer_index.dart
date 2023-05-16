import 'package:flutter/material.dart';
import 'package:index/pages/Footerpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer_menu.dart';
import 'drawer_menu2.dart';

void main() => runApp(const MyDrawer());

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Prompt',
      ),
      home: MainNavigation(),
    );
  }
}



