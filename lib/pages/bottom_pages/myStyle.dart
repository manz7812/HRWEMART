import 'package:flutter/material.dart';

class Mystyle{
  // Color primaryColor = Colors.deepPurpleAccent;
  Widget showProgress(){
    return const Center(
      child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
              strokeWidth: 5,
      ),
    );
  }

  Mystyle();
}