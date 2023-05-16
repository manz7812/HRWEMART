import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:geira_icons/geira_icons.dart';
import 'package:http/http.dart' hide MultipartFile;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:index/pages/widjet/function.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/url.dart';
import '../../widjet/popupAlert.dart';

var globalContext;

class MainDocLa extends StatefulWidget {
  const MainDocLa({Key? key}) : super(key: key);

  @override
  State<MainDocLa> createState() => _MainDocLaState();
}

class _MainDocLaState extends State<MainDocLa> {
  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Prompt',
      ),
      home: DocLAPage(),
    );
  }
}

class DocLAPage extends StatefulWidget {
  const DocLAPage({Key? key}) : super(key: key);

  @override
  State<DocLAPage> createState() => _DocLAPageState();
}

class _DocLAPageState extends State<DocLAPage> {
  String? selectedListLa;
  List ListLa = [];

  Future<Null> listLA() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token") ?? "";
    String Url = pathurl.listLa;
    final response =
        await get(Uri.parse(Url), headers: {"Authorization": "Bearer $token"});
    print(response.statusCode);
    var data = jsonDecode(response.body.toString());
    setState(() {
      ListLa = data["data"];
      print(ListLa);
    });
  }

  File? file;
  late DateTime dateTime;
  bool loading = false;
  bool isEnable = false;
  late TextEditingController controller;

  DateTime? startdateTime;
  DateTime? enddateTime;
  TextEditingController _Startdatetime = TextEditingController();
  TextEditingController _Enddatetime = TextEditingController();
  TextEditingController _EnddatetimeFull = TextEditingController();
  TextEditingController _detial = TextEditingController();
  TextEditingController _numday = TextEditingController();
  TextEditingController day = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  int? halfID;
  String timeStart = "";
  String timeEnd = "";
  String? selectHalfDay;

  List HalfDay = [];

  Future<Null> leaveformat() async {
    String url = pathurl.leaveformat;
    final response = await get(Uri.parse(url));
    var data = jsonDecode(response.body.toString());
    HalfDay = data['data'];
    print(HalfDay);
  }

  Future<DateTime?> pickStartDate(BuildContext context) async {
    var initialDate = DateTime.now();
    var firstDate = DateTime(DateTime.now().year - 5);
    var lastDate = DateTime(DateTime.now().year + 5);
    var BA = BeAf!.substring(0, 1);
    var BANum = BeAf!.substring(1, BeAf!.length);

    print(BANum);

    if (BA == "A") {
      ///ย้อนหลัง
      initialDate = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day - int.parse(BANum));
      firstDate = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day - int.parse(BANum));
      lastDate = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day - int.parse(BANum));

      ///วัน ปจบ

      var dt = DateFormat.EEEE('th').format(initialDate);
      print(dt);
      print(WHD);
      WHD.forEach((element) {
        if (element == dt) {
          initialDate = DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day - int.parse(BANum) - int.parse(BANum));
          firstDate = DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day - int.parse(BANum) - int.parse(BANum));
          lastDate = DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day - int.parse(BANum) - int.parse(BANum));
          print(initialDate);
        }
      });
    } else if (BA == "B") {
      ////ล่วงหน้า
      initialDate = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day + int.parse(BANum));

      ///วัน ปจบ
      firstDate = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day + int.parse(BANum));
      lastDate = DateTime(
          DateTime.now().year,
          DateTime.now().month + int.parse(BANum),
          DateTime.now().day + int.parse(BANum));
    } else {
      initialDate = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);

      ///วัน ปจบ
      firstDate = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
      lastDate = DateTime(
          DateTime.now().year, DateTime.now().month + 1, DateTime.now().day);
    }

    DateTime? newdate = await showDatePicker(
        context: context,
        helpText: 'เลือกวันที่',
        confirmText: 'ตกลง',
        cancelText: 'ยกเลิก',
        locale: Locale('th'),
        initialDate: startdateTime = initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        // currentDate: DateTime.now(),
        initialEntryMode: DatePickerEntryMode.calendar,
        initialDatePickerMode: DatePickerMode.day,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
              primary: Colors.deepPurpleAccent,
              onSurface: Colors.grey,
            )),
            child: child!,
          );
        });

    if (newdate == null) {
      print('ไม่ได้เลือกวันที่');
    } else {
      print('เลือกวันที่เรียบร้อย');

      var i = DateFormat(DateFormat.WEEKDAY, 'th').format(newdate);
      print(i);
      print(WHD);
      WHD.forEach((element) {
        print(element);
        if (element == i) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            dismissOnTouchOutside: false,
            // dialogBackgroundColor: Colors.orange,
            borderSide: BorderSide(color: Colors.grey, width: 2),
            width: 350,
            buttonsBorderRadius: BorderRadius.all(Radius.circular(20)),
            headerAnimationLoop: false,
            animType: AnimType.SCALE,
            // autoHide: Duration(seconds: 3),
            // dialogBackgroundColor: Colors.deepPurpleAccent,
            title: 'ไม่สามารถทำรายการได้',
            desc: 'เนื่องจากเป็นวันหยุดพนักงาน',
            showCloseIcon: false,
            btnOkText: "ตกลง",
            btnOkOnPress: () {
              _Startdatetime.clear();
              _EnddatetimeFull.clear();
            },
          ).show();
        } else {
          startdateTime = newdate;
          getTime(i);
        }
      });

      return newdate;
    }
  }

  List WHD = [];
  Future<Null> weekHoliday() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token") ?? "";
    String url = pathurl.weekHoliday;
    final response =
        await get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
    var data = jsonDecode(response.body.toString());
    WHD = data['data'];
    // print(WHD);
  }

  List YHD = [];
  Future<Null> yearHoliday() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token") ?? "";
    String url = pathurl.yearHoliday;
    final response =
        await get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
    var data = jsonDecode(response.body.toString());
    data['data'].forEach((element) {
      YHD.add(element['date']);
    });
    // print(YHD);
  }

  List dateArray = [];
  Future<DateTime?> pickEndDate(BuildContext context) async {
    var initialDate = DateTime.now();
    var firstDate = DateTime(DateTime.now().year - 5);
    var lastDate = DateTime(DateTime.now().year + 5);

    print(BeAf!.length);
    var BA = BeAf!.substring(0, 1);
    var BANum = BeAf!.substring(1, BeAf!.length);

    print(BANum);

    if (BA == "A") {
      ///ย้อนหลัง
      initialDate = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day - int.parse(BANum));
      firstDate = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day - int.parse(BANum));
      lastDate = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day - int.parse(BANum));

      ///วัน ปจบ

      var dt = DateFormat.EEEE('th').format(initialDate);
      print(dt);
      print(WHD);
      WHD.forEach((element) {
        if (element == dt) {
          initialDate = DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day - int.parse(BANum) - int.parse(BANum));
          firstDate = DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day - int.parse(BANum) - int.parse(BANum));
          lastDate = DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day - int.parse(BANum) - int.parse(BANum));
          print(initialDate);
        }
      });
    } else if (BA == "B") {
      ////ล่วงหน้า
      initialDate = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day + int.parse(BANum));

      ///วัน ปจบ
      firstDate = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day + int.parse(BANum));
      lastDate = DateTime(
          DateTime.now().year,
          DateTime.now().month + int.parse(BANum),
          DateTime.now().day + int.parse(BANum));
    } else {
      print("1");
      initialDate = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);

      ///วัน ปจบ
      firstDate = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
      lastDate = DateTime(
          DateTime.now().year, DateTime.now().month + 2, DateTime.now().day);
    }

    DateTime? newdate = await showDatePicker(
        context: context,
        helpText: 'เลือกวันที่',
        confirmText: 'ตกลง',
        cancelText: 'ยกเลิก',
        locale: Locale('th'),
        initialDate: enddateTime = initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        currentDate: DateTime.now(),
        initialEntryMode: DatePickerEntryMode.calendar,
        initialDatePickerMode: DatePickerMode.day,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
              primary: Colors.deepPurpleAccent,
              onSurface: Colors.grey,
            )),
            child: child!,
          );
        });

    if (newdate == null) {
      print('ไม่ได้เลือกวันที่');
    } else {
      print('เลือกวันที่เรียบร้อย');
      enddateTime = newdate;
      var diff = enddateTime!.difference(startdateTime!).inDays + 1;
      print("D.${diff}");

      // var s = DateTime(2022,07,06);
      // var e = DateTime(2022,07,29);
      // var d = e.difference(s).inDays;
      // print("d.${d}");

      var DOW = List.generate(diff, (index) => index)
          .map((value) => DateFormat(DateFormat.WEEKDAY, 'th')
              .format(startdateTime!.add(Duration(days: value))))
          .toList();
      var DOY = List.generate(diff, (index) => index)
          .map((value) => DateFormat("dd/MM/yyyy")
              .format(startdateTime!.add(Duration(days: value))))
          .toList();
      print(DOW);
      print(DOY);
      int i = 0;
      if (proviso == "true") {
        i = 0;
      } else {
        print("whd.${WHD}");
        DOW.forEach((element) {
          for (var a = 0; a < WHD.length; a++) {
            if (WHD[a] == element) {
              DOY.removeAt(a);
              i++;
            }
          }
        });
        // WHD.forEach((element) {
        //   for(var a =0; a < DOW.length; a++){
        //     if(DOW[a] == element){
        //       DOY.removeAt(a);
        //       i++;
        //     }
        //   }
        // });
        dateArray = DOY;
        YHD.forEach((element) {
          for (var a = 0; a < DOY.length; a++) {
            if (DOY[a] == element) {
              dateArray.removeAt(a);
              i++;
            }
          }
        });
      }

      var total = DOW.length - i;
      day.text = total.toString();
      return newdate;
    }
  }

  String? fileImage;
  String? BeAf;
  String? proviso;
  int? quota;
  dynamic Myquota;
  Future<Null> setFile(item) async {
    ListLa.forEach((element) {
      if (element['ID'].toString() == item) {
        fileImage = element['file'];
        BeAf = element['ifelse'];
        proviso = element['proviso'];
        quota = element['quota']['total'];
        Myquota = element['quota']['remain'];
        if (quota == 0) {
          selectedListLa = null;
          AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            dismissOnTouchOutside: false,
            // dialogBackgroundColor: Colors.orange,
            borderSide: BorderSide(color: Colors.grey, width: 2),
            width: 350,
            buttonsBorderRadius: BorderRadius.all(Radius.circular(20)),
            headerAnimationLoop: false,
            animType: AnimType.SCALE,
            // autoHide: Duration(seconds: 3),
            // dialogBackgroundColor: Colors.deepPurpleAccent,
            title: 'คุณยังไม่ได้รับสิทธิ์',
            desc: 'เนื่องจากคุณยังทำงานไม่ครบ 1 ปี',
            showCloseIcon: false,
            btnOkText: "ตกลง",
            btnOkOnPress: () {
              selectedListLa = null;
              _Startdatetime.clear();
              _EnddatetimeFull.clear();
              _detial.clear();
              selectHalfDay = null;
              day.clear();
              file = null;
            },
          ).show();
          // print('ยังไม่ได้สิท');
        } else {
          if (Myquota == 0) {
            selectedListLa = null;
            AwesomeDialog(
              context: context,
              dialogType: DialogType.WARNING,
              dismissOnTouchOutside: false,
              // dialogBackgroundColor: Colors.orange,
              borderSide: BorderSide(color: Colors.grey, width: 2),
              width: 350,
              buttonsBorderRadius: BorderRadius.all(Radius.circular(20)),
              headerAnimationLoop: false,
              animType: AnimType.SCALE,
              // autoHide: Duration(seconds: 3),
              // dialogBackgroundColor: Colors.deepPurpleAccent,
              title: 'คุณใช้สิทธิ์ครบแล้ว',
              desc: 'กรุณาเลือกรายการใหม่',
              showCloseIcon: false,
              btnOkText: "ตกลง",
              btnOkOnPress: () {
                selectedListLa = null;
                _Startdatetime.clear();
                _EnddatetimeFull.clear();
                _detial.clear();
                selectHalfDay = null;
                day.clear();
                file = null;
              },
            ).show();
            print('สิทหมด');
          }
        }
      }
    });
  }

  Future<Null> selecImg(ImageSource source) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxHeight: 500,
        maxWidth: 500,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  String? dateNow;
  String token = "";
  String? status;
  List statusWork = [];
  Future<Null> getDataHeader() async {
    var nows = DateTime.now();
    // dateNow = DateFormat('dd/MM/yyyy').format(nows);
    dateNow = DateFormat.yMMMEd().format(nows);
    var myUTCTime = DateTime.utc(2022, DateTime.june, 5);
    var WD = DateFormat.E('en').format(nows);
    print(WD);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token") ?? "";
    String url = pathurl.settingHoliday;
    final response =
        await get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      // print(data['data']);
      if (data['data'].isNotEmpty) {
        switch (WD) {
          case "Mon":
            if (data['data']['mon_day'] == "วันหยุด") {
              print('1');
            } else {
              status = data['data']['mon_day'];
            }
            break;
          case "Tue":
            if (data['data']['tue_day'] == "วันหยุด") {
              print('2');
            } else {
              status = data['data']['tue_day'];
            }
            break;
          case "Wed":
            if (data['data']['wed_day'] == "วันหยุด") {
              print('3');
            } else {
              status = data['data']['wed_day'];
            }
            break;
          case "Thu":
            if (data['data']['thu_day'] == "วันหยุด") {
              print('4');
            } else {
              status = data['data']['thu_day'];
            }
            break;
          case "Fri":
            if (data['data']['fri_day'] == "วันหยุด") {
              print('5');
            } else {
              status = data['data']['fri_day'];
            }
            break;
          case "Sat":
            if (data['data']['sat_day'] == "วันหยุด") {
              print('6');
            } else {
              status = data['data']['sat_day'];
            }
            break;
          case "Sun":
            if (data['data']['sun_day'] == "วันหยุด") {
              status = data['data']['sun_day'];
              print('7');
              setState(() {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.WARNING,
                  dismissOnTouchOutside: false,
                  // dialogBackgroundColor: Colors.orange,
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                  width: 350,
                  buttonsBorderRadius: BorderRadius.all(Radius.circular(20)),
                  headerAnimationLoop: false,
                  animType: AnimType.SCALE,
                  // autoHide: Duration(seconds: 3),
                  // dialogBackgroundColor: Colors.deepPurpleAccent,
                  title: 'ไม่สามารถทำรายการได้',
                  desc: 'เนื่องจากเป็นวันหยุดพนักงาน',
                  showCloseIcon: false,
                  btnOkText: "ตกลง",
                  btnOkOnPress: () {
                    Navigator.pop(globalContext);
                  },
                ).show();
              });
            } else {
              status = data['data']['sun_day'];
            }
            break;
        }
      } else {
        status = "ยังไม่มีการตั้งค่าวันทำงาน";
        AwesomeDialog(
          context: context,
          dialogType: DialogType.INFO_REVERSED,
          dismissOnTouchOutside: false,
          // dialogBackgroundColor: Colors.orange,
          borderSide: BorderSide(color: Colors.black12, width: 2),
          width: 350,
          buttonsBorderRadius: BorderRadius.all(Radius.circular(20)),
          headerAnimationLoop: false,
          animType: AnimType.SCALE,
          showCloseIcon: false,
          // dialogBackgroundColor: Colors.deepPurpleAccent,
          title: 'ตั้งค่าสถานะวันทำงาน',
          desc: 'กรุณาติดต่อ HR',
          btnOkText: "ตกลง",
          btnCancelText: "ยกเลิก",
          btnOkOnPress: () {
            Navigator.pop(globalContext);
          },
        ).show();
      }
    } else if (response.statusCode == 401) {
      popup().sessionexpire(context);
    }
  }

  Future<Null> getTime(ka) async {
    print(listKA);
    if (ka.isNotEmpty) {
      switch (ka) {
        case "วันจันทร์":
          if (halfID == 1) {
            var time = listKA[0]['name'].split(" ")[2];
            timeStart = time.split("-")[0];
            timeEnd = time.split("-")[1];
          } else if (halfID == 2) {
            var time = listKA[0]['name'].split(" ")[2];
            timeStart = time.split("-")[0];
            var newdate = DateFormat('yyyy-MM-dd').format(startdateTime!);
            var today = DateTime.parse("${newdate} ${timeStart}");
            var i2 = today.add(Duration(hours: 4));
            var i3 = DateFormat("HH:mm").format(i2);
            timeEnd = i3.toString();
          } else {
            var time = listKA[0]['name'].split(" ")[2];
            timeEnd = time.split("-")[1];
            var newdate = DateFormat('yyyy-MM-dd').format(startdateTime!);
            var today = DateTime.parse("${newdate} ${timeEnd}");
            var i2 = today.add(Duration(hours: -4));
            var i3 = DateFormat("HH:mm").format(i2);
            timeStart = i3.toString();
          }

          break;
        case "วันอังคาร":
          if (halfID == 1) {
            var time = listKA[1]['name'].split(" ")[2];
            timeStart = time.split("-")[0];
            timeEnd = time.split("-")[1];
          } else if (halfID == 2) {
            var time = listKA[0]['name'].split(" ")[2];
            timeStart = time.split("-")[0];
            var newdate = DateFormat('yyyy-MM-dd').format(startdateTime!);
            var today = DateTime.parse("${newdate} ${timeStart}");
            var i2 = today.add(Duration(hours: 4));
            var i3 = DateFormat("HH:mm").format(i2);
            timeEnd = i3.toString();
          } else {
            var time = listKA[1]['name'].split(" ")[2];
            timeEnd = time.split("-")[1];
            var newdate = DateFormat('yyyy-MM-dd').format(startdateTime!);
            var today = DateTime.parse("${newdate} ${timeEnd}");
            var i2 = today.add(Duration(hours: -4));
            var i3 = DateFormat("HH:mm").format(i2);
            timeStart = i3.toString();
          }
          break;
        case "วันพุธ":
          if (halfID == 1) {
            var time = listKA[2]['name'].split(" ")[2];
            timeStart = time.split("-")[0];
            timeEnd = time.split("-")[1];
          } else if (halfID == 2) {
            var time = listKA[0]['name'].split(" ")[2];
            timeStart = time.split("-")[0];
            var newdate = DateFormat('yyyy-MM-dd').format(startdateTime!);
            var today = DateTime.parse("${newdate} ${timeStart}");
            var i2 = today.add(Duration(hours: 4));
            var i3 = DateFormat("HH:mm").format(i2);
            timeEnd = i3.toString();
          } else {
            var time = listKA[2]['name'].split(" ")[2];
            timeEnd = time.split("-")[1];
            var newdate = DateFormat('yyyy-MM-dd').format(startdateTime!);
            var today = DateTime.parse("${newdate} ${timeEnd}");
            var i2 = today.add(Duration(hours: -4));
            var i3 = DateFormat("HH:mm").format(i2);
            timeStart = i3.toString();
          }
          break;
        case "วันพฤหัสบดี":
          if (halfID == 1) {
            var time = listKA[3]['name'].split(" ")[2];
            timeStart = time.split("-")[0];
            timeEnd = time.split("-")[1];
          } else if (halfID == 2) {
            var time = listKA[0]['name'].split(" ")[2];
            timeStart = time.split("-")[0];
            var newdate = DateFormat('yyyy-MM-dd').format(startdateTime!);
            var today = DateTime.parse("${newdate} ${timeStart}");
            var i2 = today.add(Duration(hours: 4));
            var i3 = DateFormat("HH:mm").format(i2);
            timeEnd = i3.toString();
          } else {
            var time = listKA[3]['name'].split(" ")[2];
            timeEnd = time.split("-")[1];
            var newdate = DateFormat('yyyy-MM-dd').format(startdateTime!);
            var today = DateTime.parse("${newdate} ${timeEnd}");
            var i2 = today.add(Duration(hours: -4));
            var i3 = DateFormat("HH:mm").format(i2);
            timeStart = i3.toString();
          }
          break;
        case "วันศุกร์":
          if (halfID == 1) {
            var time = listKA[4]['name'].split(" ")[2];
            timeStart = time.split("-")[0];
            timeEnd = time.split("-")[1];
          } else if (halfID == 2) {
            var time = listKA[0]['name'].split(" ")[2];
            timeStart = time.split("-")[0];
            var newdate = DateFormat('yyyy-MM-dd').format(startdateTime!);
            var today = DateTime.parse("${newdate} ${timeStart}");
            var i2 = today.add(Duration(hours: 4));
            var i3 = DateFormat("HH:mm").format(i2);
            timeEnd = i3.toString();
          } else {
            var time = listKA[4]['name'].split(" ")[2];
            timeEnd = time.split("-")[1];
            var newdate = DateFormat('yyyy-MM-dd').format(startdateTime!);
            var today = DateTime.parse("${newdate} ${timeEnd}");
            var i2 = today.add(Duration(hours: -4));
            var i3 = DateFormat("HH:mm").format(i2);
            timeStart = i3.toString();
          }
          break;
        case "วันเสาร์":
          if (halfID == 1) {
            var time = listKA[5]['name'].split(" ")[2];
            timeStart = time.split("-")[0];
            timeEnd = time.split("-")[1];
          } else if (halfID == 2) {
            var time = listKA[5]['name'].split(" ")[2];
            timeStart = time.split("-")[0];
            var newdate = DateFormat('yyyy-MM-dd').format(startdateTime!);
            var today = DateTime.parse("${newdate} ${timeStart}");
            var i2 = today.add(Duration(hours: 4));
            var i3 = DateFormat("HH:mm").format(i2);
            timeEnd = i3.toString();
          } else {
            var time = listKA[5]['name'].split(" ")[2];
            timeEnd = time.split("-")[1];
            var newdate = DateFormat('yyyy-MM-dd').format(startdateTime!);
            var today = DateTime.parse("${newdate} ${timeEnd}");
            var i2 = today.add(Duration(hours: -4));
            var i3 = DateFormat("HH:mm").format(i2);
            timeStart = i3.toString();
          }
          break;
        case "วันอาทิตย์":
          if (halfID == 1) {
            var time = listKA[6]['name'].split(" ")[2];
            timeStart = time.split("-")[0];
            timeEnd = time.split("-")[1];
          } else if (halfID == 2) {
            var time = listKA[6]['name'].split(" ")[2];
            timeStart = time.split("-")[0];
            var newdate = DateFormat('yyyy-MM-dd').format(startdateTime!);
            var today = DateTime.parse("${newdate} ${timeStart}");
            var i2 = today.add(Duration(hours: 4));
            var i3 = DateFormat("HH:mm").format(i2);
            timeEnd = i3.toString();
          } else {
            var time = listKA[6]['name'].split(" ")[2];
            timeEnd = time.split("-")[1];
            var newdate = DateFormat('yyyy-MM-dd').format(startdateTime!);
            var today = DateTime.parse("${newdate} ${timeEnd}");
            var i2 = today.add(Duration(hours: -4));
            var i3 = DateFormat("HH:mm").format(i2);
            timeStart = i3.toString();
          }
          break;
      }
    } else {
      return;
    }
  }

  String? Ka;
  List listKA = [];
  Future<Null> getDataKa() async {
    var nows = DateTime.now();
    var myUTCTime = DateTime.utc(2022, DateTime.june, 5);
    var WD = DateFormat.E('en').format(nows);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token") ?? "";
    String url = pathurl.settingWKa;
    final response =
        await get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      if (data['data'].isNotEmpty) {
        listKA = data['data'];
        switch (WD) {
          case "Mon":
            Ka = data['data'][0]['name'];
            break;
          case "Tue":
            Ka = data['data'][1]['name'];
            break;
          case "Wed":
            Ka = data['data'][2]['name'];
            break;
          case "Thu":
            Ka = data['data'][3]['name'];
            break;
          case "Fri":
            Ka = data['data'][4]['name'];
            break;
          case "Sat":
            Ka = data['data'][5]['name'];
            break;
          case "Sun":
            Ka = data['data'][6]['name'];
            break;
        }
      } else {
        return;
      }
    } else if (response.statusCode == 401) {
      popup().sessionexpire(context);
    }
  }

  Future<Null> senddata() async {
    var enddate;
    switch (halfID) {
      case 1:
        enddate = DateFormat('yyyy-MM-dd').format(enddateTime!) + " $timeEnd";
        break;
      case 2:
        enddate = DateFormat('yyyy-MM-dd').format(startdateTime!) + " $timeEnd";
        break;
      case 3:
        enddate = DateFormat('yyyy-MM-dd').format(startdateTime!) + " $timeEnd";
        break;
    }

    Random random = Random();
    int i = random.nextInt(1000000);
    String nameIMG = 'wemart$i';
    FormData formData = FormData.fromMap({
      'rl_img': fileImage == "true"
          ? await MultipartFile.fromFile(
              file!.path,
              filename: nameIMG,
              contentType: MediaType('image', 'jpg'),
            )
          : null,
      'leave_type': selectedListLa,
      'leave_format': halfID,
      'rl_date_start': _Startdatetime.text =
          DateFormat('yyyy-MM-dd').format(startdateTime!) + " $timeStart",
      'rl_date_end': enddate,
      'rl_num': halfID != 1 ? 0.5 : day.text,
      'rl_details': _detial.text,
      'rl_datearray': dateArray.join(","),
    });
    String url = pathurl.dataLaById;
    var response = await Dio().post(url,
        data: formData,
        options: Options(headers: {"Authorization": "Bearer $token"}));
    print(response.statusCode);
    if (response.statusCode == 201) {
      context.loaderOverlay.hide();
      AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        dismissOnTouchOutside: false,
        // dialogBackgroundColor: Colors.orange,
        borderSide: BorderSide(color: Colors.green, width: 2),
        width: 350,
        buttonsBorderRadius: BorderRadius.all(Radius.circular(20)),
        headerAnimationLoop: false,
        animType: AnimType.SCALE,
        // autoHide: Duration(seconds: 3),
        // dialogBackgroundColor: Colors.deepPurpleAccent,
        title: 'บันทึกข้อมูลสำเร็จ',
        showCloseIcon: false,
        btnOkText: "ตกลง",
        btnOkOnPress: () {
          Navigator.pop(globalContext);
        },
      ).show();
      // Future.delayed(const Duration(seconds: 4),(){
      //   Navigator.of(context).pop();
      // });
    } else if (response.statusCode == 401) {
      popup().sessionexpire(context);
    } else if (response.statusCode == 403) {
      setState(() {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.INFO_REVERSED,
          dismissOnTouchOutside: false,
          // dialogBackgroundColor: Colors.orange,
          borderSide: BorderSide(color: Colors.black12, width: 2),
          width: 350,
          buttonsBorderRadius: BorderRadius.all(Radius.circular(20)),
          headerAnimationLoop: false,
          animType: AnimType.SCALE,
          showCloseIcon: false,
          // dialogBackgroundColor: Colors.deepPurpleAccent,
          title: 'บันทึกข้อมูลไม่สำเร็จ',
          desc: 'เนื่องจากไม่มีการตั้งค่าผู้อนุมัติ\nติดต่อHR',
          btnOkText: "ตกลง",
          btnCancelText: "ยกเลิก",
          btnOkOnPress: () {
            Navigator.pop(globalContext);
          },
        ).show();
      });
    } else {
      setState(() {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.INFO_REVERSED,
          dismissOnTouchOutside: false,
          // dialogBackgroundColor: Colors.orange,
          borderSide: BorderSide(color: Colors.black12, width: 2),
          width: 350,
          buttonsBorderRadius: BorderRadius.all(Radius.circular(20)),
          headerAnimationLoop: false,
          animType: AnimType.SCALE,
          showCloseIcon: false,
          // dialogBackgroundColor: Colors.deepPurpleAccent,
          title: 'บันทึกข้อมูลไม่สำเร็จ',
          desc: 'กรุณาลองใหม่อีกครั้ง',
          btnOkText: "ตกลง",
          btnCancelText: "ยกเลิก",
          btnOkOnPress: () {
            Navigator.pop(globalContext);
          },
        ).show();
      });
    }
    // await Dio().post(url,data: formData).then((value){
    //   var data = jsonDecode(value.toString());
    //   print(value);
    // });
    // final response = await post(
    //   Uri.parse(url),
    //   headers: {"Authorization": "Bearer $token"},
    //   body: data,
    // );
  }

  @override
  void initState() {
    listLA();
    getDataHeader();
    getDataKa();
    weekHoliday();
    yearHoliday();
    leaveformat();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        loading = true;
      });
    });
    _detial.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _Startdatetime.dispose();
    _EnddatetimeFull.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = double.infinity;
    double height = double.infinity;

    // DateTime selectedDate = DateTime.now();
    // String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          title: const Text("ขอลางาน"),
          leading: IconButton(
            onPressed: () {
              // Navigator.of(pageContext).pop();
              Navigator.pop(globalContext);
              // Navigator.pop(context);
              // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => InsertDocLAPage(),), (route) => route.isFirst);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          centerTitle: true,
          elevation: 0,
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
        body: loading
            ? LoaderOverlay(
                useDefaultLoading: false,
                overlayWidget: Center(
                  child: LoadingAnimationWidget.threeArchedCircle(
                      color: Colors.deepPurpleAccent, size: 50),
                ),
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    child: Form(
                      key: _key,
                      child: Column(
                        children: [
                          Card(
                            child: Container(
                              width: double.infinity,
                              // height: 200,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      // Text("วันที่ : ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.black),),
                                      Text(
                                        "${dateNow?.split(' ')[0] ?? ""} "
                                        "${dateNow?.split(' ')[1] ?? ""} "
                                        "${dateNow?.split(' ')[2] ?? ""} "
                                        "${int.parse(dateNow?.split(' ')[3] ?? "")}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "สถานะ : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        "${status ?? ""}",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  // Expanded(
                                  //   flex: 0,
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.center,
                                  //     children: <Widget>[
                                  //       Text("กะ : ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.black),),
                                  //       // Text("${Ka.split(' ')[0].split(':')[0]} : ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.black),),
                                  //       Text("${Ka?.split(' ')[1].split('[')[1].split("]")[0] ??"" } "
                                  //           "${Ka?.split(' ')[2] ??"ยังไม่มีการตั้งค่ากะ"}",
                                  //         style: TextStyle(fontSize: 16,color: Colors.black),),
                                  //     ],
                                  //   ),
                                  // ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, bottom: 4.0),
                                    alignment: Alignment.topLeft,
                                    child: const Text(
                                      "ประเภทการลา",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  DropdownButtonFormField<String>(
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      color: Colors.grey.shade700,
                                    ),
                                    value: selectedListLa,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedListLa = value as String;
                                        print(selectedListLa);
                                        _Startdatetime.clear();
                                        _EnddatetimeFull.clear();
                                        _Enddatetime.clear();
                                        _detial.clear();
                                        selectHalfDay = null;
                                        day.clear();
                                        file = null;
                                        setFile(selectedListLa);
                                      });
                                    },
                                    validator: (value) =>
                                        (selectedListLa == '' ||
                                                selectedListLa == null)
                                            ? ''
                                            : null,
                                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: selectedListLa != null
                                                ? Colors.green
                                                : Colors.red,
                                            width: 2.0),
                                      ),
                                      border: OutlineInputBorder(
                                          // borderSide: const BorderSide(color: Colors.green, width: 2.0),
                                          ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: selectedListLa != null
                                                ? Colors.green
                                                : Colors.red,
                                            width: 2.0),
                                      ),
                                    ),
                                    items: ListLa.map((valueItem) {
                                      return DropdownMenuItem<String>(
                                          value: valueItem['ID'].toString(),
                                          child: Text(
                                              valueItem['name'].toString()));
                                    }).toList(),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  quota == null ? const SizedBox() : La01(),
                                  Column(
                                    children: HalfDay.map((t) =>
                                        RadioListTile<String>(
                                            contentPadding: EdgeInsets.zero,
                                            title: Text(
                                              "${t['name']}",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            groupValue: selectHalfDay,
                                            value: t.toString(),
                                            onChanged: selectedListLa == null ||
                                                    quota == 0 ||
                                                    Myquota == 0
                                                ? null
                                                : (val) => setState(() {
                                                      selectHalfDay = val!;
                                                      _Startdatetime.clear();
                                                      _EnddatetimeFull.clear();
                                                      _Enddatetime.clear();
                                                      _detial.clear();
                                                      day.clear();
                                                      halfID = t['ID'];
                                                      print(halfID);
                                                    }))).toList(),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, bottom: 4.0),
                                    alignment: Alignment.topLeft,
                                    child: const Text(
                                      "เริ่มวันที่/เวลา",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  TextFormField(
                                    autofocus: false,
                                    // focusNode: FocusNode(),
                                    showCursor: true,
                                    readOnly: true,
                                    controller: _Startdatetime,
                                    enabled:
                                        selectHalfDay != null ? true : false,
                                    validator: (value) =>
                                        (value!.isEmpty) ? '' : null,
                                    decoration: InputDecoration(
                                      // label: Text("เลือกวันที่"),
                                      filled:
                                          selectHalfDay != null ? false : true,
                                      fillColor: Colors.grey.shade200,
                                      suffixIcon: Icon(
                                        Icons.calendar_today_outlined,
                                        color: selectHalfDay != null
                                            ? Colors.green
                                            : Colors.grey,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    onTap: () async {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      await pickStartDate(context);
                                      _Startdatetime.text =
                                          DateFormat('dd/MM/yyyy')
                                                  .format(startdateTime!) +
                                              " $timeStart";
                                      switch (halfID) {
                                        case 2:
                                          _EnddatetimeFull.text =
                                              DateFormat('dd/MM/yyyy')
                                                      .format(startdateTime!) +
                                                  " $timeEnd";
                                          break;
                                        case 3:
                                          _EnddatetimeFull.text =
                                              DateFormat('dd/MM/yyyy')
                                                      .format(startdateTime!) +
                                                  " $timeEnd";
                                          break;
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  halfID == 1
                                      ? Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 0.0, bottom: 4.0),
                                              alignment: Alignment.topLeft,
                                              child: const Text(
                                                "ถึงวันที่/เวลา",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            TextFormField(
                                              autofocus: false,
                                              // focusNode: FocusNode(),
                                              showCursor: true,
                                              readOnly: true,
                                              controller: _EnddatetimeFull,
                                              enabled:
                                                  _Startdatetime.text.isNotEmpty
                                                      ? true
                                                      : false,
                                              decoration: InputDecoration(
                                                // label: Text("เลือกวันที่"),
                                                filled: _Startdatetime
                                                        .text.isNotEmpty
                                                    ? false
                                                    : true,
                                                fillColor: Colors.grey.shade200,
                                                suffixIcon: Icon(
                                                  Icons.calendar_today_outlined,
                                                  color: _Startdatetime
                                                          .text.isNotEmpty
                                                      ? Colors.green
                                                      : Colors.grey,
                                                ),
                                                border: OutlineInputBorder(),
                                              ),
                                              onTap: () async {
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                                await pickEndDate(context);
                                                _EnddatetimeFull.text =
                                                    DateFormat('dd/MM/yyyy')
                                                            .format(
                                                                enddateTime!) +
                                                        " $timeEnd";
                                              },
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 0.0, bottom: 4.0),
                                              alignment: Alignment.topLeft,
                                              child: const Text(
                                                "จำนวนวันลา",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            TextFormField(
                                              autofocus: false,
                                              // focusNode: FocusNode(),
                                              showCursor: true,
                                              readOnly: true,
                                              controller: day,
                                              enabled: false,
                                              validator: (value) =>
                                                  (value!.isEmpty) ? '' : null,
                                              decoration: InputDecoration(
                                                // label: Text("เลือกวันที่"),
                                                filled: true,
                                                fillColor: Colors.grey.shade200,
                                                suffixIcon: Icon(
                                                  Icons.calendar_today_outlined,
                                                  color: _EnddatetimeFull
                                                          .text.isNotEmpty
                                                      ? Colors.green
                                                      : Colors.grey,
                                                ),
                                                border: OutlineInputBorder(),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                            )
                                          ],
                                        )
                                      : Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 0.0, bottom: 4.0),
                                              alignment: Alignment.topLeft,
                                              child: const Text(
                                                "ถึงวันที่/เวลา",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            TextFormField(
                                              controller: _EnddatetimeFull,
                                              autofocus: false,
                                              // focusNode: FocusNode(),
                                              showCursor: true,
                                              readOnly: true,
                                              enabled: false,
                                              decoration: InputDecoration(
                                                // label: Text("เลือกวันที่"),
                                                filled: true,
                                                fillColor: Colors.grey.shade200,
                                                suffixIcon: Icon(
                                                  Icons.calendar_today_outlined,
                                                  color: selectHalfDay != null
                                                      ? Colors.green
                                                      : Colors.grey,
                                                ),
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                          ],
                                        ),

                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, bottom: 4.0),
                                    alignment: Alignment.topLeft,
                                    child: const Text(
                                      "รายละเอียด",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _detial,
                                    // focusNode: FocusNode(),
                                    enabled: selectedListLa == null ||
                                            quota == 0 ||
                                            Myquota == 0 ||
                                            _EnddatetimeFull.text.isEmpty
                                        ? false
                                        : true,
                                    validator: (value) =>
                                        (value!.isEmpty) ? '' : null,
                                    maxLines: 6,
                                    // maxLength: 9999,
                                    decoration: InputDecoration.collapsed(
                                      filled: selectedListLa == null ||
                                              _EnddatetimeFull.text.isEmpty
                                          ? true
                                          : false,
                                      fillColor: Colors.grey.shade200,
                                      hintText: "กรุณากรอกรายละเอียด",
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade700)),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  buildIMG(),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          // padding: const EdgeInsets.only(right: 16, left: 16),
                                          // margin: EdgeInsets.all(10),
                                          // alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              // border: Border.all(
                                              //     color: Colors.grey.shade500
                                              // ),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                primary: Colors.white,
                                                // minimumSize: Size(width, 100),
                                              ),
                                              onPressed: () {
                                                Navigator.of(globalContext)
                                                    .pop();
                                              },
                                              child: Text('ยกเลิก')),
                                        ),
                                      ),
                                      selectedListLa == null
                                          ? Container()
                                          : SizedBox(
                                              width: 20,
                                            ),
                                      buildButton()
                                    ],
                                  )
                                ],
                              ),
                            ),
                            elevation: 3,
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    const BorderSide(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
                strokeWidth: 5,
              )));
  }

  Widget buildButton() {
    switch (fileImage) {
      case "true": ////ลาป่วยมีใบรับรองแพทย์
        return Expanded(
          child: Container(
            width: double.infinity,
            // padding: const EdgeInsets.only(right: 16, left: 16),
            // margin: EdgeInsets.all(10),
            // alignment: Alignment.center,
            decoration: BoxDecoration(
                // border: Border.all(
                //     color: Colors.grey.shade500
                // ),
                borderRadius: BorderRadius.circular(5)),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // backgroundColor: selectedListLa != null ? Colors.green : Colors.grey,
                  primary: Colors.green,
                  // minimumSize: Size(width, 100),
                ),
                onPressed: selectedListLa != null &&
                        _Startdatetime.text.isNotEmpty &&
                        _EnddatetimeFull.text.isNotEmpty &&
                        _detial.text.isNotEmpty &&
                        file != null
                    ? () => setState(() {
                          var myday = int.parse(day.text);
                          if (myday > quota!) {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.WARNING,
                              dismissOnTouchOutside: false,
                              // dialogBackgroundColor: Colors.orange,
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                              width: 350,
                              buttonsBorderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              headerAnimationLoop: false,
                              animType: AnimType.SCALE,
                              // autoHide: Duration(seconds: 3),
                              // dialogBackgroundColor: Colors.deepPurpleAccent,
                              title: 'ไม่สามรถทำรายการได้',
                              desc: 'เนื่องจากคุณมีสิทธิ์ลาแค่ ${quota} วัน',
                              showCloseIcon: false,
                              btnOkText: "ตกลง",
                              btnOkOnPress: () {
                                _EnddatetimeFull.clear();
                                day.clear();
                              },
                            ).show();
                          } else {
                            // print("yes");
                            context.loaderOverlay.show();
                            senddata();
                          }
                        })
                    : null,
                child: Text('ตกลง')),
          ),
        );
      case "false": ////ลาป่วยไม่มีใบรับรองแพทย์
        return Expanded(
          child: Container(
            width: double.infinity,
            // padding: const EdgeInsets.only(right: 16, left: 16),
            // margin: EdgeInsets.all(10),
            // alignment: Alignment.center,
            decoration: BoxDecoration(
                // border: Border.all(
                //     color: Colors.grey.shade500
                // ),
                borderRadius: BorderRadius.circular(5)),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // backgroundColor: selectedListLa != null ? Colors.green : Colors.grey,
                  primary: Colors.green,
                  // minimumSize: Size(width, 100),
                ),
                onPressed: selectedListLa != null &&
                        _Startdatetime.text.isNotEmpty &&
                        _EnddatetimeFull.text.isNotEmpty &&
                        _detial.text.isNotEmpty
                    ? () => setState(() {
                          var myday = int.parse(day.text);
                          if (myday > quota!) {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.WARNING,
                              dismissOnTouchOutside: false,
                              // dialogBackgroundColor: Colors.orange,
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                              width: 350,
                              buttonsBorderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              headerAnimationLoop: false,
                              animType: AnimType.SCALE,
                              // autoHide: Duration(seconds: 3),
                              // dialogBackgroundColor: Colors.deepPurpleAccent,
                              title: 'ไม่สามรถทำรายการได้',
                              desc: 'เนื่องจากคุณมีสิทธิ์ลาแค่ ${quota} วัน',
                              showCloseIcon: false,
                              btnOkText: "ตกลง",
                              btnOkOnPress: () {
                                _EnddatetimeFull.clear();
                                day.clear();
                              },
                            ).show();
                          } else {
                            // print("yes");
                            context.loaderOverlay.show();
                            senddata();
                          }
                        })
                    : null,
                child: Text('ตกลง')),
          ),
        );
      default:
        return Container();
    }
  }

  Widget buildIMG() {
    double width = double.infinity;
    switch (fileImage) {
      case "true": ////ลาป่วยมีใบรับรองแพทย์
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
              alignment: Alignment.topLeft,
              child: const Text(
                "แทรกรูปภาพ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            file == null
                ? Container(
                    width: double.infinity,
                    // padding: const EdgeInsets.only(right: 16, left: 16),
                    // margin: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: selectedListLa != null
                            ? Colors.transparent
                            : Colors.grey.shade200,
                        border: Border.all(color: Colors.grey.shade500),
                        borderRadius: BorderRadius.circular(5)),
                    child: TextButton(
                      // splashColor: Colors.transparent,
                      // highlightColor: Colors.transparent,
                      // minWidth: width,
                      // height: 100,
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        minimumSize: Size(width, 100),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            GIcons.images,
                            color: Colors.grey,
                            size: 40,
                          ),
                          Text('อัพโหลดรูปภาพ',
                              style: TextStyle(
                                color: selectedListLa != null
                                    ? Colors.blue
                                    : Colors.grey,
                              )),
                          // SizedBox(width: 10),
                        ],
                      ),
                      onPressed: selectedListLa != null
                          ? () => setState(() {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                AwesomeDialog(
                                  context: context,
                                  // dismissOnTouchOutside: false,
                                  // padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
                                  dialogType: DialogType.NO_HEADER,
                                  body: Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Ink(
                                          child: IconButton(
                                            icon: Icon(Ionicons.camera_outline),
                                            color: Colors.black87,
                                            iconSize: 50,
                                            splashRadius: 40,
                                            disabledColor: Colors.grey,
                                            onPressed: () {
                                              selecImg(ImageSource.camera);
                                            },
                                          ),
                                          // decoration: ShapeDecoration(
                                          //     color: Colors.grey,
                                          //     shape: OutlineInputBorder()
                                          // ),
                                        ),
                                        Ink(
                                          child: IconButton(
                                            icon: Icon(Ionicons.image_outline),
                                            color: Colors.black87,
                                            iconSize: 50,
                                            splashRadius: 40,
                                            disabledColor: Colors.grey,
                                            onPressed: () {
                                              selecImg(ImageSource.gallery);
                                            },
                                          ),
                                          // decoration: ShapeDecoration(
                                          //     color: Colors.grey,
                                          //     shape: OutlineInputBorder()
                                          // ),
                                        )
                                      ],
                                    ),
                                  ),
                                  // keyboardAware: false,
                                  // dialogBackgroundColor: Colors.orange,
                                  borderSide: BorderSide(
                                      color: Colors.deepPurpleAccent, width: 2),
                                  width: 300,
                                  buttonsBorderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  headerAnimationLoop: false,
                                  animType: AnimType.SCALE,
                                  autoHide: Duration(seconds: 5),
                                  // dialogBackgroundColor: Colors.deepPurpleAccent,
                                  // title: 'คุณอยู่นอกรัศมีที่กำหนด',
                                  // desc: 'กรุณาอยู่ในพื้นที่ บริษัท วิรัชทุ่งสงค้าข้าว จำกัด',
                                ).show();
                              })
                          : null,
                    ),
                  )
                : Stack(
                    children: <Widget>[
                      Image.file(file!),
                      Positioned(
                        top: 20,
                        left: 280,
                        width: 50,
                        child: Ink(
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: IconButton(
                              icon: Icon(
                                  MaterialCommunityIcons.image_edit_outline),
                              color: Colors.amber,
                              iconSize: 30,
                              splashRadius: 50,
                              disabledColor: Colors.grey,
                              onPressed: () {
                                AwesomeDialog(
                                  context: context,
                                  // dismissOnTouchOutside: false,
                                  // padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
                                  dialogType: DialogType.NO_HEADER,
                                  body: Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Ink(
                                          child: IconButton(
                                            icon: Icon(Ionicons.camera_outline),
                                            color: Colors.black87,
                                            iconSize: 50,
                                            splashRadius: 40,
                                            disabledColor: Colors.grey,
                                            onPressed: () {
                                              selecImg(ImageSource.camera);
                                            },
                                          ),
                                          // decoration: ShapeDecoration(
                                          //     color: Colors.grey,
                                          //     shape: OutlineInputBorder()
                                          // ),
                                        ),
                                        Ink(
                                          child: IconButton(
                                            icon: Icon(Ionicons.image_outline),
                                            color: Colors.black87,
                                            iconSize: 50,
                                            splashRadius: 40,
                                            disabledColor: Colors.grey,
                                            onPressed: () {
                                              selecImg(ImageSource.gallery);
                                            },
                                          ),
                                          // decoration: ShapeDecoration(
                                          //     color: Colors.grey,
                                          //     shape: OutlineInputBorder()
                                          // ),
                                        )
                                      ],
                                    ),
                                  ),
                                  // keyboardAware: false,
                                  // dialogBackgroundColor: Colors.orange,
                                  borderSide: BorderSide(
                                      color: Colors.deepPurpleAccent, width: 2),
                                  width: 300,
                                  buttonsBorderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  headerAnimationLoop: false,
                                  animType: AnimType.SCALE,
                                  autoHide: Duration(seconds: 5),
                                  // dialogBackgroundColor: Colors.deepPurpleAccent,
                                  // title: 'คุณอยู่นอกรัศมีที่กำหนด',
                                  // desc: 'กรุณาอยู่ในพื้นที่ บริษัท วิรัชทุ่งสงค้าข้าว จำกัด',
                                ).show();
                              },
                            ),
                          ),
                          // decoration: ShapeDecoration(
                          //     color: Colors.red,
                          //     shape: OutlineInputBorder()
                          // ),
                        ),
                      ),
                    ],
                  ),
          ],
        );
      case "false": ////ลาป่วยไม่มีใบรับรองแพทย์
        return Container();
      default:
        return Container();
    }
  }

  Widget La01() {
    var i = quota!;
    var iLa = Myquota!;
    var total;
    if (quota == 0) {
      total = 0.0;
    } else {
      total = iLa / i;
    }
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
      width: double.infinity,
      child: Column(
        children: [
          LinearPercentIndicator(
            animation: true,
            animationDuration: 1500,
            lineHeight: 20,
            percent: total,
            center: Text(
              "คงเหลือ ${Myquota} / ${quota} วัน",
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            progressColor: Colors.green,
            backgroundColor:
                quota == 0 && Myquota == 0 ? Colors.red : Colors.grey,
            linearStrokeCap: LinearStrokeCap.roundAll,
          ),
        ],
      ),
    );
  }
}
