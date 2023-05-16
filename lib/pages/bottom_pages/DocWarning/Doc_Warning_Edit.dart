import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:index/api/ModelSkill.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/url.dart';
import '../../widjet/popupAlert.dart';

class EditDocWaringPage extends StatefulWidget {
  final String id;
  const EditDocWaringPage({Key? key, required this.id}) : super(key: key);

  @override
  State<EditDocWaringPage> createState() => _EditDocWaringPageState();
}

class _EditDocWaringPageState extends State<EditDocWaringPage> {
  bool loading = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  TextEditingController _header = TextEditingController();
  TextEditingController _detailheader = TextEditingController();
  TextEditingController _repeatsame = TextEditingController();
  TextEditingController _otherdetail = TextEditingController();

  String token = "";
  Future<Null> getToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
    await getDataHeader();
    await getDataKa();
    await listMistake();
    await getdata();
    await listemp();
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

  late SkillModel userModel = SkillModel(
      List<String>.empty(growable: true),
      ""
  );

  var stringListReturnedFromApiCall = [];
  List<TextEditingController> textEditingControllers = [];
  List<String> selectedPO = [];
  String? selectPOS;
  List ListPos = [];
  List ListempID = [];
  String? wlPos;

  Future<Null> listemp()async{
    String url = pathurl.listempWarning+"?pos_id=${dataID[0]['emp_created']['pos_id']}";
    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
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

    print(stringListReturnedFromApiCall);
  }

