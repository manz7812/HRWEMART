import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';


class MyTimePage extends StatefulWidget with NavigationStates{
  const MyTimePage({Key? key}) : super(key: key);

  @override
  _MyTimeState createState() => _MyTimeState();
}

class _MyTimeState extends State<MyTimePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.indigo[900],
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var long = "longitude";
  var lat = "latitude";

  void getlocation() async {
    LocationPermission per = await Geolocator.checkPermission();
    if (per == LocationPermission.denied ||
        per == LocationPermission.deniedForever) {
      print("permission denied");
      LocationPermission per1 = await Geolocator.requestPermission();
    } else {
      Position currentLoc = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      setState(() {
        long = currentLoc.longitude.toString();
        lat = currentLoc.latitude.toString();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "latitude : " + lat,
              style: TextStyle(
                color: Colors.indigo[900],
                fontSize: 30,
              ),
            ),
            Text(
              "logitude : " + long,
              style: TextStyle(
                color: Colors.indigo[900],
                fontSize: 30,
              ),
            ),
            MaterialButton(
              onPressed: getlocation,
              color: Colors.indigo[900],
              child: const Text(
                "Get Location",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}