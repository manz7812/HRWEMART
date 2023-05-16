import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../../../calendar_time_work.dart';
import '../../extension.dart';
import '../day_view_page.dart';
import '../month_view_page.dart';
import '../week_view_page.dart';

class MobileHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("รายละเอียดปฎิทิน"),
      //   centerTitle: true,
      //   leading: IconButton(
      //     onPressed: () {
      //       Navigator.pop(globalContext);
      //     },
      //     icon: Icon(Icons.arrow_back_ios),
      //   ),
      //   elevation: 0,
      //   flexibleSpace : Container(
      //     decoration: const BoxDecoration(
      //       borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
      //       // border: Border.all(width: 15, color: Colors.white),
      //       gradient:  LinearGradient(
      //         colors: [
      //           Color(0xff6200EA),
      //           Colors.white,
      //         ],
      //         begin:  FractionalOffset(0.0, 1.0),
      //         end:  FractionalOffset(1.5, 1.5),
      //       ),
      //       boxShadow: [
      //         BoxShadow(
      //           color: Colors.transparent,
      //           spreadRadius: 5, blurRadius: 30,
      //           offset: Offset(5, 3),
      //         ),
      //       ],
      //       // image: DecorationImage(image: NetworkImage('https://www.pngitem.com/pimgs/m/391-3918613_personal-service-platform-person-icon-circle-png-transparent.png'))
      //     ),
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back_ios),
        elevation: 8,
        onPressed: (){
          Navigator.pop(globalContext);
        },
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurpleAccent,
                  elevation: 3,
                  shape: CircleBorder()
              ),
              onPressed: () => context.pushRoute(MonthViewPageDemo()),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(MaterialCommunityIcons.calendar_month_outline,size: 50,),
                    Text("เดือน",style: TextStyle(fontSize: 22),),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => context.pushRoute(DayViewPageDemo()),
              style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurpleAccent,
                  elevation: 3,
                  shape: CircleBorder()
              ),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(MaterialCommunityIcons.calendar_today,size: 50),
                    Text("วัน",style: TextStyle(fontSize: 22),),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurpleAccent,
                  elevation: 3,
                  shape: CircleBorder()
              ),
              onPressed: () => context.pushRoute(WeekViewDemo()),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(MaterialCommunityIcons.calendar_weekend_outline,size: 50),
                    Text("สัปดาห์",style: TextStyle(fontSize: 22),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
