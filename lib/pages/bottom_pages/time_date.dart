import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/url.dart';
import '../widjet/doc_Card.dart';
import '../widjet/popupAlert.dart';
import 'DateTimePage/calendar_time_work.dart';

DateTime get _now => DateTime.now();
class TimeDatePage extends StatefulWidget {
  const TimeDatePage({Key? key}) : super(key: key);

  @override
  _TimeDatePageState createState() => _TimeDatePageState();
}

class _TimeDatePageState extends State<TimeDatePage> with SingleTickerProviderStateMixin{

  bool loading = false;
  late AnimationController _controller;

  void getcalendar(){
    // Navigator.of(context).push(
    //     PageTransition(
    //       child: CalendarTimeWorkPage(),
    //       type: PageTransitionType.bottomToTop,
    //       alignment: Alignment.bottomCenter,
    //       duration: Duration(milliseconds: 600),
    //       reverseDuration: Duration(milliseconds: 600),
    //     )
    // );
    showModalBottomSheet(
        elevation: 0,
        enableDrag: true,
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        // builder: (context) => CalendarTimeWorkPage()
        builder: (context) => CalendarTimeWorkPage(),
        transitionAnimationController: _controller
    );
  }

  String token = "";
  Future<Null> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
    await calendartoday();

  }


  List dataCalendarToday = [];



  Future<Null> calendartoday() async {
    try{
      setState(() {
        loading = false;
      });
      String url = pathurl.eventCalendarToday;
      final response = await get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              loading = true;
            });
          });
          dataCalendarToday = data['data'];
          print(dataCalendarToday);

        });
      }else if(response.statusCode == 401){
        dataCalendarToday = [];
        popup().sessionexpire(context);
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
        });
      }
    }catch (e){
      print("e= $e");
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO_REVERSED,
        dismissOnTouchOutside: false,
        borderSide: BorderSide(color: Colors.black12, width: 2),
        width: 350,
        buttonsBorderRadius: BorderRadius.all(Radius.circular(10)),
        headerAnimationLoop: false,
        animType: AnimType.SCALE,
        showCloseIcon: false,
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

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1),(){
      setState(() {
        loading = true;
        getcalendar();
        getToken();
      });
    });
    _controller = AnimationController(
        vsync: this, // the SingleTickerProviderStateMixin
        duration: Duration(seconds: 1),
        animationBehavior: AnimationBehavior.normal,
    );

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text("ปฎิทิน"),
        // leading: IconButton(
        //   onPressed: () {
        //     // Navigator.of(pageContext).pop();
        //     // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => InsertDocLAPage(),), (route) => route.isFirst);
        //   },
        //   icon: Icon(Icons.arrow_back),
        // ),
        centerTitle: true,
        elevation: 0,
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
      body: loading ? SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 20),
              doc_WORK().show_card_img2(context,_now,dataCalendarToday),
              const SizedBox(height: 30),
              // Container(
              //   padding: const EdgeInsets.only(left: 15.0, bottom: 4.0),
              //   alignment: Alignment.centerLeft,
              //   child: const Text(
              //     "ระดับหัวหน้างาน",
              //     style: TextStyle(
              //       color: Colors.black,
              //       fontWeight: FontWeight.w600,
              //       fontSize: 16,
              //     ),
              //     textAlign: TextAlign.left,
              //   ),
              // ),
              // doc_WORK().show_doc_calendar_value_time(context),
              // doc_WORK().show_doc_check_in_check_out(context),
              // Container(
              //   padding: const EdgeInsets.only(left: 15.0,top: 15 ,bottom: 4.0),
              //   alignment: Alignment.centerLeft,
              //   child: const Text(
              //     "ระดับปฎิบัตการ",
              //     style: TextStyle(
              //       color: Colors.black,
              //       fontWeight: FontWeight.w600,
              //       fontSize: 16,
              //     ),
              //     textAlign: TextAlign.left,
              //   ),
              // ),
              // doc_WORK().show_doc_table_time_work(context),
              doc_WORK().show_doc_carlendar_time_work(context)
            ],
          ),
        ),
      )
          : const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
              strokeWidth: 5,
            )
        )
    );
  }
}
