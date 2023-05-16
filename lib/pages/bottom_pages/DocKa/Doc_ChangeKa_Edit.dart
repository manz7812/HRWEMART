import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:index/api/ModelSkill.dart';
import 'package:index/api/url.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/ModelEmp.dart';
import '../../widjet/popupAlert.dart';

class EditDocChangeKaPage extends StatefulWidget {
  final String id;
  const EditDocChangeKaPage({Key? key, required this.id}) : super(key: key);

  @override
  State<EditDocChangeKaPage> createState() => _EditDocChangeKaPageState();
}

class _EditDocChangeKaPageState extends State<EditDocChangeKaPage> {
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
  var empName = [];
  List<TextEditingController> textEditingControllers = [];
  List<TextEditingController> empControllers = [];


  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  late SkillModel userModel = SkillModel(
      List<String>.empty(growable: true),
      ""
  );
  late EmpModel empModel = EmpModel(
      List<String>.empty(growable: true),
  );

  bool loading = false;
  TextEditingController _startdatetimeKa = TextEditingController();
  TextEditingController _enddatetimeKa = TextEditingController();
  TextEditingController _detailKa = TextEditingController();

  String token = "";
  Future<Null> getToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
    await getdata();
    await getDataHeader();
    await getDataKa();
    await KAlist();
    await listemp();
    await setEmp();
  }

  List dataID = [];
  Future<Null> getdata() async {
    try{
      setState(() {
        loading = false;
      });
      String url = pathurl.editDTK+widget.id;
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

  List<String> selectedPO = [];
  String? selectPOS;
  List ListMasterPos =[
    {"id": "00", "name": "", "pos_id": "00", "pos_name": "กรุณาเลือกตำแหน่ง"}
  ];
  List ListPos =[];
  List ListNewID =[];
  List ListempID = [];

  Future<Null> listemp()async{
    String url = pathurl.Allemployee+"?pos_id=${dataID[0]['emp_created']['pos_id']}";
    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    data["data"].forEach((item){
      var jason = {"id": "${item['id']}", "name": "${item['name']}", "pos_id": "${item['pos_id']}", "pos_name": "${item['pos_name']}"};
      ListMasterPos.add(jason);
    });
    print(ListMasterPos);

    ListMasterPos.forEach((element) {
      stringListReturnedFromApiCall.add(element['id'].toString());
      // stringListReturnedFromApiCall.add(element['id'].toString());
      // empName.add(element['name'].toString());
    });
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
      // print(data['data']);
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
      return newdate;
    }
  }

  Future<Null> senddata(data) async{
    String url = pathurl.sendDTK;
    final response = await put(
      Uri.parse(url+widget.id),
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
        stringListReturnedFromApiCall.forEach((str) {
          print(str);
          var textEditingController = TextEditingController(text: "");
          textEditingControllers.add(textEditingController);
          selectedPO.add(ListPos[0]['id']);
          print("l.${selectedPO.length}");
          print("lp.${selectedPO}");
          var i = selectedPO.length-2;
          dataID[0]['rw_emp'].forEach((item){
            if(str == item['id']){
              print("iii.${i}");
              selectedPO[i]=item['id'];
              ListempID.insert(i, item['id']);
              log.i(ListempID);
              // print("po.${selectedPO}");
              textEditingControllers[i].text = item['name'];
              // var textEditingController = TextEditingController(text: item['name']);
              // textEditingControllers.add(textEditingController);
              userModel.otherskill.add("");
              // ListempID=selectedPO;
            }
          });
        });
        // userModel.otherskill.add("");
        // stringListReturnedFromApiCall.forEach((str) {

        // });
        _startdatetimeKa.text = dataID[0]['rw_date_start'];
        _enddatetimeKa.text = dataID[0]['rw_date_end'];
        var start = DateFormat("dd/MM/yyyy").parse(dataID[0]['rw_date_start']);
        var starts= start.toString().split(" ")[0];
        startD = starts;
        print(startD);
        var end = DateFormat("dd/MM/yyyy").parse(dataID[0]['rw_date_end']);
        var ends= end.toString().split(" ")[0];
        endD = ends;
        print(endD);
        selectedKa = dataID[0]['wc_id'];
        _detailKa.text = dataID[0]['rw_details'];
      });
    });
    _detailKa.addListener(() {
      setState(() {
        // isButtonActive = controllerhedpon.text.isNotEmpty;
      });
    });
    print(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          title: const Text("แก้ไขกะการทำงาน"),
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
                              height: 50,
                            ),
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
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
                                  controller: _startdatetimeKa,
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
                                    _startdatetimeKa.text = DateFormat('dd/MM/yyyy').format(startdateTime!);
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
                                  padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
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
                                  controller: _enddatetimeKa,
                                  enabled: _startdatetimeKa.text.isNotEmpty  ? true : false,
                                  decoration: InputDecoration(
                                    // label: Text("เลือกวันที่"),
                                    filled: _startdatetimeKa.text.isNotEmpty ? false : true,
                                    fillColor: Colors.grey.shade200,
                                    suffixIcon: Icon(
                                      Icons.calendar_today_outlined,
                                      color: _startdatetimeKa.text.isNotEmpty ? Colors.green : Colors.grey,
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                  onTap: () async{
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    await pickEndDate(context);
                                    _enddatetimeKa.text = DateFormat('dd/MM/yyyy').format(enddateTime!);
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
                              onChanged: _enddatetimeKa.text.isEmpty ? null : (value) {
                                setState(() {
                                  selectedKa = value as String;
                                });
                              },
                              validator: (value) => (selectedKa == '' || selectedKa == null)
                                  ? ''
                                  : null,
                              decoration: InputDecoration(
                                filled: _enddatetimeKa.text.isNotEmpty ? false : true,
                                fillColor: Colors.grey.shade200,
                                border: OutlineInputBorder(),
                              ),
                              items: ListKa.map((valueItem) {
                                return DropdownMenuItem<String>(
                                    value: valueItem['ID'].toString(),child: Text("${valueItem['time_in']}-${valueItem['time_out']}")
                                );
                              }).toList(),
                              onSaved: (val){
                                setState(() {
                                  userModel.ka = val!;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            selectedKa == null ? const SizedBox()
                            :Column(
                              children: [
                                emailsContainerUI(),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            empContainer(),
                            // Container(
                            //   width: double.infinity,
                            //   child: ElevatedButton(
                            //       onPressed: (){
                            //         print(userModel.otherskill.length);
                            //         if(userModel.otherskill.length == 0 && empModel.empName.isEmpty){
                            //           if(ListempID.length > 0){
                            //             ListempID.removeAt(0);
                            //           }
                            //         }
                            //         if(empModel.empName.isEmpty){
                            //           print("a");
                            //           print("N.${ListempID.length}");
                            //           addEmpControl2(ListempID.length);
                            //         }else{
                            //           addEmpControl2(ListempID.length);
                            //           print("b");
                            //         }
                            //       },
                            //       child: Text("เพิ่มพนักงาน")),
                            // ),

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
                              // autofocus: false,
                              // showCursor: true,
                              readOnly: false,
                              // enabled: selectedStatus != null ? true : false,
                              controller: _detailKa,
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
                                          backgroundColor: Colors.red,
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
                                          backgroundColor: _startdatetimeKa.text.isNotEmpty &&
                                              _enddatetimeKa.text.isNotEmpty &&
                                              _detailKa.text.isNotEmpty &&
                                              selectedKa != null
                                              ? Colors.green : Colors.grey.shade300,
                                          primary: Colors.white,
                                          // minimumSize: Size(width, 100),
                                        ),
                                        onPressed: _startdatetimeKa.text.isNotEmpty &&
                                            _enddatetimeKa.text.isNotEmpty &&
                                            _detailKa.text.isNotEmpty &&
                                            selectedKa != null
                                            ?()=>
                                            setState(() {
                                              FocusScope.of(context).requestFocus(FocusNode());
                                              final form = globalFormKey.currentState;
                                              if (form!.validate()) {
                                                form.save();
                                                print("save.${ListempID}");
                                                var jsdata = {
                                                  "rw_date_start": startdateTime == null
                                                      ? "${startD}"
                                                      : "${_startdatetimeKa.text = DateFormat('yyyy-MM-dd').format(startdateTime!)}",
                                                  "rw_date_end": enddateTime == null
                                                      ? "${endD}"
                                                      : "${_enddatetimeKa.text = DateFormat('yyyy-MM-dd').format(enddateTime!)}",
                                                  "wc_id":"${selectedKa}",
                                                  // "reqW_emp":"${ListempID.toString().replaceAll('[', '').replaceAll(']','')}",
                                                  // "reqW_emp":"${ListempID =List<dynamic>.from(ListempID)}",
                                                  "rw_emp":"${ListempID.join(",")}",
                                                  "rw_details":"${_detailKa.text}"
                                                };
                                                senddata(jsdata);
                                                context.loaderOverlay.show();
                                                print(jsdata);


                                              }
                                              // MyDialog().alertForm(context);

                                            })
                                            : null
                                        ,
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
                  onChanged: (value) {
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
                  readOnly: false,
                  enabled: false,
                  // initialValue: this.userModel.otherskill[index],
                  obscureText: false,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'ทักษะที่ ${index + 1} มีค่าว่าง';
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
          // Visibility(
          //     child: SizedBox(
          //       width: 35,
          //       child: IconButton(
          //         icon: Icon(
          //           Icons.add_circle,
          //           color: Colors.green,
          //         ),
          //         onPressed: () {
          //           print(index);
          //           addEmpControl2(index);
          //         },
          //       ),
          //     ),
          //     // visible: index == this.empModel.empName.length- 1
          //   visible: index >= empName.length-1 || index == this.userModel.otherskill.length- 1,
          // ),
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

  void addEmailControl(index) {
    try{
      print("index.${index}");
      setState(() {
        userModel.otherskill.add("");
        selectedPO.add(ListPos[0]['id']);
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


//////////////////////////////////////////////////////////////////////////////////////////////////
  Widget empContainer(){
    return ListView.separated(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: empModel.empName.length,
      itemBuilder: (context, index) {
        print("ui.${index}");
        return Column(
          children: <Widget>[
            Row(
                children: <Widget>[
                  Flexible(
                    fit: FlexFit.loose,
                    child: empUI(index),
                  ),
                ]),
          ],
        );
      },
      separatorBuilder: (context, index) => Divider(),
    );
  }

  Widget empUI(index){
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
                  // value: selectedPO[index],
                  onChanged: (value) {
                    setState(() {
                      // selectPOS = value!;
                      // ListNewID.add(value!);
                      // print("v=${ListNewID}");
                      // ListempID.add(value!);
                      // print(selectedPO);
                      ListPos.forEach((element) {
                        if(element['id'] == value){
                          empControllers[index].text = element['name'];
                          // if(ListempID.length > index){
                          //   ListempID.removeAt(index);
                          // }else{
                          //   ListempID.add(element['id']);
                          //   print(ListempID);
                          // }

                        }
                      });
                      print("top.${ListempID}");

                      if(ListempID.length > 0){
                        var itempos = false;
                        print("2");
                        ListempID.forEach((item) =>{
                          if(item == value){
                            print("3"),
                            itempos = true,
                            empControllers[index].text = "",
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

                              },
                            ).show(),
                            this.empModel.empName.removeAt(index),
                            // selectedPO.removeAt(index),
                            print("dot.${ListempID}"),
                            print("เลือกไม่ได้")
                          }
                        });
                        if(itempos == false){
                          print("4");
                          // ListempID.add(value);
                          // print(ListempID);
                          if(ListempID.length > index){
                            print("5");
                            // ListempID.removeAt(index);
                            print(ListempID);
                          }
                          print("6");
                          ListempID.add(value);
                          print("111.${ListempID}");

                        }

                      }else{
                        print("7");
                        ListempID.add(value);
                        print(ListempID);
                      }


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
                  controller: empControllers[index],
                  autofocus: false,
                  // focusNode: FocusNode(),
                  showCursor: true,
                  readOnly: false,
                  enabled: false,
                  // initialValue: this.userModel.otherskill[index],
                  obscureText: false,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'ทักษะที่ ${index + 1} มีค่าว่าง';
                    }
                    return null;
                  },
                  onSaved: (val){
                    empModel.empName[index] = val!;
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
          // Visibility(
          //     child: SizedBox(
          //       width: 35,
          //       child: IconButton(
          //         icon: Icon(
          //           Icons.add_circle,
          //           color: Colors.green,
          //         ),
          //         onPressed: () {
          //           addEmpControl2(index);
          //         },
          //       ),
          //     ),
          //     visible: index == this.empModel.empName.length - 1 && index < empName.length-1
          // ),
          Visibility(
            child: SizedBox(
              width: 35,
              child: IconButton(
                icon: Icon(
                  Icons.remove_circle,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  removeEmpControl("${index}");
                },
              ),
            ),
            visible: index >= 0,
          )
        ],
      ),
    );
  }

  void addEmpControl() {
    try{
      setState(() {
        this.empModel.empName.add("");
      });
    }catch(e){
      print(e);
    }
  }

  void addEmpControl2(index) {
    try{
      setState(() {
        // print(empControllers);
        this.empModel.empName.add("${index}");
        empControllers[index].text = "";
      });
    }catch(e){
      print(e);
    }
  }

  void removeEmpControl(index) {
    try{
      var i = int.parse(index);
      var i2 = i;
      var list;
      if(userModel.otherskill.length == 0){
        list = i;
        print("5");
      }else{
        if(i2 >=0 ){
          print("if");
          i2++;
        }
        list = ListempID.length-(i2);
      }


      print("ไอ.${i}");
      print("ไอ2.${i2}");
      print("ลิส.${list}");
      print("La.${ListempID}");
      print("PO.${selectedPO}");
      print("empmo.${empModel.empName}");
      setState(() {
        print(empControllers);
        // empControllers[i2].text = "";
        if(empModel.empName.length > i){
          empModel.empName.removeAt(i);
          print("empmo.${empModel.empName}");

          ListempID.removeAt(list);

          print("L.${ListempID}");
        }else{
          empModel.empName.removeAt(i);
          ListempID.removeAt(i);
          print("Last.${ListempID}");
        }

        // if(empModel.empName.length > index){
        //
        // }
        // else{
        //   empModel.empName.removeAt(index);
        //   ListempID.removeLast();
        //   print("3.${ListempID}");
        // }

        // if (userModel.otherskill.length >0) {
        //   userModel.otherskill.removeAt(index);
        //   textEditingControllers[index].text="";

        //   selectedPO.removeAt(index);
        //   print(selectedPO);
        //   print(ListempID);
        //   print("123");
        // }
      });
    }catch(e){
      print(e);
    }

  }
}
