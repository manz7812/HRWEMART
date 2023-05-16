import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:index/api/url.dart';

import '../../../widjet/popupAlert.dart';

class DTMDocOTDetailPage extends StatefulWidget {
  final  String id;
  const DTMDocOTDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DTMDocOTDetailPage> createState() => _DTMDocOTDetailPageState();
}

class _DTMDocOTDetailPageState extends State<DTMDocOTDetailPage> {
  bool loading = false;

  final TextEditingController _note = TextEditingController();

  onGoBack(dynamic value) {
    getToken();
  }

  String token = "";
  Future<Null> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
    await getdata();

  }
  String? dt;
  String? img;
  List dataNote = [];
  List dataID = [];
  List dataEmp = [];

  Future<Null> getdata() async {
    try{
      setState(() {
        loading = false;
      });
      String url = pathurl.dtmOTId+widget.id;
      print(url);
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
          // print(dataID);
          dataEmp.add(data['data'][0]['ot_emp']);
          if(data['data'][0]['ot_note'] == ""){
            dataNote = [];
          }else{
            dataNote = data['data'][0]['ot_note'];
          }
          var startDate = dataID[0]['ot_date_start'];
          var createdDate = dataID[0]['ot_date_created'];
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
      print("e= $e");
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
    var dateStart = DateFormat("dd/MM/yyyy HH:mm").parse(start);
    var dateCreate = DateFormat("dd/MM/yyyy HH:mm").parse(create);
    St = dateStart;
    Cre = dateCreate;
    print(St);
    print(Cre);
    var timeFormat = DateFormat("HH:mm");
    String timePortion = timeFormat.format(dateStart);
    print(timePortion);
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
    getToken();
    print(widget.id);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text("รายละเอียดโอที"),
        // leading: IconButton(
        //   onPressed: () {
        //     // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyDrawer(),), (route) => true);
        //     Navigator.of(context).pop();
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
                    decoration: dataID[0]['ot_status'] == 'ยกเลิก' ? BoxDecoration(
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
                        // const SizedBox(height: 20),
                        ////ย้อนหลัง////
                        // Cre! > St!
                        // ?Container(
                        //   decoration: BoxDecoration(
                        //       border: Border.all(color: Colors.red,width: 1.5),
                        //       borderRadius: BorderRadius.circular(5),
                        //       color: Colors.red.shade100
                        //   ),
                        //   padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        //   alignment: Alignment.center,
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       numHH! < 24
                        //           ?Text("ขอย้อนหลัง ${numHH} ชั่วโมง",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.red),)
                        //           :Text("ขอย้อนหลัง ${numDay} วัน",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.red),),
                        //       Text("ขอเมื่อวันที่ ${dataID[0]['rw_date_created']}",style: TextStyle(fontSize: 16,color: Colors.red),),
                        //     ],
                        //   ),
                        // )
                        // ////ล่วงหน้า////
                        // :Container(
                        //   decoration: BoxDecoration(
                        //       border: Border.all(color: Colors.green,width: 1.5),
                        //       borderRadius: BorderRadius.circular(5),
                        //       color: Colors.green.shade100
                        //   ),
                        //   padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        //   alignment: Alignment.center,
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       numHH! < 24
                        //           ?Text("ขอล่วงหน้า ${numHH} ชั่วโมง",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.green),)
                        //           :Text("ขอล่วงหน้า ${numDay} วัน",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.green),),
                        //       Text("ขอเมื่อวันที่ ${dataID[0]['rw_date_created']}",style: TextStyle(fontSize: 16,color: Colors.green),),
                        //     ],
                        //   ),
                        // ),
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
                            Text("${dataID[0]['ot_id']}",style: TextStyle(fontSize: 16,color: Colors.black),),
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
                                "ประเภทพนักงาน",
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
                                  "${dataID[0]['ot_emp_type']}",
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
                                "ประเภทโอที",
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
                                  "${dataID[0]['ot_type']}",
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
                                "กะพนักงาน",
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
                                  "${dataID[0]['wc_name']}",
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
                                "เริ่มวันที่/เวลา",
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
                                  "${dataID[0]['ot_date_start']}",
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
                                "ถึงวันที่/เวลา",
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
                                  "${dataID[0]['ot_date_end']}",
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
                        // Container(
                        //   padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
                        //   alignment: Alignment.centerLeft,
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       const Text(
                        //         "เปลี่ยนเป็นกะ",
                        //         style: TextStyle(
                        //           color: Colors.black,
                        //           fontWeight: FontWeight.w600,
                        //           fontSize: 16,
                        //         ),
                        //         textAlign: TextAlign.left,
                        //       ),
                        //       Container(
                        //         padding: EdgeInsets.fromLTRB(25, 0, 10, 10),
                        //         child: Text(
                        //           "${dataID[0]['wc_id'].replaceAll('[', '').replaceAll(']','')}",
                        //           style: TextStyle(
                        //             color: Colors.black,
                        //             fontWeight: FontWeight.w400,
                        //             fontSize: 16,
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Container(
                          padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "ชั่วโมงโอที",
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
                                  "${dataID[0]['ot_total_hours']} ชม.",
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
                                padding: EdgeInsets.fromLTRB(25, 0, 10, 0),
                                child: Text(
                                  "${dataID[0]['ot_details']}",
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
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
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
                                "${dataID[0]['ot_status']}",
                                style: TextStyle(
                                  color: dataID[0]['ot_status'] == 'อนุมัติ' ? Colors.green
                                      : dataID[0]['ot_status'] == 'ไม่อนุมัติ' || dataID[0]['ot_status'] == 'ยกเลิก'? Colors.red
                                      : dataID[0]['ot_status'] == 'ตีกลับ' ? Colors.orange
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
                                "โดย : ",
                                style: TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "${dataID[0]['emp_created']['name'].split(" ")[1]} ${dataID[0]['emp_created']['name'].split(" ")[2]}",
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
                            "รายชื่อพนักงาน : ",
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
                          itemCount: dataEmp.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemBuilder: (context , i){
                            return ListEmp(dataEmp[i]);
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                )
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

  Widget ListEmp(item){
    var name = item['pos_name'];
    var imgurl = item['img_url'];
    var approneName = item['name'].toString().split(' ');
    var appName = approneName;
    var nicname = item['nick_name'];
    var hourOT = item['total_hours'];
    var money = item['wages'];

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
                child: ClipOval(
                  child: imgurl != ""
                      ?Image.network(imgurl)
                      :Image.asset("images/avatars.png"),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${name}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black87),),
                Text("${appName[1]} ${appName[2]}(${nicname})",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black87),),
                Text("OT: ${hourOT} ชม.",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black87),),
                Text("รายได้: ${money} บาท",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black87),),
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
