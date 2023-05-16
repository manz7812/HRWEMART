import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:http/http.dart' hide MultipartFile;
import 'package:index/api/url.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/ModelSkill.dart';
import '../../widjet/popupAlert.dart';

class EditDocOTPage extends StatefulWidget {
  final String id;

  const EditDocOTPage({Key? key, required this.id}) : super(key: key);

  @override
  State<EditDocOTPage> createState() => _EditDocOTPageState();
}

class _EditDocOTPageState extends State<EditDocOTPage> {
  bool loading = false;
   DateTime? startdateTime;
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

  final _dateOT = DateFormat('dd/MM/yyyy').format(DateTime.now());

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
  String? time;

  Future<Null> getToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
    await getdata();
    await listOT();
    await KAlist();
    await getDataHeader();
    await getDataKa();
    await listemp();
  }

  List dataID = [];
  List dataEmp = [];
  String? startD;
  Future<Null> getdata() async {
    try{
      setState(() {
        loading = false;
      });
      String url = pathurl.editOT+widget.id;
      final response = await get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              loading = true;
            });
          });
          dataID = data['data'];
          dataEmp = data['data'][0]['ot_emp'];
          var startApi = DateFormat("dd/MM/yyyy HH:mm").parse(dataID[0]['ot_date_start']);
          print("aaaaa.${startApi}");
          var timeApi = "${startApi.hour}:${startApi.minute}";
          time = timeApi.toString();
          print("time.${time}");
          // var startDate = "${startApi.year}-${startApi.month}-${startApi.day}";
          var startDate = DateFormat("yyyy-MM-dd").parse("${startApi}").toString().split(" ")[0];
          startD = startDate + " ${time}";
          print("ddddd.${startD}");
        });
      }else if(response.statusCode == 401){
        dataID = [];
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
      print("eee.$e");
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

  Future<Null> listOT()async{
    String url = pathurl.listOT;
    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    ListOT = data['data'];
    // print(ListOT);
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


  Future<Null> listemp()async{
    String url = pathurl.Allemployee;
    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());

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

    // print(stringListReturnedFromApiCall);
    // print(WHD);
  }

  bool popupalert = false;
  Future<Null> listemp2(date)async{
    String url = pathurl.listEmpOT+"?date=${date}";
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
      _startOTText.clear();
      _endOTText.clear();
      hourOT.clear();
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


  Future<DateTime?> pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    DateTime? newdate = await showDatePicker(
        context: context,
        helpText: 'เลือกวันที่',
        confirmText: 'ตกลง',
        cancelText: 'ยกเลิก',
        initialDate: dateOT = initialDate,
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
    }else{
      print('เลือกวันที่เรียบร้อย');
      dateOT = newdate;
      print("${DateFormat('yyyy-MM-dd').format(newdate)} ${time}");
      listemp2("${DateFormat('yyyy-MM-dd').format(newdate)} ${time}");
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

  Future<DateTime?> startPickDateOT(BuildContext context) async {
    final initialDate = DateTime.now();
    DateTime? newdate = await showDatePicker(
        context: context,
        helpText: 'เลือกวันที่',
        confirmText: 'ตกลง',
        cancelText: 'ยกเลิก',
        initialDate: dateTimeOT = initialDate,
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
    }else{
      print('เลือกวันที่เรียบร้อย');
      return newdate;
    }
  }

  Future<TimeOfDay?> endpickTimeOT(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    print(time!.split(":"));
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
          ? TimeOfDay(hour: int.parse(time!.split(":")[0]), minute: int.parse(time!.split(":")[1]))
          : initialTime,
    );

    if (newtime == null){
      print('ไม่ได้เลือกเวลา');
    }else{
      print('เลือกเวลาเรียบร้อย');
      if(newtime.minute == 00 || newtime.minute == 15 || newtime.minute == 30 || newtime.minute == 45){
        print("success");
      }else{
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
          desc: 'กรุณาเลือกช่วงเวลา(นาที) ใหม่',
          showCloseIcon: false,
          btnOkText: "ตกลง",
          btnOkOnPress: () {
            // _startOTText.clear();
            _endOTText.clear();
          },
        ).show();
      }
      return newtime;
    }
  }

  Future<Null> senddata() async{
    String jsonTags = jsonEncode(ListempID);

    var sApi = DateFormat("dd/MM/yyyy HH:mm").parse(dataID[0]['ot_date_start']);
    var eApi = DateFormat("dd/MM/yyyy HH:mm").parse(dataID[0]['ot_date_end']);

    FormData formData = FormData.fromMap({
      "ot_type": selectedOT,
      "ot_wage": amountMoney.text,
      "wc_id": selectedKa,
      "ot_date_start": dateOT == null ? sApi :_startOTText.text = DateFormat('yyyy-MM-dd').format(dateOT!) +" ${time}",
      "ot_date_end": dateTimeOT == null ? eApi : _endOTText.text = DateFormat('yyyy-MM-dd HH:mm').format(dateTimeOT!),
      "ot_total_hours": hourOT.text,
      "ot_emp": jsonTags,
      "ot_details": _detailOT.text,
    });
    print(formData.fields);
    String url = pathurl.updateOT+widget.id;
    var response = await Dio().put(url,
        data: formData,
        options: Options(
            headers: {"Authorization": "Bearer $token"}
        )
    );
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
          Navigator.pop(context);
        },
      ).show();
      // Future.delayed(const Duration(seconds: 4),(){
      //   Navigator.of(context).pop();
      // });
    }else if(response.statusCode == 401){
      popup().sessionexpire(context);
    }else if(response.statusCode == 403){
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
            Navigator.pop(context);
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
    getToken();
    // var now = DateTime.now();
    // final _oTStartH = 17;
    // final _oTStartM = 00;
    // final _oTEndH = 18;
    // final _oTEndM = 00;
    // startdateTime = DateTime(now.year,now.month,now.day,_oTStartH,_oTStartM);
    // dateTimeOT = DateTime(now.year,now.month,now.day,_oTEndH,_oTEndM);
    Future.delayed(const Duration(seconds: 1),(){
      setState(() {
        loading = true;
        selectedOT = dataID[0]['ot_type'].toString();
        amountMoney.text = dataID[0]['ot_wage'].toString();
        selectedKa = dataID[0]['wc_id'];
        _startOTText.text = dataID[0]['ot_date_start'];
        _endOTText.text = dataID[0]['ot_date_end'];
        hourOT.text = dataID[0]['ot_total_hours'].toString();
        _detailOT.text = dataID[0]['ot_details'];

        stringListReturnedFromApiCall.forEach((str) {
          var textEditingController = TextEditingController(text: "");
          textEditingControllers.add(textEditingController);
          selectedPO.add(ListPos[0]['id']);

          for(var i = 0; i<dataID[0]['ot_emp'].length; i++){
            if(str == dataID[0]['ot_emp'][i]['id']){
              print("ไอ2.${i}");
              userModel.otherskill.add("");
              selectedPO[i]=dataID[0]['ot_emp'][i]['id'];
              ListempID.insert(i,{"id": "${dataID[0]['ot_emp'][i]['id']}","pos_id": "${dataID[0]['ot_emp'][i]['pos_id']}", "num": "${dataID[0]['ot_emp'][i]['wages']}"});
              print("dt.${ListempID}");
              textEditingControllers[i].text = dataID[0]['ot_emp'][i]['name'];
              // i+1;
            }
          }
          // selectedPO.add('str');
        });
        stringMoney.forEach((element) {
          var text = TextEditingController(text: "");
          numMoney.add(text);

          for(var i = 0; i<dataID[0]['ot_emp'].length; i++){
            if(element == dataID[0]['ot_emp'][i]['id']){
              numMoney[i].text = dataID[0]['ot_emp'][i]['wages'].toString();
              // i+1;
            }
          }
        });

        ListOT.forEach((element) {
          if(element['ID'] == dataID[0]['ot_type']){
            rateOT = element['rate'];
            print("rate.${rateOT}");
            // i+1;
          }
        });


      });
    });
    _detailOT.addListener(() {
      setState(() {

      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          title: const Text("แก้ไขขอโอที"),
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
                              children: <Widget>[
                                Text("หมายเลขเอกสาร : ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.black),),
                                Text("${widget.id}",style: TextStyle(fontSize: 16,color: Colors.black),),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
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
                                  }
                                });
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
                            // Container(
                            //   padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
                            //   alignment: Alignment.topLeft,
                            //   child: const Text(
                            //     "วันที่",
                            //     style: TextStyle(
                            //       color: Colors.black,
                            //       fontWeight: FontWeight.w500,
                            //       fontSize: 16,
                            //     ),
                            //     textAlign: TextAlign.left,
                            //   ),
                            // ),
                            // TextFormField(
                            //   autofocus: false,
                            //   focusNode: FocusNode(),
                            //   showCursor: true,
                            //   readOnly: true,
                            //   controller: _dateOTText,
                            //   validator: (value) => (value!.isEmpty) ? '' : null,
                            //   decoration: const InputDecoration(
                            //     // filled: true,
                            //     // fillColor: Colors.grey.shade300,
                            //     // label: Text("เลือกวันที่"),
                            //     suffixIcon: Icon(
                            //       Icons.calendar_today_outlined,
                            //       color: Colors.grey,
                            //     ),
                            //     border: OutlineInputBorder(),
                            //   ),
                            //   onTap: () async{
                            //     FocusScope.of(context).requestFocus(new FocusNode());
                            //     await pickDate(context);
                            //     _dateOTText.text = DateFormat('dd/MM/yyyy').format(dateOT);
                            //   },
                            // ),
                            // const SizedBox(
                            //   height: 20,
                            // ),
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
                                  onChanged: (value) {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    setState(() {
                                      selectedKa = value as String;
                                      print(selectedKa);
                                    });
                                    ListKa.forEach((element) {
                                      if(element['ID'] == selectedKa){
                                        time = element['time_out'];
                                        print(time);
                                      }
                                    });
                                  },
                                  validator: (value) => (selectedKa == '' || selectedKa == null)
                                      ? ''
                                      : null,
                                  decoration: InputDecoration(
                                    filled: false,
                                    fillColor: Colors.grey.shade200,
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
                              decoration: const InputDecoration(
                                // filled: true,
                                // fillColor: Colors.grey.shade300,
                                // label: Text("เลือกวันที่"),
                                suffixIcon: Icon(
                                  Icons.calendar_today_outlined,
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              onTap: () async{
                                FocusScope.of(context).requestFocus(new FocusNode());
                                await pickDate(context);
                                _startOTText.text = DateFormat('dd/MM/yyyy').format(dateOT!) +" ${time}";
                                // await startPickDateTimeOT(context);
                                // _startOTText.text = DateFormat('dd/MM/yyyy HH:mm').format(dateTimeOT);
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
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
                              showCursor: true,
                              readOnly: true,
                              controller: _endOTText,
                              validator: (value) => (value!.isEmpty) ? '' : null,
                              decoration: const InputDecoration(
                                // filled: true,
                                // fillColor: Colors.grey.shade300,
                                // label: Text("เลือกวันที่"),
                                suffixIcon: Icon(
                                  Icons.calendar_today_outlined,
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              onTap: () async{
                                FocusScope.of(context).requestFocus(new FocusNode());
                                await startPickDateTimeOT(context);
                                _endOTText.text = DateFormat('dd/MM/yyyy HH:mm').format(dateTimeOT!);
                                // print("hot.${calculateOT(_startOTText.text, _endOTText)}");
                                await calculateOT(_startOTText.text, _endOTText.text);
                                // hourOT.text = hot;
                              },
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
                            oldhourOT == null
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
                              showCursor: true,
                              readOnly: true,
                              controller: hourOT,
                              validator: (value) => (value!.isEmpty) ? '' : null,
                              decoration: const InputDecoration(
                                // filled: true,
                                // fillColor: Colors.grey.shade300,
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
                            hourOT.text.isEmpty
                            ?const SizedBox()
                            : empUI(),
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
                                                context.loaderOverlay.show();
                                                senddata();
                                                print("ok");
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
                      if(oldhourOT == null){
                        Hour = calculateOT2(_startOTText.text,_endOTText.text);
                      }else{
                        Hour = newhourOT;
                      }
                      print("h.${Hour}");
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
                                print("in.${index}");
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
                  readOnly: selectedOT == "5" ? false : true,
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
                    filled: selectedOT == "5" ? false : true,
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
    print("dif: ${diff}");
    print("dif: $difmin");
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

    stringListReturnedFromApiCall.forEach((str) {
      for(var i = 0; i<dataID[0]['ot_emp'].length; i++){
        if(str == dataID[0]['ot_emp'][i]['id']){
          removeempUI(i);
        }
      }
    });
    addempUI2(0);

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
    }else{
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
    print("dif: ${diff}");
    print("dif: $difmin");
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

  void addempUI2(index) {
    try{
      print("index.${index}");
      FocusScope.of(context).requestFocus(FocusNode());
      setState(() {
        this.userModel.otherskill.add("");
        selectedPO[index]=ListPos[0]['id'];
        textEditingControllers[index].text = "";
        numMoney[index].text = "";
        ListempID.insert(index,{"id": "","pos_id": "", "num": ""});
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
