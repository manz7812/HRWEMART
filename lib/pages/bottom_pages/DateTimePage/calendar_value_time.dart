import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:index/pages/tabBar/holiday_tabbar.dart';
import 'package:index/pages/tabBar/ka_tabbar.dart';
import 'package:index/pages/tabBar/workLa_tabbar.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarValueTimePage extends StatefulWidget {
  const CalendarValueTimePage({Key? key}) : super(key: key);

  @override
  State<CalendarValueTimePage> createState() => _CalendarValueTimePageState();
}

class _CalendarValueTimePageState extends State<CalendarValueTimePage> {
  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: Scaffold(
            backgroundColor: Colors.grey.shade300,
            appBar: AppBar(
              title: const Text("ปฎิทินข้อมูลสรุปเวลา"),
              centerTitle: true,
              elevation: 0,
              bottom: const TabBar(
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(color: Colors.white, width: 3)),
                indicatorColor: Colors.white,
                // labelColor: Colors.green,
                tabs: [
                  Tab(
                    text: 'ลางาน',
                    icon: Icon(Ionicons.time_outline),
                  ),
                  Tab(
                    text: 'กะ',
                    icon: Icon(Ionicons.sync_outline),
                  ),
                  Tab(
                    text: 'วันหยุด',
                    icon: Icon(Ionicons.partly_sunny_outline),
                  ),
                ],
              ),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(0)),
                  // border: Border.all(width: 15, color: Colors.white),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff6200EA),
                      Colors.white,
                    ],
                    begin: FractionalOffset(0.0, 1.0),
                    end: FractionalOffset(1.5, 1.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.transparent,
                      spreadRadius: 5,
                      blurRadius: 30,
                      offset: Offset(5, 3),
                    ),
                  ],
                  // image: DecorationImage(image: NetworkImage('https://www.pngitem.com/pimgs/m/391-3918613_personal-service-platform-person-icon-circle-png-transparent.png'))
                ),
              ),
            ),
            body: const TabBarView(
              children: [
                WorkLaTabbarPage(),
                KaTabbarPage(),
                HolidayTabbarPage(),
              ],
            )),
      );
}
