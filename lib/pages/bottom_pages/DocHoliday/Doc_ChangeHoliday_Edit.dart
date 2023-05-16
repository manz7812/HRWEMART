import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/ModelSkill.dart';
import '../../../api/url.dart';
import '../../widjet/popupAlert.dart';

class EditDocChangeHolidayPage extends StatefulWidget {
  final String id;
  const EditDocChangeHolidayPage({Key? key, required this.id}) : super(key: key);

  @override
  State<EditDocChangeHolidayPage> createState() => _EditDocChangeHolidayPageState();
}

class _EditDocChangeHolidayPageState extends State<EditDocChangeHolidayPage> {
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
    await getdata();
    await getDataHeader();
    await getDataKa();
    await listemp(startD);
    // await setEmp();
  }

  List<String> selectedPO = [];
  String? selectPOS;
  List ListMasterPos = [
    {"id": "00", "name": "", "pos_id": "00", "pos_name": "กรุณาเลือกตำแหน่ง"}
  ];

  List ListPos =[];
  List ListempID = [];

  bool popupalert = false;
  Future<Null> listemp(date)async{
    String url = pathurl.listempHoly+"?pos_id=${dataID[0]['emp_created']['pos_id']}&date=${date}";
    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    // log.i(data["data"],"data");

    if(data["data"].isNotEmpty){
      popupalert = false;
    }else{
      popupalert = true;
      // _startdatetimeHoly.clear();
      // _enddatetimeHoly.clear();
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
          _startdatetimeHoly.text = dataID[0]['rh_date_holiday'];
        },
      ).show();
    }

    // log.i(popupalert,"alert");
    // ListPos.add(ListMasterPos[0]);
    ListMasterPos = [
      {"id": "00", "name": "", "pos_id": "00", "pos_name": "กรุณาเลือกตำแหน่ง"}
    ];
    data["data"].forEach((item){
      var jason = {"id": "${item['id']}", "name": "${item['name']}", "pos_id": "${item['pos_id']}", "pos_name": "${item['pos_name']}"};
      ListMasterPos.add(jason);
    });

    ListMasterPos.forEach((element) {
      stringListReturnedFromApiCall.add(element['id'].toString());
    });

    // setState(() {
    //   stringListReturnedFromApiCall.forEach((str) {
    //     var textEditingController = TextEditingController(text: "");
    //     textEditingControllers.add(textEditingController);
    //     selectedPO = [];
    //     selectedPO.add(ListPos[0]['id']);
    //   });
    // });
    // print(ListMasterPos);
    // print(stringListReturnedFromApiCall);
    // print(WHD);
  }


  List dataID = [];
  List dataEmp = [];
  Future<Null> getdata() async {
    try{
      setState(() {
        loading = false;
      });
      String url = pathurl.getDTH+widget.id;
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
          dataEmp = data['data'][0]['rh_emp'];

          var start = DateFormat("dd/MM/yyyy").parse(dataID[0]['rh_date_holiday']);
          var starts= start.toString().split(" ")[0];
          startD = starts;
          print(startD);
          var end = DateFormat("dd/MM/yyyy").parse(dataID[0]['rh_date_change']);
          var ends= end.toString().split(" ")[0];
          endD = ends;
          print(endD);


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
      print(e);
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

  Future<Null> setEmp() async{
    if(ListempID.length == 0){
      ListPos = ListMasterPos;
    }
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
      selectedPO.add(ListMasterPos[0]['id']);
      var textEditingController = TextEditingController(text: "");
      textEditingControllers.add(textEditingController);
      var dt = DateFormat("yyyy-MM-dd").format(startdateTime!);
      setState(() {
        listemp(dt);
      });

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

  Future<Null> senddata(data,id) async{
    String url = pathurl.sendDTH+widget.id;
    final response = await put(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
      body: data,
    );
    print(response.statusCode);
    if(response.statusCode == 200){
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
  }

  String? startD;
  String? endD;

  @override
  void initState() {
    getToken();

    Future.delayed(const Duration(seconds: 1),(){
      setState(() {
        loading = true;
        _startdatetimeHoly.text = dataID[0]['rh_date_holiday'];
        _enddatetimeHoly.text = dataID[0]['rh_date_change'];
        _detailHolidayText.text = dataID[0]['rh_details'];


        stringListReturnedFromApiCall.forEach((str) {
          var textEditingController = TextEditingController(text: "");
          textEditingControllers.add(textEditingController);
          selectedPO.add(ListMasterPos[0]['id']);
          print("poo.${selectedPO}");
          print("len.${selectedPO.length}");
          // var i = dataID[0]['rh_emp'].length-1;
          // var i = 0;

          for(var i = 0; i<dataID[0]['rh_emp'].length; i++){
            if(str == dataID[0]['rh_emp'][i]['id']){
              print("ไอ2.${i}");
              userModel.otherskill.add("");
              selectedPO[i]=dataID[0]['rh_emp'][i]['id'];
              ListempID.insert(i, dataID[0]['rh_emp'][i]['id']);
              textEditingControllers[i].text = dataID[0]['rh_emp'][i]['name'];
              // i+1;
            }
          }
          // dataID[0]['rh_emp'].forEach((item){
          //   if(str == item['id']){
          //     print("ไอ2.${i}");
          //     userModel.otherskill.add("");
          //     selectedPO[i]=item['id'];
          //     ListempID.insert(i, item['id']);
          //     textEditingControllers[i].text = item['name'];
          //     i+1;
          //   }
          // });
        });



      });
    });
    _detailHolidayText.addListener(() {
      setState(() {
        // isButtonActive = controllerhedpon.text.isNotEmpty;
      });
    });
    // userModel.otherskill.add("");
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
                            children: <Widget>[
                              Text("หมายเลขเอกสาร : ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.black),),
                              Text("${widget.id}",style: TextStyle(fontSize: 16,color: Colors.black),),
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
                                  _enddatetimeHoly.clear();

                                  // stringListReturnedFromApiCall.forEach((str) {
                                  //   var textEditingController = TextEditingController(text: "");
                                  //   textEditingControllers.add(textEditingController);
                                  //   selectedPO.add(ListMasterPos[0]['id']);
                                  // });

                                  stringListReturnedFromApiCall.clear();
                                  print("stringListReturnedFromApiCall=$stringListReturnedFromApiCall");
                                  textEditingControllers.clear();
                                  print("textEditingControllers=$textEditingControllers");
                                  // ListMasterPos.clear();
                                  selectedPO.clear();
                                  // selectedPO.add(ListMasterPos[0]['id']);
                                  print("selectedPO=$selectedPO");
                                  ListempID.clear();
                                  ListPos.clear();
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
                          const SizedBox(
                            height: 20,
                          ),
                          _enddatetimeHoly.text.isNotEmpty
                          ? Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                                alignment: Alignment.topLeft,
                                child: const Text(
                                  "พนักงาน",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
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
                                          "rh_date_holiday": startdateTime == null
                                              ? "${startD}"
                                              : "${_startdatetimeHoly.text = DateFormat('yyyy-MM-dd').format(startdateTime!)}",
                                          "rh_date_change": enddateTime == null
                                              ? "${endD}"
                                              : "${_enddatetimeHoly.text = DateFormat('yyyy-MM-dd').format(enddateTime!)}",
                                          // "reqW_emp":"${ListempID.toString().replaceAll('[', '').replaceAll(']','')}",
                                          // "reqW_emp":"${ListempID =List<dynamic>.from(ListempID)}",
                                          "rh_emp":"${ListempID.join(",")}",
                                          "rh_details":"${_detailHolidayText.text}",
                                          "pos_id":"${dataID[0]['emp_created']['pos_id']}"
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
                                            senddata(jsdata,widget.id);
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
                DropdownButtonFormField<String>(
                  focusNode: FocusNode(),
                  icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                  value: selectedPO[index],
                  onChanged: _enddatetimeHoly.text.isNotEmpty ?(value) {
                    setState(() {
                      // selectPOS = value!;
                      // selectedPO.add(value!);
                      // print(selectedPO);
                      ListMasterPos.forEach((element) {
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
                  items: ListMasterPos.map((valueItem) {
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
      selectedPO[index]=ListMasterPos[0]['id'];
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

  void addEmailControl(index) {
    try{
      print("index.${index}");
      setState(() {
        this.userModel.otherskill.add("");
        selectedPO[index+1]=ListMasterPos[0]['id'];
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
