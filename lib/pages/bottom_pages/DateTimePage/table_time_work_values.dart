import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:index/pages/bottom_pages/DateTimePage/carlendar/model/event.dart';
import 'package:index/pages/bottom_pages/DocAddTime/Doc_AddTime.dart';
import 'package:index/pages/bottom_pages/DocHoliday/Doc_ChangeHoliday.dart';
import 'package:index/pages/bottom_pages/DocKa/Doc_ChangeKa.dart';
import 'package:index/pages/bottom_pages/DocOT/Doc_OT.dart';
import 'package:intl/intl.dart';

import '../DocLa/Doc_LA.dart';
// import 'package:ionicons/ionicons.dart';

class TableTimeWorkValuesPage extends StatefulWidget {
  final String event;
  final DateTime date;
  final String description;
  TableTimeWorkValuesPage({Key? key, required this.event, required this.date, required this.description}) : super(key: key);

  @override
  State<TableTimeWorkValuesPage> createState() => _TableTimeWorkValuesPageState();
}

class _TableTimeWorkValuesPageState extends State<TableTimeWorkValuesPage> {

  String? Dates;
  String? status = "";
  String? time = "";
  String? ka = "";
  Future<Null> getdataFromTBCarlendar()async{
    var df = DateFormat('dd/MM/yyyy').format(widget.date);
    Dates = df;
    var d1 = widget.description.split("\n");
    var d2 = d1[0].split(" ");
    var d3 = d1[1].split(" ");
    var d4 = d1[2].split(" ");
    status = d2[1];
    ka = d3[1].replaceAll('[', '').replaceAll(']','');
    time = d4[1];
    print(d2);
    print(d3);
    print(d4);
    // print(widget.date);
    // print(widget.event);
  }
  @override
  void initState() {
    getdataFromTBCarlendar();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.deepPurpleAccent,
        animatedIcon: AnimatedIcons.menu_close,
        overlayColor: Colors.black,
        overlayOpacity: 0.2,
        children: [
          SpeedDialChild(
            backgroundColor: Colors.deepPurpleAccent,
            child: Icon(Ionicons.hourglass_outline,size: 30,color: Colors.white,),
            label: 'โอที',
            labelStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context){
                    return DocOTPage();
                  })
              );
            }
          ),
          SpeedDialChild(
              backgroundColor: Colors.deepPurpleAccent,
              child: Icon(Icons.edit_calendar_outlined,size: 30,color: Colors.white,),
              label: 'ลางาน',
              labelStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context){
                      return DocLAPage();
                    })
                );
              }
          ),
          SpeedDialChild(
              backgroundColor: Colors.deepPurpleAccent,
              child: Icon(Icons.more_time_outlined,size: 30,color: Colors.white,),
              label: 'เพิ่มเวลา',
              labelStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context){
                      return DocAddTimesPage();
                    })
                );
              }
          ),
          SpeedDialChild(
              backgroundColor: Colors.deepPurpleAccent,
              child:  Icon(MaterialCommunityIcons.calendar_clock,size: 30,color: Colors.white,),
              label: 'เปลี่ยนวันหยุด',
              labelStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context){
                      return DocChangeHolidayPage();
                    })
                );
              }
          ),
          SpeedDialChild(
              backgroundColor: Colors.deepPurpleAccent,
              child: Icon(MaterialCommunityIcons.table_clock,size: 30,color: Colors.white,),
              label: 'เปลี่ยนกะ',
              labelStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context){
                      return DocChangeKaPage();
                    })
                );
              }
          )
        ],
      ),
      // appBar: AppBar(
      //   title: const Text("ตารางเวลาการทำงาน"),
      //   centerTitle: true,
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
      //     ),
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 30.0,left: 10.0,right: 10.0,bottom: 10.0),
          child: Column(
            children: [
              Card(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 10,left: 10,bottom: 10,right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:  [
                            Row(
                              children:[
                                Text("สถานะ : ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.black),),
                                Text("${status}",style: TextStyle(fontSize: 16,color: Colors.black),),
                              ],
                            ),
                            Row(
                              children:[
                                Text("วันที่ : ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.black),),
                                Text("${Dates}",style: TextStyle(fontSize: 16,color: Colors.black),),
                              ],
                            ),
                            Row(
                              children:[
                                Text("กะ : ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.black),),
                                Text("${ka} ${time}",style: TextStyle(fontSize: 16,color: Colors.black),),
                              ],
                            ),
                            Row(
                              children: [
                                Text("เวลาทำงาน : ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.black),),
                                Text("${time}",style: TextStyle(fontSize: 16,color: Colors.black),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                elevation: 3,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.transparent)
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
