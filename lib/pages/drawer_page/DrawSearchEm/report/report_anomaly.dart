import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:index/pages/drawer_page/DrawSearchEm/report/report_calendar.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../bottom_pages/DateTimePage/carlendar/model/event.dart';

DateTime get _now => DateTime.now();
class ReportAnomalyMonthPage extends StatefulWidget {
  const ReportAnomalyMonthPage(globalContexts, {Key? key}) : super(key: key);

  @override
  State<ReportAnomalyMonthPage> createState() => _ReportAnomalyMonthPageState();
}

class _ReportAnomalyMonthPageState extends State<ReportAnomalyMonthPage> {
  GlobalKey<MonthViewState>? state;
  double? width;
  DateTime? minDay;
  DateTime? maxDay;
  bool loading = false;

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
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.grey.shade300,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.arrow_back_ios),
          elevation: 8,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
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
        body: loading ?MonthView<Event>(
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
        )
            :Center(
              child: LoadingAnimationWidget.discreteCircle(
                  color: Colors.white,
                  secondRingColor: Colors.white,
                  thirdRingColor: Colors.white,
                  size: 40
              ),
            ),

      ),
    );
  }
}
