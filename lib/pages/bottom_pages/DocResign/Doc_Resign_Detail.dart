import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:basics/basics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:http/http.dart';
import 'package:index/api/url.dart';
import 'package:index/pages/widjet/myAlertLocation.dart';
import 'package:index/pages/widjet/popupAlert.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DetailDocResignPage extends StatefulWidget {
  final String id;
  final Function? onGoBack;
  const DetailDocResignPage({Key? key, required this.id,this.onGoBack}) : super(key: key);

  @override
  State<DetailDocResignPage> createState() => _DetailDocResignPageState();
}


class _DetailDocResignPageState extends State<DetailDocResignPage> {
  bool loading = false;

  final  controllerhedpon = TextEditingController();
  TextEditingController _dateActive = TextEditingController();
  final TextEditingController _note = TextEditingController();

  onGoBack(dynamic value) {
    getToken();
  }

  String token = "";
  Future<Null> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
    getdata();
    getDataHeader();
    getDataKa();
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

  String? dt;
  String? img;
  List dataApprover = [];
  List dataNote = [];
  List dataID = [];

  Future<Null> getdata() async {
    try{
      setState(() {
        loading = false;
      });
      String url = pathurl.getDTResignID+widget.id;
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
          print(dataID);
          dataApprover = data['data'][0]['re_approve'];
          if(data['data'][0]['re_note'] == ""){
            dataNote = [];
          }else{
            dataNote = data['data'][0]['re_note'];
          }
          var startDate = dataID[0]['re_date'];
          var createdDate = dataID[0]['re_date_created'];
          checkDate(startDate,createdDate);
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

  int? numDay;
  int? numHH;
  DateTime? St;
  DateTime? Cre;
  Future<Null> checkDate(start,create) async{
    var dateStart = DateFormat("dd/MM/yyyy HH:mm").parse("${start} 00:00");
    var dateCreate = DateFormat("dd/MM/yyyy HH:mm").parse(create);
    St = dateStart;
    Cre = dateCreate;
    print(St);
    print(Cre);
    // DateTime kho = DateTime.parse("2022-06-02 10:32:00");
    // DateTime la = DateTime.parse("2022-06-03 08:00:00");

    if(dateCreate > dateStart){
      var diff = dateCreate - dateStart;
      var i = int.parse(diff.inHours.toString());
      print("i = ${i} ชั่วโมง");
      numHH = i;
      var i2 = i/24;
      print("i2 = ${i2} วัน");
      var i3 = i2.toStringAsFixed(3).split('.')[1];
      print("i3 = ${i3}");
      var i4 = "0.${i3}";
      var i5= double.parse(i4);
      print("i5 = ${i5}");
      var i6 = i5 * 24; ////เศษวัน * 24 = ชั่วโมง
      print("i6 = ${i6} ชั่วโมง");
      print(i6.toStringAsFixed(0));
      numDay = diff.inDays;
      print("ย้อนหลัง ${numDay} วัน");
    }else{
      var diff = dateStart - dateCreate;
      var i = int.parse(diff.inHours.toString());
      print("i = ${i} ชั่วโมง");
      numHH = i;
      var i2 = i/24;
      print("i2 = ${i2} วัน");
      var i3 = i2.toStringAsFixed(3).split('.')[1];
      print("i3 = ${i3}");
      var i4 = "0.${i3}";
      var i5= double.parse(i4);
      print("i5 = ${i5}");
      var i6 = i5 * 24; ////เศษวัน * 24 = ชั่วโมง
      print("i6 = ${i6} ชั่วโมง");
      print(i6.toStringAsFixed(0));
      numDay = diff.inDays;
      print("ล่วงหน้า ${numDay} วัน");
    }

    // if(dateStart < dateCreate){
    //   print('ล่วงหน้า');
    //   var diff = dateCreate - dateStart;
    //   print(diff.inDays);
    // }else{
    //   print('ย้อนหลัง');
    //   var diff = dateCreate - dateStart;
    //   print(diff.inDays);
    // }

  }

  String? dateNow;
  String? status;
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
      if(data['data'].isNotEmpty){
        // print(data['data']);
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
            }else{
              status = data['data']['sun_day'];
            }
            break;
        }
      }else{
        status = "ยังไม่มีการตั้งค่าวันทำงาน";
      }

    }else if(response.statusCode == 401){
      // popup().sessionexpire(context);
    }

  }

  String? Ka;
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
        // print(data['data']);
        switch(WD){
          case "Mon" :
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

  Future<Null> senddata(data) async{
    String url = pathurl.updateDTResignEditID+widget.id;
    final response = await put(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
      body: data,
    );
    var res = jsonDecode(response.body.toString());
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

  Future<Null> setStatus(id,status,remark) async{
    try{
      var response = await patch(
          Uri.parse(pathurl.setStatusDocResign+id),
          headers: {"Authorization": "Bearer $token"},
          body: {
            "status": "${status}",
            "remark": "${remark}",
          }
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
          // dialogBackgroundColor: Colors.deepPurpleAccent,
          title: 'บันทึกข้อมูลสำเร็จ',
          showCloseIcon: false,
          btnOkText: "ตกลง",
          btnOkOnPress: () {
            Navigator.of(context).pushReplacement(
                PageTransition(
                  child: super.widget,
                  type: PageTransitionType.fade,
                  alignment: Alignment.bottomCenter,
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                )
            );
            // Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //         builder: (BuildContext context) => super.widget)
            // );
          },
        ).show();
      }else if(response.statusCode == 401){
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
          title: 'เชื่อมต่อเซิพเวอร์ไม่สำเร็จ',
          desc: 'กรุณาลองใหม่อีกครั้ง',
          btnOkText: "ตกลง",
          btnCancelText: "ยกเลิก",
          btnOkOnPress: () {
            Navigator.of(context).pushReplacement(
                PageTransition(
                  child: super.widget,
                  type: PageTransitionType.fade,
                  alignment: Alignment.bottomCenter,
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                )
            );
          },
        ).show();
      }else{
        ///popup บันทึกข้อมูลไม่สำเร็จ
        print(response.body);
      }
    }catch(e){
      ////server

    }
  }


  @override
  void initState() {
    print(widget.id);
    getToken();
    Future.delayed(const Duration(seconds: 1),(){
      setState(() {
        _dateActive.text = dataID[0]['re_date'];
        controllerhedpon.text = dataID[0]['re_details'];
      });
    });

    _note.addListener(() {
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
        title: const Text("รายละเอียดขอลาออก"),
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
      body: loading && dataID.length > 0 ? LoaderOverlay(
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
                    decoration: dataID[0]['re_status'] == 'ยกเลิก' ? BoxDecoration(
                      image: DecorationImage(image: AssetImage('images/cancel2.png'),
                          colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.8), BlendMode.xor),
                          repeat: ImageRepeat.repeat,
                          // fit: BoxFit.fill,
                          isAntiAlias: false
                      ),
                    ) : BoxDecoration(),
                    // alignment: Alignment.center,
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        ////ย้อนหลัง////
                        Cre! > St!
                        ?Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.red,width: 1.5),
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.red.shade100
                          ),
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              numHH! < 24
                              ?Text("ขอย้อนหลัง ${numHH} ชั่วโมง",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.red),)
                              :Text("ขอย้อนหลัง ${numDay} วัน",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.red),),
                              Text("ขอเมื่อวันที่ ${dataID[0]['re_date_created']}",style: TextStyle(fontSize: 16,color: Colors.red),),
                            ],
                          ),
                        )
                        ////ล่วงหน้า////
                        :Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.green,width: 1.5),
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.green.shade100
                          ),
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              numHH! < 24
                              ?Text("ขอล่วงหน้า ${numHH} ชั่วโมง",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.green),)
                              :Text("ขอล่วงหน้า ${numDay} วัน",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.green),),
                              Text("ขอเมื่อวันที่ ${dataID[0]['re_date_created']}",style: TextStyle(fontSize: 16,color: Colors.green),),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: <Widget>[
                        //     // Text("วันที่ : ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.black),),
                        //     Text("${dateNow?.split(' ')[0]??""} "
                        //         "${dateNow?.split(' ')[1]??""} "
                        //         "${dateNow?.split(' ')[2]??""} "
                        //         "${int.parse(dateNow?.split(' ')[3] ?? "")}",
                        //       style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black),),
                        //   ],
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: <Widget>[
                        //     Text("สถานะ : ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.black),),
                        //     Text("${status??""}",style: TextStyle(fontSize: 16,color: Colors.black),),
                        //   ],
                        // ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("หมายเลขเอกสาร : ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.black),),
                            Text("${widget.id}",style: TextStyle(fontSize: 16,color: Colors.black),),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // Container(
                        //   width: double.infinity,
                        //   // height: 200,
                        //   alignment: Alignment.center,
                        //   padding: const EdgeInsets.all(8),
                        //   child: RichText(
                        //     text:  TextSpan(
                        //       // text: 'hello',
                        //         style: const TextStyle(
                        //           fontSize: 16,
                        //           color: Colors.black87,
                        //           fontFamily: 'Prompt',
                        //         ),
                        //         children: [
                        //           TextSpan(
                        //               text: '     ข้าพเจ้า '
                        //           ),
                        //           TextSpan(
                        //             text: '${dataID[0]['re_emp']['name'].split(" ")[1]} ${dataID[0]['re_emp']['name'].split(" ")[2]}',
                        //             style: TextStyle(
                        //               // decoration: TextDecoration.underline,
                        //               // decorationStyle: TextDecorationStyle.solid,
                        //                 fontWeight: FontWeight.w700
                        //             ),
                        //           ),
                        //           const TextSpan(
                        //               text: ' รหัสพนักงาน '
                        //           ),
                        //           TextSpan(
                        //             text: '${dataID[0]['re_emp']['id']}',
                        //             style: TextStyle(
                        //               // decoration: TextDecoration.underline,
                        //               // decorationStyle: TextDecorationStyle.solid
                        //                 fontWeight: FontWeight.w700
                        //             ),
                        //           ),
                        //           const TextSpan(
                        //               text: ' ตำแหน่ง '
                        //           ),
                        //           TextSpan(
                        //             text: '${dataID[0]['re_emp']['pos_name']}',
                        //             style: TextStyle(
                        //               // decoration: TextDecoration.underline,
                        //               // decorationStyle: TextDecorationStyle.solid
                        //                 fontWeight: FontWeight.w700
                        //             ),
                        //           ),
                        //
                        //           TextSpan(
                        //             text: ' แผนก ',
                        //             style: TextStyle(
                        //               // decoration: TextDecoration.underline,
                        //               // decorationStyle: TextDecorationStyle.solid
                        //                 fontWeight: FontWeight.w700
                        //             ),
                        //           ),
                        //           TextSpan(
                        //             text: 'สังกัด',
                        //             style: TextStyle(
                        //               // decoration: TextDecoration.underline,
                        //               // decorationStyle: TextDecorationStyle.solid
                        //                 fontWeight: FontWeight.w700
                        //             ),
                        //           ),
                        //           const TextSpan(
                        //               text: ' มีความประสงค์ขอลาออกจากการเป็นพนักงานของ '
                        //           ),
                        //           TextSpan(
                        //               text: 'บริษัท...',
                        //               style: TextStyle(
                        //                   fontWeight: FontWeight.w700
                        //                 // decoration: TextDecoration.underline,
                        //                 // decorationStyle: TextDecorationStyle.solid
                        //               )
                        //           ),
                        //           const TextSpan(
                        //               text: ' เนื่องจาก'
                        //           ),
                        //           TextSpan(
                        //               text: ' ${dataID[0]['re_details']} ',
                        //               style: TextStyle(
                        //                   fontWeight: FontWeight.w700
                        //                 // decoration: TextDecoration.underline,
                        //                 // decorationStyle: TextDecorationStyle.solid
                        //               )
                        //           ),
                        //           const TextSpan(
                        //               text: ' ทั้งนี้ไม่ประสงค์จะเรียกร้องสิทธิและค่าชดเชยใดๆ ให้มีผลตั้งแต่วันที่'
                        //           ),
                        //           TextSpan(
                        //               text: ' ${dataID[0]['re_date']} ',
                        //               style: TextStyle(
                        //                   fontWeight: FontWeight.w700
                        //                 // decoration: TextDecoration.underline,
                        //                 // decorationStyle: TextDecorationStyle.solid
                        //               )
                        //           ),
                        //           const TextSpan(
                        //               text: ' เป็นต้นไป'
                        //           ),
                        //         ]
                        //     ),
                        //   ),
                        // ),

                        Container(
                          padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "วันที่สิ้นสุดการทำงาน",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(25, 0, 10, 10),
                                child: Text(
                                  "${dataID[0]['re_date']}",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 12.0, bottom: 10.0),
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "รายละเอียด",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(25, 0, 10, 0),
                                child: Text(
                                  "${dataID[0]['re_details']}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 12.0, bottom: 4.0,top: 0),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "สถานะ : ",
                                style: TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "${dataID[0]['re_status']}",
                                style: TextStyle(
                                  color: dataID[0]['re_status'] == 'อนุมัติ' ? Colors.green
                                      : dataID[0]['re_status'] == 'ไม่อนุมัติ' || dataID[0]['re_status'] == 'ยกเลิก'? Colors.red
                                      : dataID[0]['re_status'] == 'ตีกลับ' ? Colors.orange
                                      : Colors.yellow,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "โดย : ${dataID[0]['re_emp']['name'].split(" ")[1]} ${dataID[0]['re_emp']['name'].split(" ")[2]}",
                                style: TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        dataNote.isEmpty ? Container() :
                        Container(
                          padding: const EdgeInsets.only(left: 12.0, top: 10, bottom: 4.0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "*หมายเหตุ :",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        dataNote.isEmpty ? Container() :
                        ListView.builder(
                          itemCount: dataNote.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemBuilder: (context , i){
                            return ListNote(dataNote[i]);
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 12.0, top: 10, bottom: 4.0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "ลำดับขั้นการอนุมัติ : ",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(height: 3),
                        ListView.builder(
                          itemCount: dataApprover.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemBuilder: (context , i){
                            return ListApprove(dataApprover[i]);
                          },
                        ),
                        const SizedBox(height: 20),
                        dataID[0]['re_status'] == 'ตีกลับ' ?
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
                                      AwesomeDialog(
                                        context: context,
                                        dismissOnTouchOutside: false,
                                        // padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
                                        dialogType: DialogType.NO_HEADER,
                                        body: Container(
                                          padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                alignment: Alignment.topLeft,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "หมายเหตุ:",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 16,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    TextFormField(
                                                      controller: _note,
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        width: 400,
                                        buttonsBorderRadius: BorderRadius.all(Radius.circular(20)),
                                        headerAnimationLoop: false,
                                        animType: AnimType.SCALE,
                                        btnOkText: 'ตกลง',
                                        btnCancelText: 'ยกเลิก',
                                        btnOkOnPress: (){
                                          if(_note.text.isNotEmpty){
                                            // Navigator.of(context).pop();
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
                                              desc: _note.text,
                                              showCloseIcon: false,
                                              btnOkText: "ตกลง",
                                              btnCancelText: "ยกเลิก",
                                              btnOkOnPress: () {
                                                setState(() {
                                                  FocusScope.of(context).requestFocus(FocusNode());
                                                  context.loaderOverlay.show();
                                                  setStatus(widget.id, "ยกเลิก", _note.text);
                                                });
                                              },
                                              btnCancelOnPress: (){
                                                setState(() {
                                                  _note.clear();
                                                  FocusScope.of(context).requestFocus(FocusNode());
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                            ).show();
                                          }else{
                                            MyDialog().alertLogin5(context);
                                          }
                                        },
                                        btnCancelOnPress: (){},
                                      ).show();
                                    },
                                    child: Text('ยกเลิกเอกสาร')),
                              ),
                            ),
                          ],
                        )
                        :SizedBox()
                      ],
                    ),
                  ),
                ),
                dataID[0]['re_status'] == 'ตีกลับ' ?
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
                                          "re_date": activeDate == null ? DateFormat("yyyy-MM-dd").format( DateFormat('dd/MM/yyyy').parse(dataID[0]['re_date']) )
                                                                        : DateFormat("yyyy-MM-dd").format(activeDate!),
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
                )
                :SizedBox(),
              ],
            ),
          ),
        ),
      )
      : const Center(
        child: CircularProgressIndicator(
          valueColor:
          AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
          strokeWidth: 5,
        ),
      ),
    );
  }

  Widget ListApprove(item){
    var name = item['pos_name'];
    var status = item['status'];
    var imgurl = item['img_url'];
    var approneName = item['name'].toString().split(' ');
    var appName = approneName;
    var nicname = item['nick_name'];
    var No = item['No'];

    return Column(
      children: [
        Divider(
          thickness: 0.5,
          color: Colors.grey.shade300,
          indent: 15,
          endIndent: 15,
        ),
        Row(
          children: [
            Container(
              padding: EdgeInsets.only(top: 0,left: 30,right: 20,bottom: 10),
              child: CircleAvatar(
                radius: 33,
                backgroundColor: Colors.grey.shade400,
                // child: Icon(Icons.person,size: 50,color: Colors.grey.shade700),
                child: ClipOval(child: Image.network(imgurl??"http://103.82.248.220/node/api/v1/avatars/F9/avatars.png")),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ผู้อนุมัติคนที่ : ${No}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.black87),),
                Text("${name}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black87),),
                Text("${appName[1]} ${appName[2]}(${nicname})",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black87),),
                Text(
                  "${status}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: status == 'อนุมัติ' ? Colors.green
                        : status == 'ไม่อนุมัติ' || status == 'ยกเลิก'? Colors.red
                        : status == 'ตีกลับ' ? Colors.orange
                        : Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),

      ],
    );
  }

  Widget ListNote(item){
    var remark = item['remark'];
    var no = item['No'];
    return Container(
      padding: const EdgeInsets.only(left: 40.0, bottom: 4.0),
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ครั้งที่ ${no} : ",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
            // textAlign: TextAlign.left,
          ),
          Expanded(
            child: Text(
              "${remark}",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
