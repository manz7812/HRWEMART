import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:index/pages/widjet/myAlertLocation.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/ModelSkill.dart';
import '../../../api/url.dart';
import '../../widjet/popupAlert.dart';

class DocChangeHolidayPage extends StatefulWidget {
  const DocChangeHolidayPage({Key? key}) : super(key: key);

  @override
  State<DocChangeHolidayPage> createState() => _DocChangeHolidayPageState();
}

class _DocChangeHolidayPageState extends State<DocChangeHolidayPage> {
  bool loading = false;

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


  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  late SkillModel userModel = SkillModel(
      List<String>.empty(growable: true),
      ""
  );

  // DateTime DateHoliday = DateTime.now();


  DateTime? DateHoliday;
  TextEditingController _DateHolidayText = TextEditingController();
  TextEditingController _detailHolidayText = TextEditingController();
  TextEditingController _startdatetimeHoly = TextEditingController();
  TextEditingController _enddatetimeHoly = TextEditingController();

  // String? selectedHoliday;
  // List ListHoliday =[
  //   'วันหยุดพนักงาน', 'วันทำงาน', 'วันหยุดนักขัตฤกษ์',
  // ];


  String token = "";
  Future<Null> getToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
     await getDataHeader();
     await getDataKa();
     await check2Pos();
     // await setEmp();
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

  List<String> selectedPO = [];
  String? selectPOS;
  List ListMasterPos = [
    {"id": "00", "name": "", "pos_id": "00", "pos_name": "กรุณาเลือกตำแหน่ง"}
  ];

  List ListPos =[
  ];
  List ListempID = [];

  bool popupalert = false;

