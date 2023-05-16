import 'package:flutter/material.dart';
import 'drawer_menu2.dart';

void main() => runApp(const MyDrawer2());
class MyDrawer2 extends StatelessWidget {
  const MyDrawer2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Prompt',
      ),
      home: MainNavigation2(),
    );
  }
}
