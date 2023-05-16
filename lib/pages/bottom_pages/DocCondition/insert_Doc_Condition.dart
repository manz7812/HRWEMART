import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:index/pages/widjet/ButtonInsertWork.dart';
import 'package:index/pages/widjet/popupAlert.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/url.dart';
import 'Doc_Condition_Detail.dart';

class InsertDocConditionPage extends StatefulWidget {
  const InsertDocConditionPage({Key? key}) : super(key: key);

  @override
  State<InsertDocConditionPage> createState() => _InsertDocConditionPageState();
}

class _InsertDocConditionPageState extends State<InsertDocConditionPage> {

  onGoBack(dynamic value) {
    setState(() {
      loading = false;
    });
    getToken();
  }

  RefreshController _refreshController = RefreshController(initialRefresh: false);
  bool loading = false;
  String? selectedYear;
  List ListYear = [];

  Future<Null> listyear() async{
    var df = DateFormat('yyyy').format(DateTime.now());
    for (var i = int.parse(df); i > int.parse(df) - 20; i--) {
      ListYear.add(i.toString());
    }
  }

  String? selectedMonth;
  List ListMonth =[
    {"id":"00",
      "name":"ทั้งหมด"
    },
    {"id":"01",
      "name":"มกราคม"
    },
    {"id":"02",
      "name":"กุมภาพันธ์"
    },
    {"id":"03",
      "name":"มีนาคม"
    },
    {"id":"04",
      "name":"เมษายน"
    },
    {"id":"05",
      "name":"พฤษภาคม"
    },
    {"id":"06",
      "name":"มิถุนายน"
    },
    {"id":"07",
      "name":"กรกฎาคม"
    },
    {"id":"08",
      "name":"สิงหาคม"
    },
    {"id":"09",
      "name":"กันยายน"
    },
    {"id":"10",
      "name":"ตุลาคม"
    },
    {"id":"11",
      "name":"พฤศจิกายน"
    },
    {"id":"12",
      "name":"ธันวาคม"
    }
  ];

  String? selectedStatus;
  List ListStatus =[
    'ทั้งหมด',
    'รออนุมัติ', 'อนุมัติ', 'ไม่อนุมัติ','ตีกลับ','ยกเลิก',
  ];

  String? selectedPos;
  List ListPos =[
    {"pos_id":"all", "pos_name":"ทั้งหมด"}
  ];
  Future<Null> getlistPos() async{
    String UrlPos = pathurl.listPosCondition;
    final response = await get(
        Uri.parse(UrlPos),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    ListPos = [
      {"pos_id":"all", "pos_name":"ทั้งหมด"}
    ];
    if(response.statusCode == 200){
      setState(() {
        data["data"].forEach((element) {
          ListPos.add(element);
        });
        // print(ListEmployeename);
      });
    }
  }


  String token = "";
  Future<Null> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
    var df = DateFormat('MM').format(DateTime.now());
    setState(() {
      selectedYear = ListYear.first;
      selectedMonth = df;
      selectedStatus = "ทั้งหมด";
      selectedPos = "all";
    });
    getlistPos();
    getdata();
  }

