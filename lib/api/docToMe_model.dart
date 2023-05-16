import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

class DocToMeModel {
  final String name;
  final String desc;
  final Color color;
  final String? imgPath;
  final IconData icon;
  final void Function()? onPressed;
  final Widget? child;
  final double delay;


  const DocToMeModel({
    required this.name,
    required this.desc,
    required this.color,
    this.imgPath,
    required this.icon,
    this.onPressed,
    this.child,
    required this.delay

  });
  //
  static List<DocToMeModel> list = [
    DocToMeModel(
        name: "เปลี่ยนกะ\nทำงาน",
        desc: "รายละอียด",
        delay: 1.5,
        color: Colors.deepPurpleAccent,
        icon: MaterialCommunityIcons.calendar_outline,
        onPressed: (){
          print("1");
        }
    ),
    DocToMeModel(
        name: "เปลี่ยนวันหยุด",
        desc: "รายละอียด",
        delay: 2,
        color: Colors.deepPurpleAccent,
        icon: Ionicons.calendar_outline,
        onPressed: (){
          print("2");
        }
    ),
    DocToMeModel(
        name: "โอที",
        desc: "รายละอียด",
        delay: 2.5,
        color: Colors.deepPurpleAccent,
        icon: Ionicons.hourglass_outline,
        onPressed: (){
          print("3");
        }
    ),
    DocToMeModel(
        name: "ใบเตือน",
        desc: "รายละอียด",
        delay: 3,
        color: Colors.deepPurpleAccent,
        icon: Icons.warning_amber_rounded,
        onPressed: (){
          print("4");
        }
    ),
    DocToMeModel(
        name: "เปลี่ยนสภาพ\nพนักงาน",
        desc: "รายละอียด",
        delay: 3.5,
        color: Colors.deepPurpleAccent,
        icon: Icons.change_circle_outlined,
        onPressed: (){
          print("5");
        }
    ),


  ];


}