  Future<Null> listemp(date)async{
    String url = pathurl.listempHoly+"?pos_id=${selected2Pos}&date=${date}";
    print(url);
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
          _startdatetimeHoly.clear();
          _enddatetimeHoly.clear();
        },
      ).show();
    }

    // log.i(popupalert,"alert");
    ListPos = [
      {"id": "00", "name": "", "pos_id": "00", "pos_name": "กรุณาเลือกตำแหน่ง"}
    ];

    data["data"].forEach((item){
      var jason = {"id": "${item['id']}", "name": "${item['name']}", "pos_id": "${item['pos_id']}", "pos_name": "${item['pos_name']}"};
      ListPos.add(jason);
    });

    ListPos.forEach((element) {
      stringListReturnedFromApiCall.add(element['id'].toString());
    });

    setState(() {
      stringListReturnedFromApiCall.forEach((str) {
        var textEditingController = TextEditingController(text: "");
        textEditingControllers.add(textEditingController);
        // selectedPO = [];
        selectedPO.add(ListPos[0]['id']);
      });
    });
    // print(ListMasterPos);
    log.i(ListMasterPos);
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
      print(response.statusCode);
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

  Future<bool> setEmp() async{
    var alert = false;
    if(ListempID.length == 0){
      ListPos = ListMasterPos;
    }else{
      // ListPos = [];
      var itempos = [];
      ListMasterPos.forEach((element) {
        ListempID.forEach((item) =>{
          if(item == element['id']){
            // ListPos.removeAt(0),
            alert = true
          }
        });

      });

    }
    return alert;
  }

  DateTime? startdateTime;
  Future<DateTime?> pickStartDate(BuildContext context) async {
    var initialDate = DateTime.now();
    var firstDate = DateTime(DateTime.now().year - 5);
    var lastDate = DateTime(DateTime.now().year + 5);

    DateTime? newdate = await showDatePicker(
        context: context,
        helpText: 'เลือกวันที่',
        confirmText: 'ตกลง',
        cancelText: 'ยกเลิก',
        // locale: Locale('th'),
        initialDate: startdateTime = initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        // currentDate: DateTime.now(),
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
    }else{
      print('เลือกวันที่เรียบร้อย');
      startdateTime = newdate;
      var dt = DateFormat("yyyy-MM-dd").format(startdateTime!);
      listemp(dt);
      return newdate;
    }
  }

  DateTime? enddateTime;
  Future<DateTime?> pickEndDate(BuildContext context) async {
    var initialDate = DateTime.now();
    var firstDate = DateTime(DateTime.now().year - 5);
    var lastDate = DateTime(DateTime.now().year + 5);


    DateTime? newdate = await showDatePicker(
        context: context,
        helpText: 'เลือกวันที่',
        confirmText: 'ตกลง',
        cancelText: 'ยกเลิก',
        // locale: Locale('th'),
        initialDate: enddateTime = initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
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
    }else{
      print('เลือกวันที่เรียบร้อย');
      enddateTime = newdate;

      if(popupalert == true){
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
            _startdatetimeHoly.clear();
            _enddatetimeHoly.clear();
          },
        ).show();
      }

      return newdate;
    }
  }

  Future<Null> senddata(data) async{
    String url = pathurl.sendDTH;
    final response = await post(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
      body: data,
    );
    var res = jsonDecode(response.body.toString());
    print(response.statusCode);
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
          Navigator.of(context).pop();
        },
      ).show();
      // Future.delayed(const Duration(seconds: 4),(){
      //   Navigator.of(context).pop();
      // });
    }else if(response.statusCode == 401){
      popup().sessionexpire(context);
    }else if(response.statusCode == 403){
      context.loaderOverlay.hide();
      var messsage = res['message'];
      print(res);
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
          desc: 'เนื่องจาก${messsage['title']}',
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

  @override
  void initState() {
    getToken();
    Future.delayed(const Duration(seconds: 1),(){
      setState(() {
        loading = true;
      });
    });
    _detailHolidayText.addListener(() {
      setState(() {
        // isButtonActive = controllerhedpon.text.isNotEmpty;
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
        title: const Text("ขอเปลี่ยนวันหยุด"),
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
                              Text("ตำแหน่ง : ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.black),),
                              Text("${namePos??""}",style: TextStyle(fontSize: 16,color: Colors.black),),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
                                alignment: Alignment.topLeft,
                                child: const Text(
                                  "วันหยุดปกติ",
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
                                controller: _startdatetimeHoly,
                                enabled: true,
                                validator: (value) => (value!.isEmpty) ? '' : null,
                                decoration: InputDecoration(
                                  // label: Text("เลือกวันที่"),
                                  filled: false,
                                  fillColor: Colors.grey.shade200,
                                  suffixIcon: Icon(
                                    Icons.calendar_today_outlined,
                                    color: Colors.green,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                                onTap: () async{
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  await pickStartDate(context);
                                  _startdatetimeHoly.text = DateFormat('dd/MM/yyyy').format(startdateTime!);
                                },
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
                                  "เปลี่ยนเป็นวันที่",
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
                                controller: _enddatetimeHoly,
                                enabled: _startdatetimeHoly.text.isNotEmpty  ? true : false,
                                decoration: InputDecoration(
                                  // label: Text("เลือกวันที่"),
                                  filled: _startdatetimeHoly.text.isNotEmpty ? false : true,
                                  fillColor: Colors.grey.shade200,
                                  suffixIcon: Icon(
                                    Icons.calendar_today_outlined,
                                    color: _startdatetimeHoly.text.isNotEmpty ? Colors.green : Colors.grey,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                                onTap: () async{
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  await pickEndDate(context);
                                  _enddatetimeHoly.text = DateFormat('dd/MM/yyyy').format(enddateTime!);
                                },
                              ),
                            ],
                          ),
                          // Container(
                          //   padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
                          //   alignment: Alignment.topLeft,
                          //   child: const Text(
                          //     "เปลี่ยนเป็นวัน",
                          //     style: TextStyle(
                          //       color: Colors.black,
                          //       fontWeight: FontWeight.w500,
                          //       fontSize: 16,
                          //     ),
                          //     textAlign: TextAlign.left,
                          //   ),
                          // ),
                          // DropdownButtonFormField<String>(
                          //   // isExpanded: true,
                          //   // underline: const SizedBox(),
                          //   // hint: Container(
                          //   //   padding: const EdgeInsets.only(right: 5, left: 8),
                          //   //     alignment: AlignmentDirectional.centerStart,
                          //   //     // width: 180,
                          //   //     child: Text(
                          //   //       ListHoliday.first,
                          //   //       style: const TextStyle(
                          //   //         color: Colors.black,fontSize: 16,
                          //   //       ),
                          //   //     )
                          //   // ),
                          //   focusNode: FocusNode(),
                          //   icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                          //   value: selectedHoliday,
                          //   onChanged: (value) {
                          //     setState(() {
                          //       selectedHoliday = value as String;
                          //     });
                          //   },
                          //   // validator: (value) => (selectedStatus == '' || selectedStatus == null)
                          //   //     ? ''
                          //   //     : null,
                          //   // autovalidateMode: AutovalidateMode.onUserInteraction,
                          //   decoration: InputDecoration(
                          //     // enabledBorder: OutlineInputBorder(
                          //     //   borderSide: BorderSide(
                          //     //       color: Colors.grey, width: 2.0
                          //     //   ),
                          //     // ),
                          //     border: OutlineInputBorder(
                          //       // borderSide: const BorderSide(color: Colors.green, width: 2.0),
                          //     ),
                          //     // focusedBorder: OutlineInputBorder(
                          //     //   borderSide: BorderSide(
                          //     //       color: Colors.grey, width: 2.0),
                          //     // ),
                          //   ),
                          //   items: ListHoliday.map((valueItem) {
                          //     return DropdownMenuItem<String>(
                          //         value: valueItem,child: Text(valueItem)
                          //     );
                          //   }).toList(),
                          // ),
                          const SizedBox(
                            height: 20,
                          ),
                          _enddatetimeHoly.text.isNotEmpty
                          ? Column(
                            children: [
                              emailsContainerUI(),
                            ],
                          )
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
                            // focusNode: FocusNode(),
                            controller: _detailHolidayText,
                            // autofocus: true,
                            readOnly: false,
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
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.red ,
                                        primary: Colors.white,
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
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: _startdatetimeHoly.text.isNotEmpty &&
                                                        _enddatetimeHoly.text.isNotEmpty &&
                                                        _detailHolidayText.text.isNotEmpty &&
                                                        selectedPO != null
                                                          ? Colors.green : Colors.grey.shade300,
                                        primary: Colors.white,
                                        // minimumSize: Size(width, 100),
                                      ),
                                      onPressed: _startdatetimeHoly.text.isNotEmpty &&
                                          _enddatetimeHoly.text.isNotEmpty &&
                                                 _detailHolidayText.text.isNotEmpty &&
                                                  selectedPO != null
                                          ? ()=> setState(() {
                                                FocusScope.of(context).requestFocus(FocusNode());
                                                var jsdata = {
                                                  "rh_date_holiday":"${_startdatetimeHoly.text = DateFormat('yyyy-MM-dd').format(startdateTime!)}",
                                                  "rh_date_change":"${_enddatetimeHoly.text = DateFormat('yyyy-MM-dd').format(enddateTime!)}",
                                                  // "reqW_emp":"${ListempID.toString().replaceAll('[', '').replaceAll(']','')}",
                                                  // "reqW_emp":"${ListempID =List<dynamic>.from(ListempID)}",
                                                  "rh_emp":"${ListempID.join(",")}",
                                                  "rh_details":"${_detailHolidayText.text}",
                                                  "pos_id":"${selected2Pos??""}"
                                                };

                                                AwesomeDialog(
                                                  context: context,
                                                  dialogType: DialogType.QUESTION,
                                                  dismissOnTouchOutside: false,
                                                  // dialogBackgroundColor: Colors.orange,
                                                  borderSide: BorderSide(color: Colors.black12, width: 2),
                                                  width: 350,
                                                  buttonsBorderRadius: BorderRadius.all(Radius.circular(20)),
                                                  headerAnimationLoop: false,
                                                  animType: AnimType.SCALE,
                                                  // dialogBackgroundColor: Colors.deepPurpleAccent,
                                                  title: 'ยืนยันการบันทึก',
                                                  showCloseIcon: false,
                                                  btnOkText: "ตกลง",
                                                  btnCancelText: "ยกเลิก",
                                                  btnOkOnPress: () {
                                                    senddata(jsdata);
                                                    context.loaderOverlay.show();
                                                  },
                                                  btnCancelOnPress: (){
                                                    FocusScope.of(context).requestFocus(FocusNode());
                                                  },
                                                ).show();

                                                print(jsdata);
                                            })
                                          : null,
                                      child: Text('บันทึก')),
                                ),
                              ),
                            ],
                          )
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
      )
          : const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
              strokeWidth: 5,)
        )
    );
  }

  Widget emailsContainerUI() {
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
                    child: emailUI(index),
                  ),
                ]),
          ],
        );
      },
      separatorBuilder: (context, index) => Divider(),
    );
  }

  Widget emailUI(index) {
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
                  onChanged: _enddatetimeHoly.text.isNotEmpty ?(value) {
                    setState(() {
                      // selectPOS = value!;
                      // selectedPO.add(value!);
                      // print(selectedPO);
                      ListPos.forEach((element) {
                        if(element['id'] == value){
                          textEditingControllers[index].text = element['name'];
                          // if(ListempID.length > index){
                          //   ListempID.removeAt(index);
                          // }else{
                          //   ListempID.add(element['id']);
                          //   print(ListempID);
                          // }

                        }
                      });
                      if(ListempID.length > 0){
                        var itempos = false;

                        ListempID.forEach((item) =>{
                          if(item == value){
                            itempos = true,
                            textEditingControllers[index].text = "",
                            alert(index),
                            // userModel.otherskill.removeAt(index),
                            // ListempID.removeAt(index),
                            print(index),

                            print("เลือกไม่ได้.${ListempID}"),

                            print("เลือกไม่ได้")

                          }
                        });
                        if(itempos == false){
                          // ListempID.add(value);
                          // print(ListempID);
                          if(ListempID.length > index){
                            ListempID.removeAt(index);
                            print("0.${ListempID}");
                          }
                          ListempID.insert(index,value);
                          print("00.${ListempID}");

                        }

                      }else{

                        ListempID.insert(index,value);
                        print("000.${ListempID}");
                      }


                    });
                  } : null,
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
                    addEmailControl(index);
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
                  removeEmailControl(index);
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
                  removeEmailControl(index);
                },
              ),
            ),
            visible: index >= 0 || index == userModel.otherskill.length,
          )
        ],
      ),
    );
  }

  void alert(index){
    setState(() {
      selectedPO[index]=ListPos[0]['id'];
      textEditingControllers[index].text = "";
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
            ListempID.insert(index, "");
            print("ok.${ListempID}");
          }
        },
      ).show();
    });
  }

  void addEmailControl(index) async{
    try{
      print("index.${index}");
      // print("dt.${_startdatetimeHoly.text}");
      // var start = DateFormat("dd/MM/yyyy").parse(_startdatetimeHoly.text);
      // var starts = start.toString().split(" ")[0];
      // print(starts);

      setState(() {
        userModel.otherskill.add("");
        // listemp(starts);
        selectedPO[index+1] = ListPos[0]['id'];
        textEditingControllers[index+1].text = "";
        ListempID.insert(index+1,"");
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

  void removeEmailControl(index) {
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