  String? selectedMistake;
  List ListMistake = [];
  Future<Null> listMistake() async{
    String url = pathurl.listPunish;
    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
      ListMistake = data['data'];
      print(ListMistake);
    }
  }

  List dataID = [];
  List dataEmp = [];
  Future<Null> getdata() async {
    try{
      setState(() {
        loading = false;
      });
      String url = pathurl.getDTDocWarningID+widget.id;
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
          // print(dataID[0]['wl_emp']);
          // dataEmp.add(dataID[0]['wl_emp']);
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
      print("e=$e");
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

  Future<Null> senddata(data) async{
    String url = pathurl.updateDTDocWarningID+widget.id;
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
      context.loaderOverlay.hide();
      popup().sessionexpire(context);
    }else if(response.statusCode == 403){
      context.loaderOverlay.hide();
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
      context.loaderOverlay.hide();
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
    super.initState();

    getToken();

    Future.delayed(const Duration(seconds: 1),(){
      setState(() {
        loading = true;
      });
      _header.addListener(() {
        setState(() {});
      });
      _detailheader.addListener(() {setState(() {});});
      _repeatsame.addListener(() {setState(() {});});
      _otherdetail.addListener(() {setState(() {});});

      _header.text = dataID[0]['wl_name'];
      _detailheader.text = dataID[0]['wl_details'];

      Future.delayed(const Duration(milliseconds: 900));
      // selectedMistake = "ตักเตือนด้วยวาจา";
      selectedMistake = dataID[0]['wl_punish'];
      print(dataID[0]['wl_punish']);
      _otherdetail.text = dataID[0]['wl_other'];
      _repeatsame.text = dataID[0]['wl_remark'];

      stringListReturnedFromApiCall.forEach((str) {
        var textEditingController = TextEditingController(text: "");
        textEditingControllers.add(textEditingController);
        selectedPO.add(ListPos[0]['id']);
      });
      selectedPO[0]=dataID[0]['wl_emp']['id'];
      print("selectedPO = $selectedPO");
      ListempID.add(dataID[0]['wl_emp']['id']);
      print("ListempID = $ListempID");
      textEditingControllers[0].text = "${dataID[0]['wl_emp']['name'].split(" ")[1]} ${dataID[0]['wl_emp']['name'].split(" ")[2]}";
      wlPos = dataID[0]['wl_emp']['pos_id'];
      print("wlPos = $wlPos");
      print("pos_id = ${dataID[0]['emp_created']['pos_id']}");


    });

    userModel.otherskill.add("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          title: const Text("แก้ไขขอหนังสือเตือน"),
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
                    elevation: 3,
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Colors.white)
                    ),
                    child: Container(
                      width: double.infinity,
                      // height: 200,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(15),
                      child: Form(
                        key: globalFormKey,
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
                              height: 40,
                            ),
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                                  alignment: Alignment.topLeft,
                                  child: const Text(
                                    "เรื่อง",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                TextFormField(
                                  controller: _header,
                                  // focusNode: FocusNode(),
                                  showCursor: true,
                                  readOnly: false,
                                  validator: (value) => (value!.isEmpty) ? '' : null,
                                  maxLines: 2,
                                  // maxLength: 9999,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    hintText: "กรุณากรอกรายละเอียด",
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade700)
                                    ),
                                  ),
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
                                  controller: _detailheader,
                                  // focusNode: FocusNode(),
                                  enabled: _header.text.isEmpty ? false : true,
                                  showCursor: true,
                                  readOnly: false,
                                  validator: (value) => (value!.isEmpty) ? '' : null,
                                  maxLines: 4,
                                  // maxLength: 9999,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    hintText: "กรุณากรอกรายละเอียด",
                                    filled: _header.text.isEmpty ? true : false,
                                    fillColor: Colors.grey.shade300,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade700)
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                              alignment: Alignment.topLeft,
                              child: const Text(
                                "วิธีการลงโทษ",
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
                              value: selectedMistake,
                              onChanged: _detailheader.text.isNotEmpty ? (value) {
                                setState(() {
                                  selectedMistake = value as String;
                                });
                              } : null,
                              validator: (value) => (selectedMistake == '' || selectedMistake == null)
                                  ? ''
                                  : null,
                              // autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                filled: _detailheader.text.isEmpty ? true : false,
                                fillColor: Colors.grey.shade300,
                                border: OutlineInputBorder(
                                  // borderSide: const BorderSide(color: Colors.green, width: 2.0),
                                ),

                              ),
                              items: ListMistake.map((valueItem) {
                                return DropdownMenuItem<String>(
                                    value: valueItem['name'].toString(),child: Text(valueItem['name'])
                                );
                              }).toList(),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Column(
                              children: [
                                selectedMistake == "อื่นๆ" ?
                                TextFormField(
                                  controller: _otherdetail,
                                  // focusNode: FocusNode(),
                                  showCursor: true,
                                  readOnly: false,
                                  validator: (value) => (value!.isEmpty) ? '' : null,
                                  maxLines: 4,
                                  // maxLength: 9999,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    hintText: "กรุณากรอกรายละเอียด อื่นๆ",
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade700)
                                    ),
                                  ),
                                )
                                    :SizedBox(),
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
                                    "หากกระทำผิดซ้ำเรื่องเดิม พิจารณา",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                TextFormField(
                                  controller: _repeatsame,
                                  // focusNode: FocusNode(),
                                  showCursor: true,
                                  readOnly: false,
                                  // validator: (value) => (value!.isEmpty) ? '' : null,
                                  maxLines: 6,
                                  // maxLength: 9999,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    hintText: "กรุณากรอกรายละเอียด",
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade700)
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            EmpContainerUI(),
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
                                          backgroundColor:  Colors.green,
                                          // primary: Colors.white,
                                          // minimumSize: Size(width, 100),
                                        ),
                                        onPressed: _header.text.isNotEmpty &&
                                            _detailheader.text.isNotEmpty &&
                                            selectedMistake != null
                                            ? ()=>setState(() {
                                          FocusScope.of(context).requestFocus(FocusNode());
                                          final form = globalFormKey.currentState;
                                          if (form!.validate()) {
                                            form.save();
                                            var jsdt = {
                                              "wl_name": _header.text,
                                              "wl_details": _detailheader.text,
                                              "wl_punish": selectedMistake,
                                              "wl_other": _otherdetail.text,
                                              "wl_remark": _repeatsame.text,
                                              "wl_emp": ListempID.join(","),
                                              "wl_pos": wlPos,
                                              "pos_id": dataID[0]['emp_created']['pos_id']
                                            };
                                            print(jsdt);
                                            print(wlPos);
                                            senddata(jsdt);
                                            context.loaderOverlay.show();
                                          }else{

                                          }
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
                    ),
                  )
                ],
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

  Widget EmpContainerUI() {
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
                    child: EmpUI(index),
                  ),
                ]),
          ],
        );
      },
      separatorBuilder: (context, index) => Divider(),
    );
  }

  Widget EmpUI(index) {
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
                    "พนักงาน",
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
                      print(ListPos);
                      ListPos.forEach((element) {
                        if(element['id'] == value){
                          textEditingControllers[index].text = element['name'];
                          wlPos = element['pos_id'];
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


  void addEmailControl(index) {
    try{
      print("index.${index}");
      setState(() {
        this.userModel.otherskill.add("");
        selectedPO[index+1]=ListPos[0]['id'];
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
