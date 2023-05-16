import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:index/api/url.dart';
import 'package:index/pages/widjet/myAlertLocation.dart';
import 'package:index/pages/widjet/popupAlert.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailApproveDocLa extends StatefulWidget {
  final String id;
  const DetailApproveDocLa({Key? key,required this.id}) : super(key: key);

  @override
  State<DetailApproveDocLa> createState() => _DetailApproveDocLaState();
}

class _DetailApproveDocLaState extends State<DetailApproveDocLa> {
  bool loading = false;
  String? idEmp;
  String token = "";

  TextEditingController _note = TextEditingController();

  Future<Null> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
    idEmp = preferences.getString("idEmp")!;
    getdata();
  }
  String? dt;
  String? img;
  List dataApprover = [];
  List dataNote = [];
  List dataID = [];
  bool approve = false;

  Future<Null> getdata() async {
    try{
      String url = pathurl.dataLaById+widget.id;
      final response = await get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          Future.delayed(const Duration(milliseconds: 600), () {
            setState(() {
              loading = true;
            });
          });
          dataID = data['data'];
          dataApprover = data['data'][0]['rl_approve'];
          // print(dataID);

          var startDate = dataID[0]['rl_date_start'];
          var createdDate = dataID[0]['rl_date_created'];
          var appStatus = dataID[0]['rl_approve'];
          for(var i = 0; i < appStatus.length; i++){
            if(appStatus[i]["id"] == idEmp!.toUpperCase()){
              if(appStatus[i]["No"] == 1){
                if(appStatus[i]["status"] == "รออนุมัติ"){
                  approve = true;
                }else{
                  approve = false;
                }
              }else{
                if(appStatus[i-1]["status"] == "อนุมัติ"){
                  approve = true;
                }else{
                  approve = false;
                }
              }
            }
          }

          if(data['data'][0]['rl_note'] == ""){
            dataNote = [];
          }else{
            dataNote = data['data'][0]['rl_note'];
          }
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
                      builder: (BuildContext context ) => super.widget));
            },
          ).show();
        });
      }
    }catch (e){
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
    }
  }

  int? numDay;
  int? numHH;
  DateTime? St;
  DateTime? Cre;
  String? dateNow;
  Future<Null> checkDate(start,create) async{
    var nows = DateTime.now();
    dateNow = DateFormat.yMMMEd().format(nows);
    var dateStart = DateFormat("dd/MM/yyyy HH:mm").parse(start);
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

  Future<Null> setStatus(id,status,remark) async{
    try{
      var response = await patch(
          Uri.parse(pathurl.setStatusDocLa+id),
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
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => super.widget)
            );
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
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => super.widget));
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
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text("รายละเอียดลางาน"),
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
      body: loading && dataID.length > 0 ? SingleChildScrollView(
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
                  decoration: dataID[0]['rl_status'] == 'ยกเลิก' ? BoxDecoration(
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
                            Text("ขอเมื่อวันที่ ${dataID[0]['rl_date_created']}",style: TextStyle(fontSize: 16,color: Colors.red),),
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
                            Text("ขอเมื่อวันที่ ${dataID[0]['rl_date_created']}",style: TextStyle(fontSize: 16,color: Colors.green),),
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
                      //         "${int.parse(dateNow?.split(' ')[3] ?? "")+543}",
                      //       style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black),),
                      //   ],
                      // ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("หมายเลขเอกสาร : ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.black),),
                          Text("${dataID[0]['rl_id']}",style: TextStyle(fontSize: 16,color: Colors.black),),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "วันที่(ขอ)",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(25, 0, 10, 10),
                              child: Text(
                                "${dataID[0]['rl_date_created']}",
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
                        padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "ประเภทการลา",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(25, 0, 10, 10),
                              child: Text(
                                "${dataID[0]['leave_type']}",
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
                        padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "เริ่มเวลา",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(25, 0, 10, 10),
                              child: Text(
                                "${dataID[0]['rl_date_start']}",
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
                        padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "เวลาเสร็จ",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(25, 0, 10, 10),
                              child: Text(
                                "${dataID[0]['rl_date_end']}",
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
                        padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
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
                              padding: EdgeInsets.fromLTRB(25, 0, 10, 10),
                              child: Text(
                                "${dataID[0]['rl_details']}",
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
                      const SizedBox(height: 5),
                      dataID[0]['rl_img'] == "" ? Container()
                      :Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 12.0),
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "รูปภาพแนบ",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Stack(
                            children: <Widget>[
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.network(dataID[0]['rl_img'],fit: BoxFit.cover)),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 12.0, bottom: 4.0,top: 10),
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
                              "${dataID[0]['rl_status']}",
                              style: TextStyle(
                                color: dataID[0]['rl_status'] == 'อนุมัติ' ? Colors.green
                                    : dataID[0]['rl_status'] == 'ไม่อนุมัติ' || dataID[0]['rl_status'] == 'ยกเลิก'? Colors.red
                                    : dataID[0]['rl_status'] == 'ตีกลับ' ? Colors.orange
                                    : Colors.black87,
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
                              "โดย : ${dataID[0]['rl_emp']['name'].split(" ")[1]} ${dataID[0]['rl_emp']['name'].split(" ")[2]}",
                              style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "",
                              style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
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
                      const SizedBox(height: 10),
                      Divider(
                        thickness: 0.5,
                        color: Colors.grey.shade500,
                        indent: 15,
                        endIndent: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Card(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: ElevatedButton(///อนุมัติ
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                    elevation: 3,
                                    shape: CircleBorder(),
                                  ),
                                  onPressed: dataID[0]['rl_status'] == 'อนุมัติ' ||
                                      dataID[0]['rl_status'] == "ไม่อนุมัติ" ||
                                      dataID[0]['rl_status'] == "ตีกลับ" ||
                                      dataID[0]['rl_status'] == "ยกเลิก" ||
                                      approve == false ? null
                                      : (){
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
                                        setStatus(widget.id,"อนุมัติ","");
                                      },
                                      btnCancelOnPress: (){
                                        FocusScope.of(context).requestFocus(FocusNode());
                                        _note.clear();
                                      },
                                    ).show();
                                  },
                                  child: const Icon(
                                    Icons.check_circle,
                                    size: 50,
                                    color: Colors.white,
                                  )
                              ),
                            ),
                            elevation: 5,
                          ),

                          Card(
                            elevation: 5,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: ElevatedButton(///ยกเลิก
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      elevation: 3,
                                      shape: CircleBorder()
                                  ),
                                  onPressed: dataID[0]['rl_status'] == 'อนุมัติ' ||
                                      dataID[0]['rl_status'] == "ไม่อนุมัติ" ||
                                      dataID[0]['rl_status'] == "ตีกลับ" ||
                                      dataID[0]['rl_status'] == "ยกเลิก" ||
                                      approve == false ? null
                                      : (){
                                    AwesomeDialog(
                                      context: context,
                                      dismissOnTouchOutside: false,
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
                                            buttonsBorderRadius: BorderRadius.all(Radius.circular(10)),
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
                                                setStatus(widget.id, "ไม่อนุมัติ", _note.text);
                                              });
                                            },
                                            btnCancelOnPress: (){
                                              _note.clear();
                                              FocusScope.of(context).requestFocus(FocusNode());
                                            },
                                          ).show();
                                        }else{
                                          // MyDialog().alertLogin5(context);
                                        }
                                      },
                                      btnCancelOnPress: (){},
                                    ).show();
                                  },
                                  child: const Icon(
                                    Icons.cancel,
                                    size: 50,
                                    color: Colors.white,
                                  )
                              ),
                            ),
                          ),
                          Card(
                            elevation: 5,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: ElevatedButton(///ตีกลับ
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.orange,
                                      elevation: 3,
                                      shape: CircleBorder()
                                  ),
                                  onPressed: dataID[0]['rl_status'] == 'อนุมัติ' ||
                                      dataID[0]['rl_status'] == "ไม่อนุมัติ" ||
                                      dataID[0]['rl_status'] == "ตีกลับ" ||
                                      dataID[0]['rl_status'] == "ยกเลิก" ||
                                      approve == false ? null
                                      : (){
                                    AwesomeDialog(
                                      context: context,
                                      dismissOnTouchOutside: false,
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
                                            buttonsBorderRadius: BorderRadius.all(Radius.circular(10)),
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
                                                setStatus(widget.id, "ตีกลับ", _note.text);
                                              });
                                            },
                                            btnCancelOnPress: (){
                                              _note.clear();
                                              FocusScope.of(context).requestFocus(FocusNode());
                                            },
                                          ).show();
                                        }else{
                                          MyDialog().alertLogin5(context);
                                        }
                                      },
                                      btnCancelOnPress: (){},
                                    ).show();
                                  },
                                  child: const Icon(
                                    Ionicons.reload_circle,
                                    size: 50,
                                    color: Colors.white,
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
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
