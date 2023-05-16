import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:http/http.dart' hide MultipartFile,Response;
import 'package:index/api/url.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../api/ModelSkill.dart';
import '../../widjet/popupAlert.dart';

class DocOTPage extends StatefulWidget {
  const DocOTPage({Key? key}) : super(key: key);

  @override
  State<DocOTPage> createState() => _DocOTPageState();
}

class _DocOTPageState extends State<DocOTPage> {
  bool loading = false;
  late DateTime startdateTime;
  DateTime? dateTimeOT;
  DateTime? dateOT;
  var log = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      lineLength: 120,
      errorMethodCount: 8,
      colors: true,
      printEmojis: false,
    ),
  );

  var stringListReturnedFromApiCall = [];
  List<TextEditingController> textEditingControllers = [];

  var stringMoney = [];
  List<TextEditingController> numMoney = [];


  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  late SkillModel userModel = SkillModel(
      List<String>.empty(growable: true),
      ""
  );

  TextEditingController _dateOTText = TextEditingController();
  TextEditingController _startOTText = TextEditingController();
  TextEditingController _endOTText = TextEditingController();
  TextEditingController _detailOT = TextEditingController();
  TextEditingController amountMoney = TextEditingController();
  TextEditingController hourOT = TextEditingController();
  String? oldhourOT;
  String? newhourOT;


  List<String> selectedPO = [];
  String? selectPOS;
  List ListMasterPos =[];
  List ListPos =[];
  List ListempID = [];

  String token = "";
  String? selectedOT;
  List ListOT =[];
  dynamic rateOT;
  dynamic rateHour;

  String? timeStart;
  String? timeEnd;

  int? typeEmp;
  String? typeEmpName;
  int? typeTime;
  String? typeTimeName;
  String? event;


  Future<Null> getToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
    // await listOT();
    await KAlist();
    await getDataHeader();
    await getDataKa();
    await check2Pos();
    // await listemp();
  }

  String? selected2Pos;
  String? namePos;
  List List2Pos = [];
  Future<Null> check2Pos() async{
    String url = pathurl.secPosition;
    final response = await get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
    );

    var data = jsonDecode(response.body.toString());
    print(data['data']);
    if(response.statusCode == 200){
      List2Pos = data['data'];
      if(data['data'].length >1){
        AwesomeDialog(
          context: context,
          dialogType: DialogType.QUESTION,
          dismissOnTouchOutside: false,
          dismissOnBackKeyPress: false,
          // dialogBackgroundColor: Colors.orange,
          borderSide: BorderSide(color: Colors.green, width: 2),
          width: 400,
          buttonsBorderRadius: BorderRadius.all(Radius.circular(20)),
          headerAnimationLoop: false,
          animType: AnimType.SCALE,
          // autoHide: Duration(seconds: 3),
          // dialogBackgroundColor: Colors.deepPurpleAccent,
          body: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  child: Text("กรุณาเลือกตำแหน่ง"),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: DropdownButtonFormField<String>(
                    focusNode: FocusNode(),
                    icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                    value: selected2Pos,
                    onChanged: (value) {
                      setState(() {
                        selected2Pos = value;
                      });
                    },
                    validator: (value) => (selected2Pos == '' || selected2Pos == null)
                        ? ''
                        : null,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      filled: false,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(),
                    ),
                    items: List2Pos.map((valueItem) {
                      return DropdownMenuItem<String>(
                          value: valueItem['pos_id'].toString(),child: Text(valueItem['pos_name'].toString())
                      );
                    }).toList(),

                  ),
                ),
              ],
            ),
          ),
          showCloseIcon: false,
          btnOkText: "ตกลง",
          btnOkOnPress: () {
            if(selected2Pos != null){
              List2Pos.forEach((element) {
                if(selected2Pos == element['pos_id']){
                  setState(() {
                    namePos = element['pos_name'];
                  });
                }
              });
            }else{
              Navigator.of(context).pop();
            }

          },
        ).show();
      }else{
        print(data['data']);
        setState(() {
          namePos = data['data'][0]['pos_name'];
        });
      }


    }else if(response.statusCode == 401){
      popup().sessionexpire(context);
      List2Pos = [];
    }
    else{
      setState(() {
        List2Pos = [];
      });
    }
  }

  Future<Null> listOT(index)async{

    String url = pathurl.listOT;
    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    // ListOT = data['data'];
    ListOT = [];
    data['data'].forEach((item){
      if(index == 0){
        if(item['type'] == "รายเดือน" || item['type'] == "" || item['type'] == null){
          ListOT.add(item);
        }
      }else{
        if(item['type'] == "รายวัน" || item['type'] == "" || item['type'] == null){
          ListOT.add(item);
        }
      }
    });
    log.i(ListOT);
    setState(() {
      typeEmp = index;
    });
  }

  String? selectedKa;
  List ListKa =[];
  Future<Null> KAlist()async{
    String url = pathurl.listKA;
    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    ListKa = data['data'];
    // print(WHD);
  }

  bool popupalert = false;
  Future<Null> listemp2(date)async{
    print("${date}");
    String url = pathurl.listEmpOT+"?pos_id=$selected2Pos&date=${date}&emp_type=$typeEmpName&event=$event&wc_id=$selectedKa";

    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    log.i(data["data"],"data");

    if(data["data"].isNotEmpty){
      popupalert = false;
    }else{
      popupalert = true;
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
        title: 'ไม่พบพนักงาน',
        desc: 'กรุณาทำรายการใหม่อีกครั้ง',
        showCloseIcon: false,
        btnOkText: "ตกลง",
        btnOkOnPress: () {
          _startOTText.clear();
          _endOTText.clear();
        },
      ).show();
    }

    // log.i(popupalert,"alert");
    ListPos = [
      {"id": "00", "name": "", "pos_id": "00", "pos_name": "กรุณาเลือกตำแหน่ง"}
    ];
    ListMasterPos = data["data"];
    data["data"].forEach((item){
      var jason = {"id": "${item['id']}", "name": "${item['name']}", "pos_id": "${item['pos_id']}", "pos_name": "${item['pos_name']}"};
      ListPos.add(jason);
    });

    ListPos.forEach((element) {
      stringListReturnedFromApiCall.add(element['id'].toString());
      stringMoney.add(element['id'].toString());
    });

    setState(() {
      stringListReturnedFromApiCall.forEach((str) {
        var textEditingController = TextEditingController(text: "");
        textEditingControllers.add(textEditingController);
        // selectedPO = [];
        selectedPO.add(ListPos[0]['id']);
      });
      stringMoney.forEach((element) {
        var text = TextEditingController(text: "");
        numMoney.add(text);
      });
    });
    // print(ListMasterPos);
    // log.i(ListMasterPos);
    // print(stringListReturnedFromApiCall);
    // print(WHD);
  }

  String? dateNow;
  String? status;
  List statusWork = [];
  Future<Null> getDataHeader() async{
    var nows = DateTime.now();
    // dateNow = DateFormat('dd/MM/yyyy').format(nows);
    dateNow = DateFormat.yMMMEd().format(nows);
    var myUTCTime = DateTime.utc(2022, DateTime.june, 5);
    var WD = DateFormat.E('en').format(nows);
    print(WD);
    String url = pathurl.settingHoliday;
    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
      // print(response.statusCode);
      if(data['data'].isNotEmpty){
        switch(WD){
          case "Mon" :
            if(data['data']['mon_day'] == "วันหยุด"){
              print('1');
            }else{
              status = data['data']['mon_day'];
            }
            break;
          case "Tue" :
            if(data['data']['tue_day'] == "วันหยุด"){
              print('2');
            }else{
              status = data['data']['tue_day'];
            }
            break;
          case "Wed" :
            if(data['data']['wed_day'] == "วันหยุด"){
              print('3');
            }else{
              status = data['data']['wed_day'];
            }
            break;
          case "Thu" :
            if(data['data']['thu_day'] == "วันหยุด"){
              print('4');
            }else{
              status = data['data']['thu_day'];
            }
            break;
          case "Fri" :
            if(data['data']['fri_day'] == "วันหยุด"){
              print('5');
            }else{
              status = data['data']['fri_day'];
            }
            break;
          case "Sat" :
            if(data['data']['sat_day'] == "วันหยุด"){
              print('6');
            }else{
              status = data['data']['sat_day'];
            }
            break;
          case "Sun" :
            if(data['data']['sun_day'] == "วันหยุด"){
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
                    Navigator.pop(context);
                  },
                ).show();
              });
            }else{
              status = data['data']['sun_day'];
            }
            break;
        }
      }else{
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
            Navigator.pop(context);
          },
        ).show();
      }

    }else if(response.statusCode == 401){
      popup().sessionexpire(context);
    }

  }

  String? Ka;
  List listKA = [];
  Future<Null> getDataKa() async{
    var nows = DateTime.now();
    var myUTCTime = DateTime.utc(2022, DateTime.june, 5);
    var WD = DateFormat.E('en').format(nows);

    String url = pathurl.settingWKa;
    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
      if(data['data'].isNotEmpty){
        listKA = data['data'];
        switch(WD){
          case "Mon":
            Ka = data['data'][0]['name'];
            break;
          case "Tue" :
            Ka = data['data'][1]['name'];
            break;
          case "Wed" :
            Ka = data['data'][2]['name'];
            break;
          case "Thu" :
            Ka = data['data'][3]['name'];
            break;
          case "Fri" :
            Ka = data['data'][4]['name'];
            break;
          case "Sat" :
            Ka = data['data'][5]['name'];
            break;
          case "Sun" :
            Ka = data['data'][6]['name'];
            break;
        }
      }else{
        return;
      }
    }else if(response.statusCode == 401){
      // popup().sessionexpire(context);
    }

  }


  Future<DateTime?> pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    DateTime? newdate = await showDatePicker(
        context: context,
        helpText: 'เลือกวันที่',
        confirmText: 'ตกลง',
        cancelText: 'ยกเลิก',
        initialDate: initialDate,
        firstDate: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day),
        lastDate: DateTime(DateTime.now().year,DateTime.now().month+2,DateTime.now().day),
        currentDate: DateTime.now(),
        initialEntryMode: DatePickerEntryMode.calendar,
        initialDatePickerMode: DatePickerMode.day,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
                colorScheme:  const ColorScheme.light(
                  primary: Colors.deepPurpleAccent,
                  onSurface: Colors.grey,
                )
            ),
            child: child!,
          );
        });

    if (newdate == null){
      print('ไม่ได้เลือกวันที่');
      var datot = DateFormat('yyyy-MM-dd').format(initialDate);
      var dt = DateTime.parse(datot);
      dateOT = dt;
      if(typeTimeName == "เต็มวัน"){
        listemp2("${DateFormat('yyyy-MM-dd').format(initialDate)} ${timeStart}");
      }else{

      }

    }else{
      print('เลือกวันที่เรียบร้อย');
      dateOT = newdate;
      // print("${DateFormat('yyyy-MM-dd').format(newdate)} ${timeEnd}");
      if(typeEmpName == "รายเดือน"){
        if(typeTimeName == "เต็มวัน"){
          listemp2("${DateFormat('yyyy-MM-dd').format(newdate)} ${timeStart}");
        }else if(selectedOT == "3" && typeTimeName == "ชั่วโมง"){
          listemp2("${DateFormat('yyyy-MM-dd').format(newdate)} ${timeStart}");
        }else{
          listemp2("${DateFormat('yyyy-MM-dd').format(newdate)} ${timeEnd}");
        }
      }else{
        if(typeTimeName == "เต็มวัน"){
          listemp2("${DateFormat('yyyy-MM-dd').format(newdate)} ${timeStart}");
        }else if(selectedOT == "2" && typeTimeName == "ชั่วโมง"){
          listemp2("${DateFormat('yyyy-MM-dd').format(newdate)} ${timeStart}");
        }else{
          listemp2("${DateFormat('yyyy-MM-dd').format(newdate)} ${timeEnd}");
        }
      }

    }
    return newdate;
  }


  Future startPickDateTimeOT(BuildContext context) async {
    final date = await startPickDateOT(context);
    if (date == null) return;

    final time = await endpickTimeOT(context);
    if (time == null) return;

    setState(() {
      dateTimeOT = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  String? clerTxT;
  void clertxt(){
    setState(() {
      _endOTText.clear();
      hourOT.clear();
      oldhourOT = null;
    });
  }

  Future<DateTime?> startPickDateOT(BuildContext context) async {
    final initialDate = DateTime.now();
    DateTime? newdate = await showDatePicker(
        context: context,
        helpText: 'เลือกวันที่',
        confirmText: 'ตกลง',
        cancelText: 'ยกเลิก',
        initialDate: initialDate,
        firstDate: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day),
        lastDate: DateTime(DateTime.now().year,DateTime.now().month+2,DateTime.now().day),
        currentDate: DateTime.now(),
        initialEntryMode: DatePickerEntryMode.calendar,
        initialDatePickerMode: DatePickerMode.day,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
                colorScheme:  const ColorScheme.light(
                  primary: Colors.deepPurpleAccent,
                  onSurface: Colors.grey,
                )
            ),
            child: child!,
          );
        });

    if (newdate == null){
      print('ไม่ได้เลือกวันที่');
      clertxt();
      // _endOTText.clear();

    }else{
      print('เลือกวันที่เรียบร้อย');
      return newdate;
    }
  }

  Future<TimeOfDay?> endpickTimeOT(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    TimeOfDay? newtime = await showTimePicker(
      context: context,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
              alwaysUse24HourFormat: true),
          child: child!,
        );
      },
      initialTime: dateTimeOT != null
          // ? TimeOfDay(hour: dateTimeOT.hour, minute: dateTimeOT.minute)
          ? TimeOfDay(
          hour: typeEmpName == "รายเดือน"
            ? selectedOT == "3"
            ? typeTimeName == "ชั่วโมง"
            ? int.parse(timeStart!.split(":")[0])
            : int.parse(timeStart!.split(":")[0])
            : int.parse(timeEnd!.split(":")[0])
            : int.parse(timeStart!.split(":")[0]),
          minute: typeEmpName == "รายเดือน"
              ? selectedOT == "3"
              ? typeTimeName == "ชั่วโมง"
              ? int.parse(timeStart!.split(":")[1])
              : int.parse(timeStart!.split(":")[1])
              : int.parse(timeEnd!.split(":")[1])
              : int.parse(timeEnd!.split(":")[1]),
          )
          : initialTime,
    );

    if (newtime == null){
      print('ไม่ได้เลือกเวลา');
    }else{
      print('เลือกเวลาเรียบร้อย');
      if(typeEmpName == "รายเดือน"){
        if(selectedOT =="3"){
          if(typeTimeName == "ชั่วโมง"){
            if(newtime.hour > int.parse(timeStart!.split(":")[0])){
              if(newtime.minute == 00 || newtime.minute == 15 || newtime.minute == 30 || newtime.minute == 45){
                print("success1");
                clerTxT = null;
              }else{
                clerTxT = "val";
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
                  autoHide: Duration(seconds: 3),
                  // dialogBackgroundColor: Colors.deepPurpleAccent,
                  title: 'ไม่สามารถทำรายการได้',
                  desc: 'กรุณาเลือกช่วงเวลา(นาที)ใหม่',
                  showCloseIcon: false,
                  btnOkText: "ตกลง",
                  // btnOkOnPress: () {
                  //   // _startOTText.clear();
                  //   _endOTText.clear();
                  //   hourOT.clear();
                  //   oldhourOT = null;
                  // },
                ).show();
              }
            }else{
              print("un success");
              FocusScope.of(context).requestFocus(FocusNode());
              clerTxT = "val";
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
                autoHide: Duration(seconds: 3),
                // dialogBackgroundColor: Colors.deepPurpleAccent,
                title: 'ไม่สามารถทำรายการได้',
                desc: 'กรุณาเลือกช่วงเวลา(ชั่วโมง)ใหม่',
                showCloseIcon: false,
                btnOkText: "ตกลง",
                // btnOkOnPress: () {
                //   // _startOTText.clear();
                //   _endOTText.clear();
                //   hourOT.clear();
                //   oldhourOT = null;
                // },
              ).show();
            }
          }else{
            if(newtime.hour > int.parse(timeEnd!.split(":")[0])){
              if(newtime.minute == 00 || newtime.minute == 15 || newtime.minute == 30 || newtime.minute == 45){
                print("success1");
                clerTxT = null;
              }else{
                clerTxT = "val";
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
                  autoHide: Duration(seconds: 3),
                  // dialogBackgroundColor: Colors.deepPurpleAccent,
                  title: 'ไม่สามารถทำรายการได้',
                  desc: 'กรุณาเลือกช่วงเวลา(นาที)ใหม่',
                  showCloseIcon: false,
                  btnOkText: "ตกลง",
                ).show();
              }
            }else{
              FocusScope.of(context).requestFocus(FocusNode());
              clerTxT = "val";
              print("un success");
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
                autoHide: Duration(seconds: 3),
                // dialogBackgroundColor: Colors.deepPurpleAccent,
                title: 'ไม่สามารถทำรายการได้',
                desc: 'กรุณาเลือกช่วงเวลา(ชั่วโมง)ใหม่',
                showCloseIcon: false,
                btnOkText: "ตกลง",

              ).show();
            }
          }
        }else{
          if(newtime.hour > int.parse(timeEnd!.split(":")[0])){
            if(newtime.minute == 00 || newtime.minute == 15 || newtime.minute == 30 || newtime.minute == 45){
              print("success1");
              clerTxT = null;
            }else{
              clerTxT = "val";
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
                autoHide: Duration(seconds: 3),
                // dialogBackgroundColor: Colors.deepPurpleAccent,
                title: 'ไม่สามารถทำรายการได้',
                desc: 'กรุณาเลือกช่วงเวลา(นาที)ใหม่',
                showCloseIcon: false,
                btnOkText: "ตกลง",
              ).show();
            }
          }else{
            FocusScope.of(context).requestFocus(FocusNode());
            clerTxT = "val";
            print("un success");
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
              autoHide: Duration(seconds: 3),
              // dialogBackgroundColor: Colors.deepPurpleAccent,
              title: 'ไม่สามารถทำรายการได้',
              desc: 'กรุณาเลือกช่วงเวลา(ชั่วโมง)ใหม่',
              showCloseIcon: false,
              btnOkText: "ตกลง",

            ).show();
          }
        }
      }else{
        if(selectedOT =="2"){
          if(typeTimeName == "ชั่วโมง"){
            if(newtime.hour > int.parse(timeStart!.split(":")[0])){
              if(newtime.minute == 00 || newtime.minute == 15 || newtime.minute == 30 || newtime.minute == 45){
                print("success1");
                clerTxT = null;
              }else{
                clerTxT = "val";
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
                  autoHide: Duration(seconds: 3),
                  // dialogBackgroundColor: Colors.deepPurpleAccent,
                  title: 'ไม่สามารถทำรายการได้',
                  desc: 'กรุณาเลือกช่วงเวลา(นาที)ใหม่',
                  showCloseIcon: false,
                  btnOkText: "ตกลง",
                  // btnOkOnPress: () {
                  //   // _startOTText.clear();
                  //   _endOTText.clear();
                  //   hourOT.clear();
                  //   oldhourOT = null;
                  // },
                ).show();
              }
            }else{
              print("un success");
              FocusScope.of(context).requestFocus(FocusNode());
              clerTxT = "val";
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
                autoHide: Duration(seconds: 3),
                // dialogBackgroundColor: Colors.deepPurpleAccent,
                title: 'ไม่สามารถทำรายการได้',
                desc: 'กรุณาเลือกช่วงเวลา(ชั่วโมง)ใหม่',
                showCloseIcon: false,
                btnOkText: "ตกลง",
                // btnOkOnPress: () {
                //   // _startOTText.clear();
                //   _endOTText.clear();
                //   hourOT.clear();
                //   oldhourOT = null;
                // },
              ).show();
            }
          }else{
            if(newtime.hour > int.parse(timeEnd!.split(":")[0])){
              if(newtime.minute == 00 || newtime.minute == 15 || newtime.minute == 30 || newtime.minute == 45){
                print("success1");
                clerTxT = null;
              }else{
                clerTxT = "val";
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
                  autoHide: Duration(seconds: 3),
                  // dialogBackgroundColor: Colors.deepPurpleAccent,
                  title: 'ไม่สามารถทำรายการได้',
                  desc: 'กรุณาเลือกช่วงเวลา(นาที)ใหม่',
                  showCloseIcon: false,
                  btnOkText: "ตกลง",
                ).show();
              }
            }else{
              FocusScope.of(context).requestFocus(FocusNode());
              clerTxT = "val";
              print("un success");
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
                autoHide: Duration(seconds: 3),
                // dialogBackgroundColor: Colors.deepPurpleAccent,
                title: 'ไม่สามารถทำรายการได้',
                desc: 'กรุณาเลือกช่วงเวลา(ชั่วโมง)ใหม่',
                showCloseIcon: false,
                btnOkText: "ตกลง",

              ).show();
            }
          }
        }else{
          if(newtime.hour > int.parse(timeEnd!.split(":")[0])){
            if(newtime.minute == 00 || newtime.minute == 15 || newtime.minute == 30 || newtime.minute == 45){
              print("success1");
              clerTxT = null;
            }else{
              clerTxT = "val";
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
                autoHide: Duration(seconds: 3),
                // dialogBackgroundColor: Colors.deepPurpleAccent,
                title: 'ไม่สามารถทำรายการได้',
                desc: 'กรุณาเลือกช่วงเวลา(นาที)ใหม่',
                showCloseIcon: false,
                btnOkText: "ตกลง",
              ).show();
            }
          }else{
            FocusScope.of(context).requestFocus(FocusNode());
            clerTxT = "val";
            print("un success");
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
              autoHide: Duration(seconds: 3),
              // dialogBackgroundColor: Colors.deepPurpleAccent,
              title: 'ไม่สามารถทำรายการได้',
              desc: 'กรุณาเลือกช่วงเวลา(ชั่วโมง)ใหม่',
              showCloseIcon: false,
              btnOkText: "ตกลง",

            ).show();
          }
        }
      }



      return newtime;
    }
  }

  Future<Null> senddata() async{
    try{
      String jsonTags = jsonEncode(ListempID);

      FormData formData = FormData.fromMap({
        "ot_emp_type": typeEmpName,
        "ot_type": selectedOT,
        "ot_time_format": typeTimeName,
        "ot_wage": amountMoney.text,
        "wc_id": selectedKa,
        "ot_date_start": DateFormat("dd/MM/yyyy HH:mm").parse(_startOTText.text),
        "ot_date_end": DateFormat("dd/MM/yyyy HH:mm").parse(_endOTText.text),
        "ot_total_hours": hourOT.text,
        "ot_emp": jsonTags,
        "ot_details": _detailOT.text,
        "pos_id": selected2Pos,
      });
      // print(formData.fields);
      String url = pathurl.sendDOT;
      final response = await Dio().post(
          url,
          data: formData,
          options: Options(
              headers: {"Authorization": "Bearer $token"}
          )
      );
      log.i(response.statusCode);
      if(response.statusCode == 201){
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
            Navigator.pop(context);
          },
        ).show();
        // Future.delayed(const Duration(seconds: 4),(){
        //   Navigator.of(context).pop();
        // });
      }

    }on DioError catch(e){
      print(e.response?.data);
      if(e.response?.statusCode == 401){
        popup().sessionexpire(context);
      }else if(e.response?.statusCode == 403){
        var er = e.response?.data;
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
            body: Container(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Column(
                children: [
                  Text("บันทึกข้อมูลไม่สำเร็จ",style: TextStyle(color: Colors.red,fontSize: 22),),
                  Container(
                      alignment: Alignment.centerLeft,
                      child: Text("เนื่องจากวันที่ ${_startOTText.text.split(" ")[0]}",style: TextStyle(fontSize: 15),)),
                  Container(
                      alignment: Alignment.centerLeft,
                      child: Text("คุณได้ทำการขอโอทีให้กับพนักงาน : ",style: TextStyle(fontSize: 15),)),
                  Text(
                    "${er['message'].toString().replaceAll('[', '').replaceAll(']','')}",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.green
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                      child: Text("เรียบร้อยแล้ว",style: TextStyle(fontSize: 15))),
                ],
              ),
            ),
            btnOkText: "ตกลง",
            btnCancelText: "ยกเลิก",
            btnOkOnPress: () {
              // Navigator.pop(context);
            },
          ).show();
        });
      }
      else{
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
              Navigator.pop(context);
            },
          ).show();
        });
      }
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

  void caltime(){
    var st = DateFormat("dd/MM/yyyy HH:mm").parse(_startOTText.text);
    var en = DateFormat("dd/MM/yyyy HH:mm").parse(_endOTText.text);
    print(st);
    print(en);
    print(DateUtils.dateOnly(st));
  }

  @override
  void initState() {
    getToken();
    var now = DateTime.now();
    final _oTStartH = 17;
    final _oTStartM = 00;
    final _oTEndH = 18;
    final _oTEndM = 00;
    startdateTime = DateTime(now.year,now.month,now.day,_oTStartH,_oTStartM);
    dateTimeOT = DateTime(now.year,now.month,now.day,_oTEndH,_oTEndM);
    Future.delayed(const Duration(seconds: 1),(){
      setState(() {
        loading = true;
        // stringListReturnedFromApiCall.forEach((str) {
        //   var textEditingController = TextEditingController(text: "");
        //   textEditingControllers.add(textEditingController);
        //   selectedPO.add(ListPos[0]['id']);
        //   // selectedPO.add('str');
        // });
        // stringMoney.forEach((element) {
        //   var text = TextEditingController(text: "");
        //   numMoney.add(text);
        // });
      });
    });
    _detailOT.addListener(() {
      setState(() {

      });
    });
    userModel.otherskill.add("");
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text("ขอโอที"),
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.of(pageContext).pop();
        //     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => InsertDocLAPage(),), (route) => route.isFirst);
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
      body: loading ? LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: LoadingAnimationWidget.threeArchedCircle(
              color: Colors.deepPurpleAccent, size: 50),
        ),
        child: Form(
          key: globalFormKey,
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
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
                              Text("${dateNow?.split(' ')[0]??""} "
                                  "${dateNow?.split(' ')[1]??""} "
                                  "${dateNow?.split(' ')[2]??""} "
                                  "${int.parse(dateNow?.split(' ')[3]?? "")}",
                                style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black),),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget> [
                              Text("สถานะ : ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.black),),
                              Text("${status??""}",style: TextStyle(fontSize: 16,color: Colors.black),),
                            ],
                          ),
                          Expanded(
                            flex: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("กะ : ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.black),),
                                // Text("${Ka.split(' ')[0].split(':')[0]} : ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.black),),
                                Text("${Ka?.split(' ')[1].split('[')[1].split("]")[0] ??"" } "
                                    "${Ka?.split(' ')[2] ??"ยังไม่มีการตั้งค่ากะ"}",
                                  style: TextStyle(fontSize: 16,color: Colors.black),),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget> [
                              Text( namePos == null ? " ": "ตำแหน่ง : ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.black),),
                              Text("${namePos??""}",style: TextStyle(fontSize: 16,color: Colors.black),),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 4.0, bottom: 10.0),
                            alignment: Alignment.topLeft,
                            child: const Text(
                              "ประเภทพนักงาน",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: ToggleSwitch(
                              minWidth: 90.0,
                              minHeight: 30.0,
                              cornerRadius: 20.0,
                              activeBgColors: [
                                [Colors.green], [Colors.green]
                              ] ,
                              activeFgColor: Colors.white,
                              inactiveBgColor: Colors.grey,
                              inactiveFgColor: Colors.white,
                              initialLabelIndex: typeEmp,
                              totalSwitches: 2,
                              labels: ['รายเดือน', 'รายวัน'],
                              radiusStyle: true,
                              onToggle: (index) {
                                listOT(index);
                                if(index == 0){
                                  typeEmpName = "รายเดือน";
                                }else{
                                  typeEmpName = "รายวัน";
                                }

                                selectedOT = null;
                                selectedKa = null;
                                typeTimeName = null;
                                _startOTText.clear();
                                _endOTText.clear();
                                hourOT.clear();
                                _detailOT.clear();
                                ListPos = [];
                                stringListReturnedFromApiCall.clear();
                                stringMoney.clear();
                                ListempID.clear();
                                textEditingControllers.clear();
                                numMoney.clear();
                                // setState(() {
                                //   typeEmp = index;
                                //   listOT(typeEmp);
                                // });
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          buildForm(),
                        ],
                      ),
                    ),
                    elevation: 3,
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Colors.white)
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      )
          :const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
              strokeWidth: 5,)
        )
    );
  }

  Widget buildForm(){
    double width = double.infinity;
    switch(typeEmp){
      case 0: ////รายเดือน
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
              alignment: Alignment.topLeft,
              child: const Text(
                "ประเภทโอที",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            DropdownButtonFormField<String>(
              icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
              value: selectedOT,
              onChanged: (value) {
                setState(() {
                  selectedOT = value as String;
                });

                ListOT.forEach((element) {
                  if(element['ID'] == double.parse(value!)){
                    rateOT = element['rate'];
                    event = element['event'];
                  }
                });
                print(event);
                if(selectedOT == "3"){
                  typeTime = null;
                }else{
                  typeTime = 0;
                  typeTimeName = "ชั่วโมง";
                }


              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: ListOT.map((valueItem) {
                return DropdownMenuItem<String>(
                    value: valueItem['ID'].toString(),child: Text(valueItem['name'])
                );
              }).toList(),
            ),
            // const SizedBox(
            //   height: 20,
            // ),
            selectedOT == "5"
            ? Container(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: TextFormField(
                controller: amountMoney,
                autofocus: false,
                // focusNode: FocusNode(),
                showCursor: true,
                readOnly: false,
                keyboardType: TextInputType.number,
                // controller: _startOTText,
                validator: (value) => (value!.isEmpty) ? '' : null,
                decoration: const InputDecoration(
                  // filled: true,
                  // fillColor: Colors.grey.shade300,
                  label: Text("กรุณากรอกจำนวนเงิน"),
                  suffixIcon: Icon(
                    MaterialCommunityIcons.cash_usd_outline,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            )
            : Container(),
            const SizedBox(
              height: 20,
            ),
            selectedOT == null || selectedOT == "5"
            ? const SizedBox()
            : Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "รูปแบบเวลา",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  alignment: Alignment.centerLeft,
                  child: ToggleSwitch(
                      minWidth: 90.0,
                      minHeight: 30.0,
                      cornerRadius: 20.0,
                      activeBgColors: selectedOT == "3"
                          ?[
                        [Colors.green], [Colors.green]
                      ]
                          :[
                        [Colors.green], [Colors.green]
                      ],
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      initialLabelIndex: typeTime,
                      totalSwitches: selectedOT == "3" ? 2 : 1,
                      labels: selectedOT == "3" ?  ['เต็มวัน', 'ชั่วโมง'] : ['ชั่วโมง'],
                      radiusStyle: true,
                      onToggle: selectedOT == "3"
                          ? (index){
                        setState(() {
                          typeTime = index;
                          if(index == 0){
                            typeTimeName ="เต็มวัน";
                          }else{
                            typeTimeName = "ชั่วโมง";
                          }
                          print(typeTimeName);
                          FocusScope.of(context).requestFocus(FocusNode());
                          // selectedKa = null;
                          // typeTimeName = null;
                          _startOTText.clear();
                          _endOTText.clear();
                          hourOT.clear();
                          _detailOT.clear();
                          ListPos = [];
                          stringListReturnedFromApiCall.clear();
                          stringMoney.clear();
                          ListempID.clear();
                          textEditingControllers.clear();
                          numMoney.clear();
                        });
                      }
                          : null
                  ),
                ),
              ],
            ),

            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "กะ",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                DropdownButtonFormField<String>(
                  focusNode: FocusNode(),
                  icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                  value: selectedKa,
                  onChanged: typeTimeName != null ?(value) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    setState(() {
                      selectedKa = value as String;
                    });
                    ListKa.forEach((element) {
                      if(element['ID'] == selectedKa){
                        timeStart = element['time_in'];
                        timeEnd = element['time_out'];
                      }
                    });
                  } : null,
                  validator: (value) => (selectedKa == '' || selectedKa == null)
                      ? ''
                      : null,
                  decoration: InputDecoration(
                    filled: typeTimeName != null ? false : true,
                    fillColor: Colors.grey.shade300,
                    border: OutlineInputBorder(),
                  ),
                  items: ListKa.map((valueItem) {
                    return DropdownMenuItem<String>(
                        value: valueItem['ID'].toString(),child: Text("${valueItem['time_in']}-${valueItem['time_out']}")
                    );
                  }).toList(),
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
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
                  controller: _startOTText,
                  validator: (value) => (value!.isEmpty) ? '' : null,
                  decoration:  InputDecoration(
                    filled: selectedKa == null ? true : false,
                    fillColor: Colors.grey.shade300,
                    // label: Text("เลือกวันที่"),
                    suffixIcon: Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  onTap: selectedKa !=null ? () async{
                    FocusScope.of(context).requestFocus(FocusNode());
                    await pickDate(context);
                    if(typeTimeName == "เต็มวัน"){
                      _startOTText.text = DateFormat('dd/MM/yyyy').format(dateOT!) +" ${timeStart}";
                      _endOTText.text = DateFormat('dd/MM/yyyy').format(dateOT!) +" ${timeEnd}";
                      await Future.delayed(const Duration(milliseconds: 200));
                      setState(() {
                        hourOT.text = "8";
                      });

                    }else if(selectedOT == "3" && typeTimeName == "ชั่วโมง"){
                      _startOTText.text = DateFormat('dd/MM/yyyy').format(dateOT!) +" ${timeStart}";
                    }else{
                      _startOTText.text = DateFormat('dd/MM/yyyy').format(dateOT!) +" ${timeEnd}";
                    }

                    // await startPickDateTimeOT(context);
                    // _startOTText.text = DateFormat('dd/MM/yyyy HH:mm').format(dateTimeOT);
                  } : null,
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "สิ้นสุดวันที่/เวลา",
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
                  enabled: _startOTText.text.isEmpty ? false : true,
                  showCursor: true,
                  readOnly: true,
                  controller: _endOTText,
                  validator: (value) => (value!.isEmpty) ? '' : null,
                  decoration: InputDecoration(
                    filled: _startOTText.text.isEmpty ? true : false,
                    fillColor: Colors.grey.shade300,
                    // label: Text("เลือกวันที่"),
                    suffixIcon: Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  onTap: typeTimeName == "เต็มวัน"
                      ? null :
                      () async {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    await startPickDateTimeOT(context);
                    _endOTText.text = DateFormat('dd/MM/yyyy HH:mm').format(dateTimeOT!);

                    // print("hot.${calculateOT(_startOTText.text, _endOTText)}");
                    if(clerTxT == null){
                      calculateOT(_startOTText.text, _endOTText.text);
                    }else{
                      clertxt();
                    }

                    // hourOT.text = hot;
                  },
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
              alignment: Alignment.topLeft,
              child: const Text(
                "ชั่วโมงโอที",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            oldhourOT == null || double.parse("${oldhourOT}") <2
            ?const SizedBox()
            :Container(
                padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
                alignment: Alignment.centerLeft,
                child: Text("*จากเดิม ${oldhourOT} ชม."
                  ,style: TextStyle(color: Colors.red),)
            ),
            TextFormField(
              autofocus: false,
              // focusNode: FocusNode(),
              enabled: false,
              showCursor: true,
              readOnly: true,
              controller: hourOT,
              validator: (value) => (value!.isEmpty) ? '' : null,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade300,
                // label: Text("เลือกวันที่"),
                suffixIcon: Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            hourOT.text.isNotEmpty
            ? empUI()
            : const SizedBox(),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
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
              autofocus: false,
              // focusNode: FocusNode(),
              controller: _detailOT,
              // enabled: selectedStatus != null ? true : false,
              validator: (value) => (value!.isEmpty) ? '' : null,
              maxLines: 6,
              // maxLength: 9999,
              decoration: InputDecoration.collapsed(
                hintText: "กรุณากรอกรายละเอียด",
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade900,width: 2.0)
                ),
              ),

            ),
            const SizedBox(
              height: 10,
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
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          // minimumSize: Size(width, 100),
                        ),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: Text('ยกเลิก')),
                  ),
                ),
                const SizedBox(width: 20,),
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
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // backgroundColor: Colors.green,
                          backgroundColor: Colors.green,
                          // minimumSize: Size(width, 100),
                        ),
                        onPressed: selectedOT != null &&
                            selectedKa != null &&
                            _startOTText.text.isNotEmpty &&
                            _endOTText.text.isNotEmpty &&
                            hourOT.text.isNotEmpty &&
                            ListempID.isNotEmpty &&
                            _detailOT.text.isNotEmpty
                            ?(){
                          FocusScope.of(context).requestFocus(FocusNode());
                          final form = globalFormKey.currentState;
                          if (form!.validate()) {
                            form.save();
                            if(selectedOT == "5"){
                              var sum = int.parse(amountMoney.text);
                              num total = ListempID.fold(0, (result, item) => result+int.parse(item["num"]));
                              print("Total: $total");
                              if(sum == total){
                                print("ok");
                                senddata();
                              }else{
                                print("no ok");
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
                                  title: 'ไม่สมารถทำรายการได้',
                                  desc: 'เนื่องจากโอทีเหมาจ่ายรวม\nไม่เท่ากันกับยอดเงินรวมพนักงาน',
                                  showCloseIcon: false,
                                  btnOkText: "ตกลง",
                                  btnOkOnPress: () {

                                  },
                                ).show();
                              }
                            }else{
                              // context.loaderOverlay.show();
                              senddata();

                            }
                          }


                          // print("ok.${ListempID}");
                          // context.loaderOverlay.show();
                          // senddata();
                        } :null,
                        child: Text('บันทึก')),
                  ),
                ),
              ],
            )
          ],
        );
      case 1: ////รายวัน
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
              alignment: Alignment.topLeft,
              child: const Text(
                "ประเภทโอที",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            DropdownButtonFormField<String>(
              icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
              value: selectedOT,
              onChanged: (value) {
                setState(() {
                  selectedOT = value as String;
                });

                ListOT.forEach((element) {
                  if(element['ID'] == double.parse(value!)){
                    rateOT = element['rate'];
                    event = element['event'];
                  }
                });
                print(event);
                if(selectedOT == "2"){
                  typeTime = null;
                }else{
                  typeTime = 0;
                  typeTimeName = "ชั่วโมง";
                }


              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: ListOT.map((valueItem) {
                return DropdownMenuItem<String>(
                    value: valueItem['ID'].toString(),child: Text(valueItem['name'])
                );
              }).toList(),
            ),
            // const SizedBox(
            //   height: 20,
            // ),
            selectedOT == "5"
            ? Container(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: TextFormField(
                controller: amountMoney,
                autofocus: false,
                // focusNode: FocusNode(),
                showCursor: true,
                readOnly: false,
                keyboardType: TextInputType.number,
                // controller: _startOTText,
                validator: (value) => (value!.isEmpty) ? '' : null,
                decoration: const InputDecoration(
                  // filled: true,
                  // fillColor: Colors.grey.shade300,
                  label: Text("กรุณากรอกจำนวนเงิน"),
                  suffixIcon: Icon(
                    MaterialCommunityIcons.cash_usd_outline,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            )
            : Container(),
            const SizedBox(
              height: 20,
            ),
            selectedOT == null || selectedOT == "5"
            ? const SizedBox()
            : Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "รูปแบบเวลา",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  alignment: Alignment.centerLeft,
                  child: ToggleSwitch(
                      minWidth: 90.0,
                      minHeight: 30.0,
                      cornerRadius: 20.0,
                      activeBgColors: selectedOT == "2"
                          ?[
                        [Colors.green], [Colors.green]
                      ]
                          :[
                        [Colors.green], [Colors.green]
                      ],
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      initialLabelIndex: typeTime,
                      totalSwitches: selectedOT == "2" ? 2 : 1,
                      labels: selectedOT == "2" ?  ['เต็มวัน', 'ชั่วโมง'] : ['ชั่วโมง'],
                      radiusStyle: true,
                      onToggle: selectedOT == "2"
                          ? (index){
                        setState(() {
                          typeTime = index;
                          if(index == 0){
                            typeTimeName ="เต็มวัน";
                          }else{
                            typeTimeName = "ชั่วโมง";
                          }
                          print(typeTimeName);
                          FocusScope.of(context).requestFocus(FocusNode());
                          _startOTText.clear();
                          _endOTText.clear();
                          hourOT.clear();
                          oldhourOT = null;
                          _detailOT.clear();
                          ListPos = [];
                          stringListReturnedFromApiCall.clear();
                          stringMoney.clear();
                          ListempID.clear();
                          textEditingControllers.clear();
                          numMoney.clear();
                        });
                      }
                          : null
                  ),
                ),
              ],
            ),

            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "กะ",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                DropdownButtonFormField<String>(
                  focusNode: FocusNode(),
                  icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                  value: selectedKa,
                  onChanged: typeTimeName != null ?(value) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    setState(() {
                      selectedKa = value as String;
                    });
                    ListKa.forEach((element) {
                      if(element['ID'] == selectedKa){
                        timeStart = element['time_in'];
                        timeEnd = element['time_out'];
                      }
                    });
                  } : null,
                  validator: (value) => (selectedKa == '' || selectedKa == null)
                      ? ''
                      : null,
                  decoration: InputDecoration(
                    filled: typeTimeName != null ? false : true,
                    fillColor: Colors.grey.shade300,
                    border: OutlineInputBorder(),
                  ),
                  items: ListKa.map((valueItem) {
                    return DropdownMenuItem<String>(
                        value: valueItem['ID'].toString(),child: Text("${valueItem['time_in']}-${valueItem['time_out']}")
                    );
                  }).toList(),
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
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
                  controller: _startOTText,
                  validator: (value) => (value!.isEmpty) ? '' : null,
                  decoration:  InputDecoration(
                    filled: selectedKa == null ? true : false,
                    fillColor: Colors.grey.shade300,
                    // label: Text("เลือกวันที่"),
                    suffixIcon: Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  onTap: selectedKa !=null ? () async{
                    FocusScope.of(context).requestFocus(FocusNode());
                    await pickDate(context);
                    if(typeTimeName == "เต็มวัน"){
                      _startOTText.text = DateFormat('dd/MM/yyyy').format(dateOT!) +" ${timeStart}";
                      _endOTText.text = DateFormat('dd/MM/yyyy').format(dateOT!) +" ${timeEnd}";
                      await Future.delayed(const Duration(milliseconds: 200));
                      setState(() {
                        hourOT.text = "8";
                      });

                    }else if(selectedOT == "2" && typeTimeName == "ชั่วโมง"){
                      _startOTText.text = DateFormat('dd/MM/yyyy').format(dateOT!) +" ${timeStart}";
                    }else{
                      _startOTText.text = DateFormat('dd/MM/yyyy').format(dateOT!) +" ${timeEnd}";
                    }

                    // await startPickDateTimeOT(context);
                    // _startOTText.text = DateFormat('dd/MM/yyyy HH:mm').format(dateTimeOT);
                  } : null,
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "สิ้นสุดวันที่/เวลา",
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
                  enabled: _startOTText.text.isEmpty ? false : true,
                  showCursor: true,
                  readOnly: true,
                  controller: _endOTText,
                  validator: (value) => (value!.isEmpty) ? '' : null,
                  decoration: InputDecoration(
                    filled: _startOTText.text.isEmpty ? true : false,
                    fillColor: Colors.grey.shade300,
                    // label: Text("เลือกวันที่"),
                    suffixIcon: Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  onTap: typeTimeName == "เต็มวัน"
                      ? null :
                      () async {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    await startPickDateTimeOT(context);
                    _endOTText.text = DateFormat('dd/MM/yyyy HH:mm').format(dateTimeOT!);

                    if(clerTxT == null){
                      calculateOT(_startOTText.text, _endOTText.text);
                    }else{
                      clertxt();
                    }
                    // hourOT.text = hot;
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
              alignment: Alignment.topLeft,
              child: const Text(
                "ชั่วโมงโอที",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            oldhourOT == null || int.parse("${oldhourOT}") <2
            ?const SizedBox()
            :Container(
                padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
                alignment: Alignment.centerLeft,
                child: Text("*จากเดิม ${oldhourOT} ชม."
                  ,style: TextStyle(color: Colors.red),)
            ),
            TextFormField(
              autofocus: false,
              // focusNode: FocusNode(),
              enabled: false,
              showCursor: true,
              readOnly: true,
              controller: hourOT,
              validator: (value) => (value!.isEmpty) ? '' : null,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade300,
                // label: Text("เลือกวันที่"),
                suffixIcon: Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            hourOT.text.isNotEmpty
            ? empUI()
            : const SizedBox(),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
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
              autofocus: false,
              // focusNode: FocusNode(),
              controller: _detailOT,
              // enabled: selectedStatus != null ? true : false,
              validator: (value) => (value!.isEmpty) ? '' : null,
              maxLines: 6,
              // maxLength: 9999,
              decoration: InputDecoration.collapsed(
                hintText: "กรุณากรอกรายละเอียด",
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade900,width: 2.0)
                ),
              ),

            ),
            const SizedBox(
              height: 10,
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
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          // minimumSize: Size(width, 100),
                        ),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: Text('ยกเลิก')),
                  ),
                ),
                const SizedBox(width: 20,),
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
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // backgroundColor: Colors.green,
                          primary: Colors.green,
                          // minimumSize: Size(width, 100),
                        ),
                        onPressed: selectedOT != null &&
                            selectedKa != null &&
                            _startOTText.text.isNotEmpty &&
                            _endOTText.text.isNotEmpty &&
                            hourOT.text.isNotEmpty &&
                            ListempID.isNotEmpty &&
                            _detailOT.text.isNotEmpty
                            ?(){
                          FocusScope.of(context).requestFocus(FocusNode());
                          final form = globalFormKey.currentState;
                          if (form!.validate()) {
                            form.save();
                            if(selectedOT == "5"){
                              var sum = int.parse(amountMoney.text);
                              num total = ListempID.fold(0, (result, item) => result+int.parse(item["num"]));
                              print("Total: $total");
                              if(sum == total){
                                print("ok");
                                senddata();
                              }else{
                                print("no ok");
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
                                  title: 'ไม่สมารถทำรายการได้',
                                  desc: 'เนื่องจากโอทีเหมาจ่ายรวม\nไม่เท่ากันกับยอดเงินรวมพนักงาน',
                                  showCloseIcon: false,
                                  btnOkText: "ตกลง",
                                  btnOkOnPress: () {

                                  },
                                ).show();
                              }
                            }else{
                              context.loaderOverlay.show();
                              senddata();
                            }
                          }


                          // print("ok.${ListempID}");
                          // context.loaderOverlay.show();
                          // senddata();
                        } :null,
                        child: Text('บันทึก')),
                  ),
                ),
              ],
            )
          ],
        );
      default:
        return Container();
    }
  }

  Widget empUI() {
    return ListView.separated(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: this.userModel.otherskill.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            Row(
                children: <Widget>[
                  Flexible(
                    fit: FlexFit.loose,
                    child: listempUI(index),
                  ),
                ]),
          ],
        );
      },
      separatorBuilder: (context, index) => Divider(),
    );
  }

  Widget listempUI(index) {
    return Container(
      // padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                  alignment: Alignment.topLeft,
                  child:  Text(
                    "พนักงานคนที่ ${index+1}",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                DropdownButtonFormField<String>(
                  focusNode: FocusNode(),
                  icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                  value: selectedPO[index],
                  onChanged: (value) {
                    setState(() {
                      // selectPOS = value!;
                      // selectedPO.add(value!);
                      // print(selectedPO);
                      var Hour;
                      if(typeTimeName == "เต็มวัน"){
                        Hour = hourOT.text;
                      }else if(oldhourOT == null){
                        Hour = calculateOT2(_startOTText.text,_endOTText.text);
                      }else{
                        Hour = newhourOT;
                      }

                      // if(oldhourOT == null){
                      //   Hour = calculateOT2(_startOTText.text,_endOTText.text);
                      // }else{
                      //   Hour = newhourOT;
                      // }

                      print(Hour);
                      var num;
                      NumberFormat numberFormat = NumberFormat.decimalPattern('hi');
                      for(var i =0; i<ListMasterPos.length; i++){
                        if(ListMasterPos[i]['id'] == value){
                          textEditingControllers[index].text = ListMasterPos[i]['name'];
                          rateHour = ListMasterPos[i]['hourly_wage'];
                          if(rateOT == null){
                            numMoney[index].text = "";
                          }else{
                            var mynum = double.parse("${rateOT}")*double.parse("${Hour}")*double.parse("${rateHour}");
                            numMoney[index].text = mynum.toString();
                          }


                        if(ListempID.length > 0){
                          var itempos = false;


                          for(var i = 0; i<int.parse("${ListempID.length}"); i++){
                            if(ListempID[i]['id'].toString() == value){
                              print("l.${ListempID[i]['id']}");
                              itempos = true;
                              textEditingControllers[index].text = "";
                              alert(index);
                              // userModel.otherskill.removeAt(index),
                              // ListempID.removeAt(index),
                              print(index);
                              print("เลือกไม่ได้.${ListempID}");
                            }
                          }
                          // ListempID.forEach((item) =>{
                          //   print("it5.${item}"),
                          //   if(item['id'] == value){
                          //     itempos = true,
                          //     textEditingControllers[index].text = "",
                          //     alert(index),
                          //     // userModel.otherskill.removeAt(index),
                          //     // ListempID.removeAt(index),
                          //     print(index),
                          //
                          //     print("เลือกไม่ได้.${ListempID}"),
                          //   }
                          // });
                          if(itempos == false){
                            // ListempID.add(value);
                            // print(ListempID);
                            if(ListempID.length > index){
                              ListempID.removeAt(index);
                              print("0.${ListempID}");
                            }
                            ListempID.insert(index,{"id": "${value}","pos_id": "${ListMasterPos[i]['pos_id']}", "num": "${numMoney[index].text}"});
                            print("00.${ListempID}");
                            // for(var i =0; i < ListempID.length; i++){
                            //   numMoney[index-i].text = num.toString();
                            // }
                          }

                        }else{

                          // ListempID.insert(index,"${value}");
                          ListempID.insert(index,{"id": "${value}","pos_id": "${ListMasterPos[i]['pos_id']}", "num": "${numMoney[index].text}"});
                          print("000.${ListempID}");
                        }
                      }
                    }

                      // ListMasterPos.forEach((element) {
                      //   if(element['id'] == value){
                      //     textEditingControllers[index].text = element['name'];
                      //     rateHour = element['hourly_wage'];
                      //     var mynum = double.parse("${rateOT}")*double.parse("${Hour}")*double.parse("${rateHour}");
                      //     numMoney[index].text = mynum.toString();
                      //     // num = int.parse(amountMoney.text) /int.parse("${index+1}");
                      //     // numMoney[index].text = num.toStringAsFixed(0);
                      //     // numMoney[index-1].text = num.toString();
                      //     // if(ListempID.length > index){
                      //     //   ListempID.removeAt(index);
                      //     // }else{
                      //     //   ListempID.add(element['id']);
                      //     //   print(ListempID);
                      //     // }
                      //
                      //   }
                      // });



                    });
                  },
                  validator: (value) => (selectedPO == '' || selectedPO == null)
                      ? ''
                      : null,
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(

                    border: OutlineInputBorder(),
                  ),
                  items: ListPos.map((valueItem) {
                    return DropdownMenuItem<String>(
                        value: valueItem['id'],child: Text(valueItem['pos_name'])
                    );
                  }).toList(),

                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: textEditingControllers[index],
                  autofocus: false,
                  // focusNode: FocusNode(),
                  showCursor: true,
                  readOnly: true,
                  enabled: true,
                  // initialValue: this.userModel.otherskill[index],
                  obscureText: false,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'กรุณาเลือกตำแหน่งใหม่';
                    }
                    return null;
                  },
                  onSaved: (val){
                    userModel.otherskill[index] = val!;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    // hintText: "กรุณากรอกรายละเอียด",
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: numMoney[index],
                  autofocus: false,
                  // focusNode: FocusNode(),
                  showCursor: true,
                  readOnly: false,
                  enabled: true,
                  // initialValue: this.userModel.otherskill[index],
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'ห้ามปล่อยว่าง';
                    }
                    return null;
                  },
                  onChanged: (val){
                    print(val);
                    for(var i=0; i<ListempID.length; i++){
                      if(rateOT == null){
                        if(index == i){
                          ListempID[i]['num'] = val;
                        }
                      }
                    }
                    // ListempID.forEach((element) {
                    //   if(rateOT == null){
                    //     element['num'] =  val;
                    //   }
                    // });
                    print("c.${ListempID}");
                  },
                  onSaved: (val){
                    userModel.otherskill[index] = val!;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    hintText: "จำนวนเงิน",
                    filled: false,
                    fillColor: Colors.grey.shade200,
                    border: const OutlineInputBorder(),
                  ),
                )
              ],
            ),
          ),
          Visibility(
              child: SizedBox(
                width: 35,
                child: IconButton(
                  icon: Icon(
                    Icons.add_circle,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    addempUI(index);
                  },
                ),
              ),
              visible: index == this.userModel.otherskill.length - 1 && index < stringListReturnedFromApiCall.length-2
          ),
          index ==0 && userModel.otherskill.length == 1
          ?Visibility(
            child: SizedBox(
              width: 35,
              child: IconButton(
                icon: Icon(
                  Icons.remove_circle,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  removeempUI(index);
                },
              ),
            ),
            // visible: index >= 0 || index == userModel.otherskill.length,
            visible: index > 0,
          )
          :Visibility(
            child: SizedBox(
              width: 35,
              child: IconButton(
                icon: Icon(
                  Icons.remove_circle,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  removeempUI(index);
                },
              ),
            ),
            visible: index >= 0 || index == userModel.otherskill.length,
          )
        ],
      ),
    );
  }

  String calculateOT(start,end){
    var dateStart = DateFormat("dd/MM/yyyy HH:mm").parse(start);
    var dateEnd = DateFormat("dd/MM/yyyy HH:mm").parse(end);
    var diff = dateEnd - dateStart;
    var difhour = diff.toString().split(":")[0];
    var difmin = diff.toString().split(":")[1];
    var Hour = "";
    print("dif1: ${diff}");
    print("dif2: $difmin");
    switch("${difmin}"){
      case "00":
        Hour="${difhour}";
        break;
      case "15":
        Hour="${difhour}.25";
        break;
      case "30":
        Hour="${difhour}.5";
        break;
      case "45":
        Hour="${difhour}.75";
        break;
    }
    hourOT.text = Hour.toString();
    oldhourOT = hourOT.text;
    var numVal = double.parse(hourOT.text);
    if(numVal > 2){
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
        title: 'OT เกิน 2 ชม.',
        desc: 'จำเป็นต้องหักเวลาพัก 30 นาที',
        showCloseIcon: false,
        btnOkText: "หักพัก",
        btnCancelText: "ไม่หักพัก",
        btnOkOnPress: () {
          var i = double.parse(hourOT.text)-double.parse("0.5");
          hourOT.text = i.toString();
          newhourOT = i.toString();
        },
        btnCancelOnPress: () {
          oldhourOT = null;
        },
      ).show();
    }else if (numVal == 2){
      oldhourOT = null;
    }
    print("${Hour} ชม");
    return Hour;
  }

  String calculateOT2(start,end){
    var dateStart = DateFormat("dd/MM/yyyy HH:mm").parse(start);
    var dateEnd = DateFormat("dd/MM/yyyy HH:mm").parse(end);
    var diff = dateEnd - dateStart;
    var difhour = diff.toString().split(":")[0];
    var difmin = diff.toString().split(":")[1];
    var Hour = "";
    print("dif3: ${diff}");
    print("dif4: $difmin");
    switch("${difmin}"){
      case "00":
        Hour="${difhour}";
        break;
      case "15":
        Hour="${difhour}.25";
        break;
      case "30":
        Hour="${difhour}.5";
        break;
      case "45":
        Hour="${difhour}.75";
        break;
    }

    return Hour;
  }

  void alert(index){
    setState(() {
      selectedPO[index]=ListPos[0]['id'];
      textEditingControllers[index].text = "";
      numMoney[index].text = "";
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
        title: 'คุณเลือกตำแหน่งซ้ำ',
        // desc: 'เนื่องจากคุณ',
        showCloseIcon: false,
        btnOkText: "ตกลง",
        btnOkOnPress: () {
          if(ListempID.length >= index){
            ListempID.removeAt(index);
            ListempID.insert(index,{"id": "","pos_id": "", "num": ""});
            // ListempID.insert(index, "");
            print("ok.${ListempID}");
          }
        },
      ).show();
    });
  }

  void addempUI(index) {
    try{
      print("index.${index}");
      FocusScope.of(context).requestFocus(FocusNode());
      setState(() {
        this.userModel.otherskill.add("");
        selectedPO[index+1]=ListPos[0]['id'];
        textEditingControllers[index+1].text = "";
        numMoney[index+1].text = "";
        ListempID.insert(index+1,{"id": "","pos_id": "", "num": ""});
        print("add.${ListempID}");
      });

      // if(selectedPO[index].isNotEmpty){
      //   setState(() {
      //     this.userModel.otherskill.add("");
      //     selectedPO.add(ListPos[0]['id']);
      //   });
      //   print(selectedPO[index]);
      // }else{
      // AwesomeDialog(
      //   context: context,
      //   dialogType: DialogType.WARNING,
      //   dismissOnTouchOutside: false,
      //   // dialogBackgroundColor: Colors.orange,
      //   borderSide: BorderSide(color: Colors.grey, width: 2),
      //   width: 350,
      //   buttonsBorderRadius: BorderRadius.all(Radius.circular(20)),
      //   headerAnimationLoop: false,
      //   animType: AnimType.SCALE,
      //   // autoHide: Duration(seconds: 3),
      //   // dialogBackgroundColor: Colors.deepPurpleAccent,
      //   title: 'พนักงานคนที่ ${index+1} มีค่าว่าง',
      //   // desc: 'เนื่องจากคุณ',
      //   showCloseIcon: false,
      //   btnOkText: "ตกลง",
      //   btnOkOnPress: () {
      //
      //   },
      // ).show();
      // }
    }catch(e){
      print(e);
    }


  }

  void removeempUI(index) {
    try{
      print(index);

      setState(() {

        if(userModel.otherskill[index].isEmpty) {
          userModel.otherskill.removeAt(index);
          ListempID.removeAt(index);
          print("val.${ListempID}");
          ListPos.forEach((element) {
            for(var i = 0; i<ListempID.length; i++){
              if(ListempID[i] == element['id']){
                selectedPO[i] = element['id'];
                textEditingControllers[i].text=element['name'];
              }

            }
          });

          print("1");
        }
      });
    }catch(e){
      print(e);
    }

  }



}

