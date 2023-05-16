import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:index/pages/bottom_pages/DateTimePage/table_time_work_values.dart';
import 'package:index/pages/tabBar/table_tabbar.dart';
import 'package:ionicons/ionicons.dart';

import '../../tabBar/calendar_tabbar.dart';
import '../../tabBar/last_detail.dart';

class TableTimeWorkPage extends StatefulWidget {
  const TableTimeWorkPage({Key? key}) : super(key: key);

  @override
  State<TableTimeWorkPage> createState() => _TableTimeWorkPageState();
}

class _TableTimeWorkPageState extends State<TableTimeWorkPage> {

  @override
  Widget build(BuildContext context) =>
    DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ปฎิทินข้อมูลสรุปเวลา"),
          centerTitle: true,
          elevation: 0,
          bottom: const TabBar(
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: Colors.white,width: 3)
            ),
            indicatorColor: Colors.white,
            // labelColor: Colors.green,
            tabs: [
              // Tab(
              //   text: 'ตาราง',
              //   icon: Icon(Ionicons.list),
              // ),
              Tab(
                text: 'ปฎิทิน',
                icon: Icon(Ionicons.calendar_outline),
              ),
              Tab(
                text: 'สรุป',
                icon: Icon(Ionicons.reader_outline),
              ),
            ],
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
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
        body: TabBarView(
            children: [
              // TableTabbarPage(),
              CalendarTabbarPage(),
              LastDetailPage(),
            ]
        )
      ),
    );

}
