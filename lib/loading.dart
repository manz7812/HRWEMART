import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // body:  Center(
      //     child: CircularProgressIndicator(
      //       valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
      //       strokeWidth: 5,
      //     )
      // ),
      body: Center(
        // child: LottieBuilder.network('https://assets9.lottiefiles.com/packages/lf20_qftxsr68.json',
        //   width: 200,
        //   animate: true,
        // ),
        child: LottieBuilder.network("https://assets5.lottiefiles.com/packages/lf20_c259vu8m.json",width: 200,animate: true,),
      ),
    );
  }
}