  List dataDocCondition = [];
  Future<Null> getdata() async {
    try{
      setState(() {
        loading = false;
      });
      String url = pathurl.getDTDocCondition+"?status=$selectedStatus&year=$selectedYear&month=$selectedMonth";
      final response = await get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
      var data = jsonDecode(response.body);
      // print(data);
      if (response.statusCode == 200) {
        setState(() {
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              loading = true;
              _refreshController.refreshCompleted();
            });
          });
          dataDocCondition = data["data"];
          // _refreshController.refreshCompleted();
          // print(dataDocSalaryCer);
        });
      }else if(response.statusCode == 401){
        popup().sessionexpire(context);
        setState(() {
          dataDocCondition = [];
        });
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
          dataDocCondition = [];
        });
      }
    }catch(e){
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

  TextEditingController empName = TextEditingController();
  Future<Null> searchdata(year,month,status,posId) async{
    try{
      setState(() {
        loading = false;
      });
      final String url = pathurl.getDTDocCondition+'?search=${empName.text}&pos_id=$posId&status=$status&year=$year&month=$month';
      final response = await get(
          Uri.parse(url),
          headers: {"Authorization": "Bearer $token"}
      );
      var data = jsonDecode(response.body.toString());
      if(response.statusCode == 200){
        setState(() {
          loading = true;
          // employeeModel = EmployeeModel.fromJson(data["data"]);
          // dataApprove.add(data["data"]);
          dataDocCondition = data["data"];
          print(dataDocCondition.length);
        });
      }else if(response.statusCode == 401){
        dataDocCondition = [];
        popup().sessionexpire(context);
      }else{
        print('error');
      }
    }catch(e){
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
        desc: 'กรุณาลองใหม่อีกครั้ง หรือ ติดต่อเจ้าหน้าที่',
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
      var url = pathurl.setStatusDTDocConditionID+id;
      var response = await patch(
          Uri.parse(url),
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
                    builder: (BuildContext context) => super.widget));
          },
        ).show();
      }else if(response.statusCode == 401){
        context.loaderOverlay.hide();
        popup().sessionexpire(context);
      }else{
        context.loaderOverlay.hide();
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
            // Navigator.pop(context);
          },
        ).show();
        print(response.body);
      }
    }catch(e){
      ////server

    }
  }

  @override
  void initState() {
    listyear();
    getToken();
    Future.delayed(const Duration(seconds: 1),(){
      setState(() {
        loading = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text("ขอใบแจ้งเปลี่ยนสภาพพนักงาน"),
        // leading: IconButton(
        //   onPressed: () {
        //     // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyDrawer(),), (route) => true);
        //     Navigator.of(context).pop();
        //   },
        //   icon: Icon(Icons.arrow_back),
        // ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
            // border: Border.all(width: 15, color: Colors.white),
            gradient: LinearGradient(
              colors: [
                Color(0xff6200EA),
                Colors.white,
              ],
              begin: FractionalOffset(0.0, 1.0),
              end: FractionalOffset(1.5, 1.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.transparent,
                spreadRadius: 5,
                blurRadius: 30,
                offset: Offset(5, 3),
              ),
            ],
            // image: DecorationImage(image: NetworkImage('https://www.pngitem.com/pimgs/m/391-3918613_personal-service-platform-person-icon-circle-png-transparent.png'))
          ),
        ),
      ),
      body: loading ? LoaderOverlay(
        overlayWidget: Center(
          child: LoadingAnimationWidget.threeArchedCircle(
              color: Colors.deepPurpleAccent, size: 50),
        ),
        child: Column(
          children: [
            ButtonInsert().show_ButtonInsert_DocCondition(context,onGoBack),
            Expanded(
              child: SmartRefresher(
                header: ClassicHeader(
                  refreshStyle: RefreshStyle.Follow,
                  releaseText: '',
                  refreshingText: 'กรุณารอสักครู่...',
                  completeText: 'โหลดข้อมูลสำเร็จ',
                  idleText: '',
                  idleIcon: null,
                  refreshingIcon: LoadingAnimationWidget.discreteCircle(
                      color: Colors.deepPurpleAccent,
                      secondRingColor: Colors.white,
                      thirdRingColor: Colors.deepPurpleAccent,
                      size: 30),
                  // refreshingIcon: Icon(Icons.refresh),
                ),
                controller: _refreshController,
                onRefresh: () async{
                  await Future.delayed(Duration(milliseconds: 1000));
                  getToken();
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(6.0),
                        child: Card(
                          child: Container(
                            // height: 200,
                            // alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Row(
                                  children: <Widget>[
                                    // const SizedBox(width: 3),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                                            alignment: Alignment.topLeft,
                                            child: const Text(
                                              "เลือกปี",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.only(right: 16, left: 16),
                                            // margin: EdgeInsets.all(10),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey.shade500
                                                ),
                                                borderRadius: BorderRadius.circular(5)
                                            ),
                                            child: DropdownButton(
                                              isExpanded: true,
                                              underline: SizedBox(),
                                              icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                                              value: selectedYear,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedYear = value as String;
                                                  searchdata(selectedYear,selectedMonth,selectedStatus,selectedPos);
                                                });
                                              },
                                              items: ListYear.map((valueItem) {
                                                return DropdownMenuItem(
                                                    value: valueItem,child: Text(valueItem)
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // const Spacer(),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                                            alignment: Alignment.topLeft,
                                            child: const Text(
                                              "เลือกเดือน",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.only(right: 16, left: 16),
                                            // margin: EdgeInsets.all(10),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey.shade500
                                                ),
                                                borderRadius: BorderRadius.circular(5)
                                            ),
                                            child: DropdownButton(
                                              isExpanded: true,
                                              underline: SizedBox(),
                                              icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                                              value: selectedMonth,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedMonth = value as String;
                                                  searchdata(selectedYear,selectedMonth,selectedStatus,selectedPos);
                                                });
                                              },
                                              items: ListMonth.map((valueItem) {
                                                return DropdownMenuItem(
                                                    value: valueItem['id'].toString(),child: Text(valueItem['name'])
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                          // const SizedBox(width: 30,),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                                      alignment: Alignment.topLeft,
                                      child: const Text(
                                        "สถานะ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.only(right: 16, left: 16),
                                      // margin: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade500
                                          ),
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: DropdownButton(
                                        isExpanded: true,
                                        underline: SizedBox(),
                                        icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                                        value: selectedStatus,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedStatus = value as String;
                                            searchdata(selectedYear,selectedMonth,selectedStatus,selectedPos);
                                          });
                                        },
                                        items: ListStatus.map((valueItem) {
                                          return DropdownMenuItem(
                                              value: valueItem,child: Text(valueItem)
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    // const SizedBox(width: 30,),
                                  ],
                                ),
                                const SizedBox(height: 20,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                                      alignment: Alignment.topLeft,
                                      child: const Text(
                                        "ตำแหน่ง(ผู้อนุมัติ)",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.only(right: 16, left: 16),
                                      // margin: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade500
                                          ),
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: DropdownButtonFormField(
                                        isExpanded: true,
                                        // underline: SizedBox(),
                                        icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                                        value: selectedPos,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedPos = value as String;
                                            searchdata(selectedYear,selectedMonth,selectedStatus,selectedPos);
                                          });
                                        },
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                        ),
                                        items: ListPos.map((valueItem) {
                                          return DropdownMenuItem(
                                              value: valueItem['pos_id'],child: Text(valueItem['pos_name'])
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    // const SizedBox(width: 30,),
                                  ],
                                ),
                                const SizedBox(height: 20,),
                                Column(
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
                                    TextFormField(
                                      controller: empName,
                                      // focusNode: FocusNode(),
                                      showCursor: true,
                                      readOnly: false,
                                      validator: (value) => (value!.isEmpty) ? '' : null,
                                      // maxLines: 2,
                                      // maxLength: 9999,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                          hintText: "ชื่อพนักงาน",
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.grey.shade700)
                                          ),
                                          suffixIcon: InkWell(
                                            child: const Icon(IcoFontIcons.searchUser),
                                            onTap: (){
                                              searchdata(selectedYear,selectedMonth,selectedStatus,selectedPos);
                                            },
                                          )
                                      ),

                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          elevation: 3,
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(color: Colors.white)
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(6),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "รายการ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                      dataDocCondition.isEmpty ? Nulldata() :
                      ListView.builder(
                        itemCount: dataDocCondition.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemBuilder: (context , i){
                          return getCard(dataDocCondition[i]);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
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

  Widget getCard(item){
    var IDdoc = item['cc_id'];
    var dtCreate = item['cc_date_created'];
    var title = item['cc_title'];
    // var fullName = item['sc_emp']['name'];
    // var date= item['sc_date'];
    // var reason = item['sc_reason'];
    var detail = item['cc_details'];
    var status = item['cc_status'];
    //
    // var name = fullName.toString().split(' ');
    // var lastname = fullName.toString().split(' ')[2];

    return Container(
      padding: const EdgeInsets.all(6.0),
      child: Card(
        child: Column(
          children: <Widget> [
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                children: [
                  Row(
                    children: <Widget> [
                      Container(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Text(IDdoc,
                          style: TextStyle(
                            color:  Colors.green,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Text(
                          "${status}",
                          style: TextStyle(
                            color: status == 'อนุมัติ' || status == 'สำเร็จ' ?Colors.green
                                : status == 'ไม่อนุมัติ' || status == 'ยกเลิก'? Colors.red
                                : status == 'ตีกลับ' ? Colors.orange
                                : status == 'รออนุมัติ' ? Colors.yellow : Colors.blue,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),

                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${title}",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),

                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children:[
                        Text(
                          "ยื่นขอเมื่อ: ",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "${dtCreate}",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 5,bottom: 10),
                    child: Text(
                      "รายละเอียด : ${detail}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.black87,
              height: 1,
            ),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      // padding: const EdgeInsets.only(right: 16, left: 16),
                      // margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        // border: Border.all(
                        //     color: Colors.grey.shade500
                        // ),
                        //   borderRadius: BorderRadius.circular(0)
                      ),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              disabledForegroundColor: Colors.grey,
                              disabledBackgroundColor: Colors.white,
                              minimumSize: Size(0, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                                // side: BorderSide(color: Colors.red)
                              )
                          ),
                          onPressed: status == "ส่งเอกสาร" ?(){
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
                              title: 'ยืนยันการรับเอกสาร',
                              showCloseIcon: false,
                              btnOkText: "ตกลง",
                              btnCancelText: "ยกเลิก",
                              btnOkOnPress: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                setStatus(IDdoc,"สำเร็จ","");
                                context.loaderOverlay.show();
                              },
                              btnCancelOnPress: (){
                                FocusScope.of(context).requestFocus(FocusNode());
                              },
                            ).show();
                          } :null,
                          child: Text('ยืนยันรับเอกสาร',textAlign: TextAlign.center,)
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    width: 5,
                    thickness: 1,
                    color: Colors.black87,
                  ),
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
                            backgroundColor: Colors.transparent,
                            primary: Colors.deepPurpleAccent,
                            // minimumSize: Size(width, 100),
                          ),
                          onPressed: (){
                            Navigator.of(context).push(
                                PageTransition(
                                  child: DetailDocConditionPage(id: IDdoc,),
                                  type: PageTransitionType.fade,
                                  alignment: Alignment.center,
                                  duration: Duration(milliseconds: 600),
                                  reverseDuration: Duration(milliseconds: 600),
                                )
                            ).then(onGoBack);
                          },
                          child: Text('รายละเอียด')),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        elevation: 3,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.white)
        ),
      ),
    );
  }

  Widget Nulldata(){
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 10, 6, 6),
      child: Column(
        children: <Widget>[
          Card(
            child: Container(
              height: 150,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(15),
              child: const Text(
                "ไม่พบข้อมูล",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
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
    );
  }
}
