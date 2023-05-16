import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:index/pages/bottom_pages/DateTimePage/calendar_time_work.dart';
import 'package:index/pages/bottom_pages/DateTimePage/carlendar/pages/week_view_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../extension.dart';
import '../model/event.dart';
import '../widgets/day_view_widget.dart';
import 'create_event_page.dart';
import 'month_view_page.dart';

class DayViewPageDemo extends StatefulWidget {
  const DayViewPageDemo({Key? key}) : super(key: key);

  @override
  _DayViewPageDemoState createState() => _DayViewPageDemoState();
}

class _DayViewPageDemoState extends State<DayViewPageDemo> {

  bool loading = false;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        loading = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        floatingActionButton: SpeedDial(
          backgroundColor: Colors.deepPurpleAccent,
          animatedIcon: AnimatedIcons.menu_close,
          overlayColor: Colors.black,
          overlayOpacity: 0.2,
          children: [
            SpeedDialChild(
                backgroundColor: Colors.deepPurpleAccent,
                child: Icon(MaterialCommunityIcons.calendar_weekend_outline,size: 30,color: Colors.white,),
                label: 'รายสัปดาห์',
                labelStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
                onTap: ()async{
                  await Future.delayed(Duration(seconds: 0), () {
                    context.pushRoute(WeekViewDemo());
                  });
                }
            ),
            SpeedDialChild(
                backgroundColor: Colors.deepPurpleAccent,
                child: Icon(MaterialCommunityIcons.calendar_month_outline,size: 30,color: Colors.white,),
                label: 'รายเดือน',
                labelStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
                onTap: ()async{
                  await Future.delayed(Duration(seconds: 0), () {
                    context.pushRoute(MonthViewPageDemo());
                  });
                }
            ),
            // SpeedDialChild(
            //     backgroundColor: Colors.deepPurpleAccent,
            //     child: Icon(MaterialCommunityIcons.clock_outline,size: 30,color: Colors.white,),
            //     label: 'เมนู จัดการเวลา',
            //     labelStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
            //     onTap: ()async{
            //       await Future.delayed(Duration(seconds: 0), () {
            //         Navigator.pop(globalContext);
            //       });
            //     }
            // ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.arrow_back_ios),
        //   elevation: 8,
        //   onPressed: (){
        //     Navigator.pop(globalContext);
        //   },
        // ),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.add),
        //   elevation: 8,
        //   onPressed: () async {
        //     final event =
        //         await context.pushRoute<CalendarEventData<Event>>(CreateEventPage(
        //       withDuration: true,
        //     ));
        //     if (event == null) return;
        //     CalendarControllerProvider.of<Event>(context).controller.add(event);
        //   },
        // ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 60,
          leading: const Text(""),
          flexibleSpace : Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
              // border: Border.all(width: 15, color: Colors.white),
            ),
            child: Container(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children:[
                          Container(
                            // padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                            child: Card(
                              child: Container(
                                height: 10,
                                width: 40,
                                alignment: Alignment.center,
                                // padding: const EdgeInsets.all(10),
                              ),
                              elevation: 3,
                              color: Colors.orange.shade600,
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide:  BorderSide(color: Colors.transparent)
                              ),
                            ),
                          ),
                          // Icon(Icons.remove,color: Colors.orange.shade600,size: 30,),
                          Text("วันหยุด",style: TextStyle(fontSize: 10),)
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children:[
                          Container(
                            // padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                            child: Card(
                              child: Container(
                                height: 10,
                                width: 40,
                                alignment: Alignment.center,
                                // padding: const EdgeInsets.all(10),
                              ),
                              elevation: 3,
                              color: Colors.red.shade600,
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide:  BorderSide(color: Colors.transparent)
                              ),
                            ),
                          ),
                          Text("สาย/ออกก่อน",style: TextStyle(fontSize: 10),)
                        ],
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            // padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                            child: Card(
                              child: Container(
                                height: 10,
                                width: 40,
                                alignment: Alignment.center,
                                // padding: const EdgeInsets.all(10),
                              ),
                              elevation: 3,
                              color: Colors.grey,
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide:  BorderSide(color: Colors.transparent)
                              ),
                            ),
                          ),
                          // Icon(Icons.circle,color: Colors.grey,size: 10,),
                          Text("วันลา",style: TextStyle(fontSize: 10),)
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            // padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                            child: Card(
                              child: Container(
                                height: 10,
                                width: 40,
                                alignment: Alignment.center,
                                // padding: const EdgeInsets.all(10),
                              ),
                              elevation: 3,
                              color: Colors.blue,
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide:  BorderSide(color: Colors.transparent)
                              ),
                            ),
                          ),
                          Text("โอที",style: TextStyle(fontSize: 10),)
                        ],
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            // padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                            child: Card(
                              child: Container(
                                height: 10,
                                width: 40,
                                alignment: Alignment.center,
                                // padding: const EdgeInsets.all(10),
                              ),
                              elevation: 3,
                              color: Colors.yellow,
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide:  BorderSide(color: Colors.transparent)
                              ),
                            ),
                          ),
                          Text("เปลี่ยนกะ",style: TextStyle(fontSize: 10),)
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            // padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                            child: Card(
                              child: Container(
                                height: 10,
                                width: 40,
                                alignment: Alignment.center,
                                // padding: const EdgeInsets.all(10),
                              ),
                              elevation: 3,
                              color: Colors.green,
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide:  BorderSide(color: Colors.transparent)
                              ),
                            ),
                          ),
                          Text("เวลาทำงาน",style: TextStyle(fontSize: 10),)
                        ],
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
        body: loading ? DayViewWidget()
            :Center(
              child: LoadingAnimationWidget.discreteCircle(
                color: Colors.deepPurpleAccent,
                secondRingColor: Colors.white,
                thirdRingColor: Colors.white,
                size: 40
          ),
        ),
      ),
    );
  }
}
