import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import 'drawer_EmployeeDetail.dart';
import 'drawer_mange_time_Employee.dart';
import 'drawer_searchEmployee.dart';

class MainEmployeePages extends StatefulWidget {
  const MainEmployeePages({Key? key}) : super(key: key);

  @override
  State<MainEmployeePages> createState() => _MainEmployeePagesState();
}

class _MainEmployeePagesState extends State<MainEmployeePages> {
  @override
  Widget build(BuildContext context) =>
      DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: const Text("จัดการพนักงาน"),
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
                    text: 'จัดการเวลา',
                    icon: Icon(MaterialCommunityIcons.timeline_clock_outline),
                  ),
                  Tab(
                    text: 'ค้นหาพนักงาน',
                    icon: Icon(MaterialCommunityIcons.account_search),
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
            body: const TabBarView(
                children: [
                  EmployeeMangeTimePages(),
                  SearchEmployeePage(title: '',),
                  // LastDetailPage(),
                ]
            )
        ),
      );
}
