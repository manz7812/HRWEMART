// ignore_for_file: prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function() onTap;

   MenuItem({ Key? key,  required this.icon,  required this.title,  required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: Colors.cyan,
              size: 30,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 26, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

