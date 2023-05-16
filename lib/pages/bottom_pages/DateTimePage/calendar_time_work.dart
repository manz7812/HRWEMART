import 'dart:convert';
import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:index/api/url.dart';
import 'package:index/pages/bottom_pages/DateTimePage/carlendar/pages/month_view_page.dart';
import 'package:index/pages/widjet/popupAlert.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'carlendar/model/event.dart';
import 'carlendar/pages/mobile/mobile_home_page.dart';
import 'carlendar/pages/web/web_home_page.dart';
import 'carlendar/pages/week_view_page.dart';
import 'carlendar/widgets/responsive_widget.dart';

DateTime get _now => DateTime.now();
var globalContext;
class CalendarTimeWorkPage extends StatefulWidget {
  const CalendarTimeWorkPage({Key? key}) : super(key: key);

  @override
  State<CalendarTimeWorkPage> createState() => _CalendarTimeWorkPageState();
}

class _CalendarTimeWorkPageState extends State<CalendarTimeWorkPage> {
  bool loading = false;

  String token = "";
  Future<Null> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
    getdata();
    // print(token);
  }

  List dataE = [];
  Future<Null> getdata() async {
    try{
      setState(() {
        loading = false;
      });
      String url = pathurl.getDTKCalendar;
      final response = await get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
      var data = jsonDecode(response.body);
      // print(data);
      if (response.statusCode == 200) {
        setState(() {
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              loading = true;
            });
          });
          dataE = data["data"];
          // _refreshController.refreshCompleted();
          // print(dataE);
          getDataevent();
          // dataHuman = Usermodel.fromMap(data['data'][0]);
          // print(dataHuman!.toMap());
        });
      }else if(response.statusCode == 401){
        popup().sessionexpire(context);
        setState(() {
          dataE = [];
        });
      }else{
        setState(() {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO_REVERSED,
            dismissOnTouchOutside: false,
            // dialogBackgroundColor: Colors.orange,
            borderSide: BorderSide(color: Colors.black12, width: 2),
            width: 350,
            buttonsBorderRadius: BorderRadius.all(Radius.circular(10)),
            headerAnimationLoop: false,
            animType: AnimType.SCALE,
            showCloseIcon: false,
            // dialogBackgroundColor: Colors.deepPurpleAccent,
            title: 'เชื่อมต่อเซิพเวอร์ไม่สำเร็จ',
            desc: 'กรุณาลองใหม่อีกครั้ง',
            btnOkText: "ตกลง",
            btnCancelText: "ยกเลิก",
            btnOkOnPress: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => super.widget));
            },
          ).show();
          dataE = [];
        });
      }
    }catch(e){
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO_REVERSED,
        dismissOnTouchOutside: false,
        // dialogBackgroundColor: Colors.orange,
        borderSide: BorderSide(color: Colors.black12, width: 2),
        width: 350,
        buttonsBorderRadius: BorderRadius.all(Radius.circular(10)),
        headerAnimationLoop: false,
        animType: AnimType.SCALE,
        showCloseIcon: false,
        // dialogBackgroundColor: Colors.deepPurpleAccent,
        title: 'เชื่อมต่อเซิพเวอร์ไม่สำเร็จ',
        desc: 'กรุณาลองใหม่อีกครั้ง',
        btnOkText: "ตกลง",
        btnCancelText: "ยกเลิก",
        btnOkOnPress: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => super.widget));
        },
      ).show();
    }
  }

  final List<CalendarEventData<Event>> _events2 = [];

  Future<Null> getDataevent() async {
    for (var data in dataE) {
      var colors;
      if(data['event'] =="วันหยุด"){
        colors = Colors.orange.shade600;
      }else if(data['event'] =="วันลา"){
        colors = Colors.grey;
      }else if(data['event'] =="เปลี่ยนกะ"){
        colors = Colors.yellow;
      }else if(data['event'] =="สาย"){
        colors = Colors.red.shade600;
      }else if(data['event'] =="ออกก่อน"){
        colors = Colors.red.shade600;
      }else if(data['event'] =="โอที"){
        colors = Colors.blue;
      }
      else{
        colors = Colors.green;
      }
      var NewdataE = CalendarEventData(
          date: DateTime.parse(data['date']),
          event: Event(title: data['event']),
          title: data['title'].toString(),
          description: data['description'],
          startTime: DateTime.parse(data['start']),
          endTime: DateTime.parse(data['end']),
          color: colors
      );
      _events2.add(NewdataE);
    }

  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return DraggableScrollableSheet(
      initialChildSize: 0.93,
      // minChildSize: 0.2,
      maxChildSize: 1.0,
      builder: (_,controller)=>
          CalendarControllerProvider<Event>(
            controller: EventController<Event>()..addAll(_events2),
            // child: Scaffold(
            //   backgroundColor: Colors.transparent,
            //   body: loading ? MonthViewPageDemo()
            //       :Center(
            //         child: LoadingAnimationWidget.discreteCircle(
            //               color: Colors.white,
            //               secondRingColor: Colors.white,
            //               thirdRingColor: Colors.white,
            //               size: 40
            //            ),
            //     ),
            // ),
            // child: MaterialApp(
            //   debugShowCheckedModeBanner: false,
            //   theme: ThemeData.light(),
            //   scrollBehavior: ScrollBehavior().copyWith(
            //     dragDevices: {
            //       // PointerDeviceKind.trackpad,
            //       PointerDeviceKind.mouse,
            //       PointerDeviceKind.touch,
            //     },
            //   ),
            //   home: loading ? ResponsiveWidget(
            //     mobileWidget: MonthViewPageDemo(globalContext),
            //     webWidget: WebHomePage(),
            //   )
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
                home: MonthViewPageDemo()
              ),
            ),
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

