import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:index/api/url.dart';
import 'package:index/pages/widjet/myAlertLocation.dart';
import 'package:index/pages/widjet/popupAlert.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailApproveDocHuman extends StatefulWidget {
  final String id;

  const DetailApproveDocHuman({Key? key,required this.id}) : super(key: key);

  @override
  State<DetailApproveDocHuman> createState() => _DetailApproveDocHumanState();
}

class _DetailApproveDocHumanState extends State<DetailApproveDocHuman> {
  bool loading = false;
  String? dt;
  String? img;
  String? idEmp;
  TextEditingController _note = TextEditingController();

  String token = "";
  Future<Null> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
    idEmp = preferences.getString("idEmp")!;
    getdata();
    // print(token);
  }

  List dataApprover = [];
  List dataID = [];
  List dataNote = [];
  bool approve = false;
  Future<Null> getdata() async {
    try{
      String url = pathurl.urldataHumanById+widget.id;
      final response = await get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          dataID = data['data'];
          dataApprover = data['data'][0]['req_approve'];
          if(data['data'][0]['req_note'] == ""){
            dataNote = [];
          }else{
            dataNote = data['data'][0]['req_note'];
          }
          var appStatus = dataID[0]['req_approve'];
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

  Future<Null> setStatus(id,status,remark) async{
    try{
      var response = await patch(
          Uri.parse(pathurl.setStatus+id),
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
            Navigator.of(context).pop();
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
    _note.addListener((){
      setState(() {});
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        loading = true;
        // dt = DateFormat('dd/MM/yyyy').format(dataHuman!.reqDateWant);
      });
    });

    getToken();
    print(widget.id);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text("รายละเอียดอนุมัติเอกสาร"),
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
      body: loading && dataID.length > 0
          ? SingleChildScrollView(
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
                      decoration: dataID[0]['req_status'] == 'ยกเลิก' ? BoxDecoration(
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
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:  <Widget>[
                              Text("วันที่ (ขอ) : ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.black),),
                              Text("${dataID[0]['req_date_created']}",style: TextStyle(fontSize: 16,color: Colors.black),),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:  <Widget>[
                              Text("หมายเลขเอกสาร : ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.black),),
                              Text("${dataID[0]['req_id']}",style: TextStyle(fontSize: 16,color: Colors.black),),
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
                                  "วันที่ (ต้องการ)",
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
                                    "${dataID[0]['req_date_want'].toString().split("-")[2]}/"
                                        "${dataID[0]['req_date_want'].toString().split("-")[1]}"
                                        "/${int.parse(dataID[0]['req_date_want'].toString().split("-")[0])+543}",
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
                                  "ตำแหน่ง",
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
                                    "${dataID[0]['req_pos']['name']}",
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
                                  "ประเภทการจ้าง",
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
                                    "${dataID[0]['req_emp_type']}",
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
                                  "เพศ",
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
                                    "${dataID[0]['req_gender']['name']}",
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
                                  "ระดับการศึกษา",
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
                                    "${dataID[0]['req_edu']}",
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
                                  "ทักษะอื่นๆ",
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
                                    "${dataID[0]['req_other_skills']}",
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
                                    "${dataID[0]['req_details']}",
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
                                  "${dataID[0]['req_status']}",
                                  style: TextStyle(
                                    color: dataID[0]['req_status'] == 'อนุมัติ' ? Colors.green
                                        : dataID[0]['req_status'] == 'ไม่อนุมัติ' || dataID[0]['req_status'] == 'ยกเลิก'? Colors.red
                                        : dataID[0]['req_status'] == 'ตีกลับ' ? Colors.orange
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
                              children:  [
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
                                  // "${dataHuman?.reqEmp.name.split('นาย')[1]}",
                                  "${dataID[0]['req_emp']['name'].toString().split(' ')[1]} "
                                      "${dataID[0]['req_emp']['name'].toString().split(' ')[2]}",
                                  style: TextStyle(
                                    color: Colors.deepPurpleAccent,
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
                                  "เหตุผลที่ขอ : ",
                                  style: TextStyle(
                                    color: Colors.deepPurpleAccent,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  "${dataID[0]['req_remark']}",
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
                          const SizedBox(height: 20),
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
                          // const SizedBox(height: 20),
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
                                      onPressed: dataID[0]['req_status'] == 'อนุมัติ' ||
                                          dataID[0]['req_status'] == "ไม่อนุมัติ" ||
                                          dataID[0]['req_status'] == "ตีกลับ" ||
                                          dataID[0]['req_status'] == "ยกเลิก" ||
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
                                      onPressed: dataID[0]['req_status'] == 'อนุมัติ' ||
                                          dataID[0]['req_status'] == "ไม่อนุมัติ" ||
                                          dataID[0]['req_status'] == "ตีกลับ" ||
                                          dataID[0]['req_status'] == "ยกเลิก" ||
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
                                                    setStatus(widget.id, "ไม่อนุมัติ", _note.text);
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
                                      onPressed: dataID[0]['req_status'] == 'อนุมัติ' ||
                                                 dataID[0]['req_status'] == "ไม่อนุมัติ" ||
                                                 dataID[0]['req_status'] == "ตีกลับ" ||
                                                 dataID[0]['req_status'] == "ยกเลิก" ||
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
