import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:index/login.dart';
import 'package:index/main.dart';
import 'package:index/pages/widjet/route.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<Null> signOut(context) async{
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  SharedPreferences preferences = await SharedPreferences.getInstance();
  // _firebaseMessaging.deleteToken().whenComplete(() async{
  //   // String? token = await _firebaseMessaging.getToken();
  //   print("success log out");
  // });
  preferences.clear();
  // MyDialog().alertLogout(context);
  route().myroute(context,MyApp());
  // Future.delayed( Duration(seconds: 3),(){
  //   route().myroute(context,MyApp());
  // });
}




