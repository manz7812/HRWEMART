import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/url.dart';
import '../../widjet/popupAlert.dart';

class DocDebResignDetail extends StatefulWidget {
  final String id;
  const DocDebResignDetail({Key? key, required this.id}) : super(key: key);

  @override
  State<DocDebResignDetail> createState() => _DocDebResignDetailState();
}

class _DocDebResignDetailState extends State<DocDebResignDetail> {
  bool loading = false;

  final  controllerhedpon = TextEditingController();
  TextEditingController _dateActive = TextEditingController();
  final TextEditingController _note = TextEditingController();

  String token = "";
  Future<Null> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
    getdata();
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
      String url = pathurl.fResignId+widget.id;
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

  @override
  void initState() {
    super.initState();
    print(widget.id);
    getToken();
    Future.delayed(const Duration(seconds: 1),(){
      setState(() {
        loading = true;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text("รายละเอียดลาออก"),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
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
          ),
        ),
      ),
      body: loading ? SingleChildScrollView(
        child: Container(
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ) : const Center(
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
