import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:index/pages/drawer_page/DrawSearchEm/report/report_anomaly.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../bottom_pages/DateTimePage/carlendar/model/event.dart';


DateTime get _now => DateTime.now();
class ReportAnomalyCalendarPage extends StatefulWidget {
  const ReportAnomalyCalendarPage({Key? key}) : super(key: key);

  @override
  State<ReportAnomalyCalendarPage> createState() => _ReportAnomalyCalendarPageState();
}

class _ReportAnomalyCalendarPageState extends State<ReportAnomalyCalendarPage> {
  bool loading = false;
  GlobalKey<MonthViewState>? state;
  double? width;
  DateTime? minDay;
  DateTime? maxDay;


  Future<Null> getTime()async{
    var d0 = DateTime(_now.year,_now.month-1);
    var nows = DateFormat("yyyy-MM").format(d0);
    var d1 = DateFormat("yyyy-MM-dd").parse("${nows}-1");
    var d2 = DateFormat("yyyy-MM-dd").format(d1);

    var startdate = DateTime.parse(d2);
    minDay = startdate;
    // print(startdate);
    var enddate = DateTime(startdate.year,startdate.month+3,startdate.day-1);
    maxDay = enddate;
    // print(enddate);
  }

  @override
  void initState() {
    getTime();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        loading = true;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider<Event>(
      controller: EventController<Event>()..addAll(_events),
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.clear),
          elevation: 8,
          mini: true,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 0,
          leading: const Text(""),
          // bottom: PreferredSize(
          //   preferredSize: Size.fromHeight(80.0),
          //   child: Container(
          //     padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
          //     // decoration: const BoxDecoration(
          //     //   borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
          //     //   // border: Border.all(width: 15, color: Colors.white),
          //     //   gradient:  LinearGradient(
          //     //     colors: [
          //     //       Color(0xff6200EA),
          //     //       Colors.white,
          //     //     ],
          //     //     begin:  FractionalOffset(0.0, 1.0),
          //     //     end:  FractionalOffset(1.5, 1.5),
          //     //   ),
          //     //   boxShadow: [
          //     //     BoxShadow(
          //     //       color: Colors.transparent,
          //     //       spreadRadius: 5, blurRadius: 30,
          //     //       offset: Offset(5, 3),
          //     //     ),
          //     //   ],
          //     //   // image: DecorationImage(image: NetworkImage('https://www.pngitem.com/pimgs/m/391-3918613_personal-service-platform-person-icon-circle-png-transparent.png'))
          //     // ),
          //     child: Container(
          //       padding: EdgeInsets.all(5),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //         children: [
          //           Column(
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             // mainAxisAlignment: MainAxisAlignment.start,
          //             children: [
          //               Container(
          //                 // padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
          //                 child: Card(
          //                   child: Container(
          //                     height: 10,
          //                     width: 40,
          //                     alignment: Alignment.center,
          //                     // padding: const EdgeInsets.all(10),
          //                   ),
          //                   elevation: 3,
          //                   color: Colors.green,
          //                   shape: OutlineInputBorder(
          //                       borderRadius: BorderRadius.circular(50),
          //                       borderSide:  BorderSide(color: Colors.transparent)
          //                   ),
          //                 ),
          //               ),
          //               // Icon(Icons.remove,color: Colors.orange.shade600,size: 30,),
          //               Text("ยืนยันแล้ว",style: TextStyle(fontSize: 16),),
          //             ],
          //           ),
          //
          //           Column(
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             // mainAxisAlignment: MainAxisAlignment.start,
          //             children: [
          //               Container(
          //                 // padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
          //                 child: Card(
          //                   child: Container(
          //                     height: 10,
          //                     width: 40,
          //                     alignment: Alignment.center,
          //                     // padding: const EdgeInsets.all(10),
          //                   ),
          //                   elevation: 3,
          //                   color: Colors.yellow,
          //                   shape: OutlineInputBorder(
          //                       borderRadius: BorderRadius.circular(50),
          //                       borderSide:  BorderSide(color: Colors.transparent)
          //                   ),
          //                 ),
          //               ),
          //               // Icon(Icons.remove,color: Colors.orange.shade600,size: 30,),
          //               Text("รอยืนยัน",style: TextStyle(fontSize: 16),),
          //             ],
          //           ),
          //
          //           Column(
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             // mainAxisAlignment: MainAxisAlignment.start,
          //             children: [
          //               Container(
          //                 // padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
          //                 child: Card(
          //                   child: Container(
          //                     height: 10,
          //                     width: 40,
          //                     alignment: Alignment.center,
          //                     // padding: const EdgeInsets.all(10),
          //                   ),
          //                   elevation: 3,
          //                   color: Colors.grey,
          //                   shape: OutlineInputBorder(
          //                       borderRadius: BorderRadius.circular(50),
          //                       borderSide:  BorderSide(color: Colors.transparent)
          //                   ),
          //                 ),
          //               ),
          //               // Icon(Icons.remove,color: Colors.orange.shade600,size: 30,),
          //               Text("ประมวลผล",style: TextStyle(fontSize: 16),),
          //             ],
          //           ),
          //
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ),
        body: loading ?Stack(
          children: [
            Positioned(
              // top: 20,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.start,
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
                          // Icon(Icons.remove,color: Colors.orange.shade600,size: 30,),
                          Text("ยืนยันแล้ว",style: TextStyle(fontSize: 16),),
                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.start,
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
                          // Icon(Icons.remove,color: Colors.orange.shade600,size: 30,),
                          Text("รอยืนยัน",style: TextStyle(fontSize: 16),),
                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.start,
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
                          // Icon(Icons.remove,color: Colors.orange.shade600,size: 30,),
                          Text("ประมวลผล",style: TextStyle(fontSize: 16),),
                        ],
                      ),

                    ],
                  ),
                ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
              child: MonthView<Event>(
                key: state,
                width: width,
                minMonth: minDay,
                maxMonth: maxDay,
                cellAspectRatio: 0.45,
                onEventTap: (CalendarEventData , DateTime){

                },
                // onCellTap: (List ,DateTime){
                //   print(List);
                // },
              ),
            ),
          ],
        )
            : Center(
              child: LoadingAnimationWidget.discreteCircle(
                  color: Colors.deepPurpleAccent,
                  secondRingColor: Colors.deepPurpleAccent,
                  thirdRingColor: Colors.white,
                  size: 40
              ),
            ),
      ),
      // child: MaterialApp(
      //   debugShowCheckedModeBanner: false,
      //   home: ReportAnomalyMonthPage(globalContexts)
      // ),
    );
  }

  final List<CalendarEventData<Event>> _events = [
    CalendarEventData(
        date: _now.add(Duration(days: -4)),
        event: Event(title: "เวลาทำงาน"),
        title: "08:00-17:00",
        description: "เวลาทำงาน",
        startTime: DateTime(_now.year, _now.month, _now.day, 08, 00),
        endTime: DateTime(_now.year, _now.month, _now.day, 17,00),
        color: Colors.green.shade300
    ),
    CalendarEventData(
        date: _now.add(Duration(days: -3)),
        event: Event(title: "เวลาทำงาน"),
        title: "08:00-17:00",
        description: "เวลาทำงาน",
        startTime: DateTime(_now.year, _now.month, _now.day, 08, 00),
        endTime: DateTime(_now.year, _now.month, _now.day, 17,00),
        color: Colors.green.shade300
    ),
    CalendarEventData(
        date: _now.add(Duration(days: -2)),
        event: Event(title: "เวลาทำงาน"),
        title: "08:00-17:00",
        description: "เวลาทำงาน",
        startTime: DateTime(_now.year, _now.month, _now.day, 08, 00),
        endTime: DateTime(_now.year, _now.month, _now.day, 17,00),
        color: Colors.green.shade300
    ),
    CalendarEventData(
        date: _now.add(Duration(days: -1)),
        event: Event(title: "เวลาทำงาน"),
        title: "08:00-17:00",
        description: "เวลาทำงาน",
        startTime: DateTime(_now.year, _now.month, _now.day, 08, 00),
        endTime: DateTime(_now.year, _now.month, _now.day, 17,00),
        color: Colors.green.shade300
    ),
    CalendarEventData(
        date: _now,
        event: Event(title: "เวลาทำงาน"),
        title: "08:00-17:00",
        description: "เวลาทำงาน",
        startTime: DateTime(_now.year, _now.month, _now.day, 08, 00),
        endTime: DateTime(_now.year, _now.month, _now.day, 17,00),
        color: Colors.green.shade300
    ),
    CalendarEventData(
        date: _now.add(Duration(days: 1)),
        event: Event(title: "เวลาทำงาน"),
        title: "08:00-17:00",
        description: "เวลาทำงาน",
        startTime: DateTime(_now.year, _now.month, _now.day, 08, 00),
        endTime: DateTime(_now.year, _now.month, _now.day, 17,00),
        color: Colors.green.shade300
    ),
    CalendarEventData(
        date: _now.add(Duration(days: 2)),
        event: Event(title: "เวลาทำงาน"),
        title: "08:00-17:00",
        description: "เวลาทำงาน",
        startTime: DateTime(_now.year, _now.month, _now.day, 08, 00),
        endTime: DateTime(_now.year, _now.month, _now.day, 17,00),
        color: Colors.green.shade300
    ),


    // CalendarEventData(
    //   date: _now.add(Duration(days: 3)),
    //   startTime: DateTime(_now.add(Duration(days: 3)).year,
    //       _now.add(Duration(days: 3)).month, _now.add(Duration(days: 3)).day, 10),
    //   endTime: DateTime(_now.add(Duration(days: 3)).year,
    //       _now.add(Duration(days: 3)).month, _now.add(Duration(days: 3)).day, 14),
    //   event: Event(title: "Sprint Meeting."),
    //   title: "Sprint Meeting.",
    //   description: "Last day of project submission for last year.",
    // ),
    // CalendarEventData(
    //   date: _now.subtract(Duration(days: 2)),
    //   startTime: DateTime(
    //       _now.subtract(Duration(days: 2)).year,
    //       _now.subtract(Duration(days: 2)).month,
    //       _now.subtract(Duration(days: 2)).day,
    //       14),
    //   endTime: DateTime(
    //       _now.subtract(Duration(days: 2)).year,
    //       _now.subtract(Duration(days: 2)).month,
    //       _now.subtract(Duration(days: 2)).day,
    //       16),
    //   event: Event(title: "Team Meeting"),
    //   title: "Team Meeting",
    //   description: "Team Meeting",
    // ),
    // CalendarEventData(
    //   date: _now.subtract(Duration(days: 2)),
    //   startTime: DateTime(
    //       _now.subtract(Duration(days: 2)).year,
    //       _now.subtract(Duration(days: 2)).month,
    //       _now.subtract(Duration(days: 2)).day,
    //       10),
    //   endTime: DateTime(
    //       _now.subtract(Duration(days: 2)).year,
    //       _now.subtract(Duration(days: 2)).month,
    //       _now.subtract(Duration(days: 2)).day,
    //       12),
    //   event: Event(title: "Chemistry Viva"),
    //   title: "Chemistry Viva",
    //   description: "Today is Joe's birthday.",
    // ),
  ];
}
