import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:index/api/url.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widjet/popupAlert.dart';

class DocResignPage extends StatefulWidget {
  const DocResignPage({Key? key}) : super(key: key);

  @override
  State<DocResignPage> createState() => _DocResignPageState();
}

class _DocResignPageState extends State<DocResignPage> {
  bool isButtonActive = false;
  bool loading = false;
  final  controllerhedpon = TextEditingController();
  TextEditingController _dateActive = TextEditingController();

  String token = "";
  Future<Null> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
    await getDataHeader();
    await getDataKa();
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

  DateTime? activeDate;
  Future<DateTime?> pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    DateTime? newdate = await showDatePicker(
        context: context,
        helpText: 'เลือกวันที่',
        confirmText: 'ตกลง',
        cancelText: 'ยกเลิก',
        // selectableDayPredicate: (DateTime val) => val !=  DateTime(2022,08,07) && val !=  DateTime(2022,08,13) && val !=  DateTime(2022,08,14),
        // selectableDayPredicate: _predicate,
        initialDate: DateTime(initialDate.year,initialDate.month,initialDate.day+15),
        firstDate: DateTime(initialDate.year,initialDate.month,initialDate.day+15),
        lastDate: DateTime(initialDate.year+1,initialDate.month,initialDate.day),
        // firstDate: DateTime(DateTime.now().year - 5),
        // lastDate: DateTime(DateTime.now().year + 5),
        // currentDate: DateTime.now(),
        initialEntryMode: DatePickerEntryMode.calendar,
        initialDatePickerMode: DatePickerMode.day,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme:  const ColorScheme.light(
                primary: Colors.deepPurpleAccent,
                onSurface: Colors.grey,
              ),
            ),

            child: child!,
          );
        });
    if (newdate == null){
      activeDate = initialDate;
      print('ไม่ได้เลือกวันที่');
    }else{
      print('เลือกวันที่เรียบร้อย');
      activeDate = newdate;
      return newdate;
    }
  }

  Future<Null> senddata(data) async{
    String url = pathurl.sendDTResign;
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
          desc: 'เนื่องจาก${res['message']}',
          btnOkText: "ตกลง",
          btnCancelText: "ยกเลิก",
          btnOkOnPress: () {
            // Navigator.pop(context);
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
    getToken();
    controllerhedpon.addListener(() {
      setState(() {
        // isButtonActive = controllerhedpon.text.isNotEmpty;
      });
    });
    Future.delayed(const Duration(seconds: 1),(){
      setState(() {
        loading = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    controllerhedpon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          title: const Text("ขอลาออก"),
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
                    elevation: 3,
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Colors.white)),
                    child: Container(
                      width: double.infinity,
                      // height: 200,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(15),
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
                          const SizedBox(
                            height: 40,
                          ),
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                                alignment: Alignment.topLeft,
                                child: const Text(
                                  "วันที่สิ้นสุดการทำงาน",
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
                                // showCursor: true,
                                readOnly: true,
                                controller: _dateActive,
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
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  await pickDate(context);
                                  _dateActive.text = DateFormat('dd/MM/yyyy').format(activeDate!);
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
                                padding: const EdgeInsets.only(
                                    left: 0.0, bottom: 4.0),
                                alignment: Alignment.topLeft,
                                child: const Text(
                                  "เหตุผลที่ลาออก",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              TextFormField(
                                controller: controllerhedpon,
                                enabled: true,
                                maxLines: 10,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  hintText: "กรุณากรอกรายละเอียด",
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade700)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
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
                                      borderRadius:
                                      BorderRadius.circular(5)),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 3,
                                        backgroundColor: Colors.amber,
                                        // minimumSize: Size(width, 100),
                                      ),
                                      onPressed: controllerhedpon.text.isNotEmpty
                                          ? (){
                                        setState(() {
                                          var jsdt = {
                                            "re_date": DateFormat("yyyy-MM-dd").format(activeDate!),
                                            "re_details": controllerhedpon.text
                                          };
                                          print(jsdt);
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
                                              FocusScope.of(context).requestFocus(FocusNode());
                                              senddata(jsdt);
                                              context.loaderOverlay.show();
                                            },
                                            btnCancelOnPress: (){
                                              FocusScope.of(context).requestFocus(FocusNode());
                                            },
                                          ).show();
                                        });
                                      }
                                          : null,
                                      child: Text('บันทึก')),
                                ),
                              ),
                            ],
                          ),
                          // Expanded(
                          //   flex: 0,
                          //   child: Container(
                          //     width: double.infinity,
                          //     // padding: const EdgeInsets.only(right: 16, left: 16),
                          //     // margin: EdgeInsets.all(10),
                          //     // alignment: Alignment.center,
                          //     decoration: BoxDecoration(
                          //       // border: Border.all(
                          //       //     color: Colors.grey.shade500
                          //       // ),
                          //         borderRadius: BorderRadius.circular(5)
                          //     ),
                          //     child: TextButton(
                          //         style: TextButton.styleFrom(
                          //           backgroundColor: Colors.green,
                          //           primary: Colors.white,
                          //           // minimumSize: Size(width, 100),
                          //         ),
                          //         onPressed: (){},
                          //         child: Text('บันทึก')),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
