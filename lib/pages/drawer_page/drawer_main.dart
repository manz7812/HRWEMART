import 'package:flutter/material.dart';
import 'package:index/pages/footerpage.dart';


class MainPagesDW extends StatefulWidget {
  const MainPagesDW({Key? key , }) : super(key: key);

  @override
  _MainPagesDWState createState() => _MainPagesDWState();
}

class _MainPagesDWState extends State<MainPagesDW>{
  // Widget screenView = const MainPagesDW(title: 'หน้าหลัก');
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          flexibleSpace : Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
              // border: Border.all(width: 15, color: Colors.white),
              gradient:  LinearGradient(
                colors: [
                  Color(0xff6200EA),
                  Colors.white,
                ],
                begin:  FractionalOffset(0.0, 1.0),
                end:  FractionalOffset(1.5, 1.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.transparent,
                  spreadRadius: 5, blurRadius: 30,
                  offset: Offset(5, 3),
                ),
              ],
              // image: DecorationImage(image: NetworkImage('https://www.pngitem.com/pimgs/m/391-3918613_personal-service-platform-person-icon-circle-png-transparent.png'))
            ),
          ),
        ),
        body: const FooterPage(),
      ),
    );
  }
}



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



class MainPageDWFT extends StatefulWidget {
  const MainPageDWFT({Key? key}) : super(key: key);

  @override
  State<MainPageDWFT> createState() => _MainPageDWFTState();
}

class _MainPageDWFTState extends State<MainPageDWFT> {
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          flexibleSpace : Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
              // border: Border.all(width: 15, color: Colors.white),
              gradient:  LinearGradient(
                colors: [
                  Color(0xff6200EA),
                  Colors.white,
                ],
                begin:  FractionalOffset(0.0, 1.0),
                end:  FractionalOffset(1.5, 1.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.transparent,
                  spreadRadius: 5, blurRadius: 30,
                  offset: Offset(5, 3),
                ),
              ],
              // image: DecorationImage(image: NetworkImage('https://www.pngitem.com/pimgs/m/391-3918613_personal-service-platform-person-icon-circle-png-transparent.png'))
            ),
          ),
        ),
        body: const FooterPage2(),
      ),
    );
  }
}
