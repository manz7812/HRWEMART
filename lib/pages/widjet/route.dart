import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:page_transition/page_transition.dart';

import '../../main.dart';

class route{
  void myroute(context,Widget myWidget) async{
    Navigator.of(context).pushAndRemoveUntil(
        PageTransition(
          child: myWidget,
          type: PageTransitionType.leftToRight,
          alignment: Alignment.bottomCenter,
          duration: const Duration(milliseconds: 900),
          // reverseDuration: const Duration(milliseconds: 600),
        ), (Route<dynamic> route) => false);
      // MaterialPageRoute route = await MaterialPageRoute(builder: (context) => myWidget);
      // Navigator.pushAndRemoveUntil(context, route, (route) => false);
      runApp(MyApp());
  }

}

