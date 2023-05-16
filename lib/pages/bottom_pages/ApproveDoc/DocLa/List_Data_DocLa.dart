import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:index/api/url.dart';
import 'package:index/pages/bottom_pages/ApproveDoc/DocHuman/Detail_DocHuman_Approve.dart';
import 'package:index/pages/widjet/myAlertLocation.dart';
import 'package:index/pages/widjet/popupAlert.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Detail_DocLa_Approve.dart';

class ListDataApproveDocLaPage extends StatefulWidget {
  const ListDataApproveDocLaPage({Key? key}) : super(key: key);

  @override
  State<ListDataApproveDocLaPage> createState() => _ListDataApproveDocLaPageState();
}

class _ListDataApproveDocLaPageState extends State<ListDataApproveDocLaPage> {
  TextEditingController _note = TextEditingController();
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  onGoBack(dynamic value) {
    getToken();
  }

  bool loading = false;

  String? selectedYear;
  List ListYear = [];
  String? idEmp;

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

  Future<Null> getlistempName() async{
    String UrlPos = pathurl.dataSearchListEmpName;
    final response = await get(
        Uri.parse(UrlPos),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
      setState(() {
        ListEmployeename = data["data"];
        ListEmployeename.add({"id":"all",
          "name":"ทั้งหมด"});
        // print(ListEmployeename);
      });
    }
  }
  String? selectedEmployeename;
  List ListEmployeename =[
    // 'ทั้งหมด', 'กรรณิการ์ แก้วอุดม', 'ธีรภัทร์ เจริญวงค์',
    // 'ขอเพิ่มเวลา', 'ขอเปลี่ยนวันหยุด', 'ขอเปลี่ยนกะการทำงาน',
  ];

  String token = "";
  Future<Null> getToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
    idEmp = preferences.getString("idEmp")!;
    getdata();
    getlistempName();
    // print(token);
  }

  List dataApprove = [];
  Future<Null> getdata() async{
    try{
      setState(() {
        loading = false;
      });
      final String url = pathurl.dataAllApproveDocLa+'?status=$selectedStatus&year=$selectedYear&month=$selectedMonth';
      final response = await get(
          Uri.parse(url),
          headers: {"Authorization": "Bearer $token"}
      );
      var data = jsonDecode(response.body.toString());
      if(response.statusCode == 200){
        setState(() {
          Future.delayed(const Duration(milliseconds: 600), () {
            setState(() {
              loading = true;
              _refreshController.refreshCompleted();
            });
          });
          // employeeModel = EmployeeModel.fromJson(data["data"]);
          // dataApprove.add(data["data"]);
          dataApprove = data["data"];
        });
      }else if(response.statusCode == 401){
        popup().sessionexpire(context);
      }else{
        print('error1');
      }
    }catch (e){
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
      });
    }
  }

  Future<Null> searchdata(year,month,status,emp) async{
    try{
      setState(() {
        loading = false;
      });
      // final String url = pathurl().dataAllApproveDocLa+'?status=$status&year=$year&month=$month&emp=$emp=selectedEmployeename';
      final String url = pathurl.dataAllApproveDocLa+"?status=${status}&year=${year}&month=${month}&emp=${emp}";
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
          dataApprove = data["data"];
          print(dataApprove.length);
          // print(dataApprove);
        });
      }else if(response.statusCode == 401){
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
    listyear();
    Future.delayed(const Duration(seconds: 1),(){
      setState(() {
        // loading = true;
        selectedYear = ListYear.first;
        selectedMonth = "00";
        selectedStatus = "รออนุมัติ";
        selectedEmployeename = 'all';
      });
      getToken();
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          title: const Text("อนุมัติเอกสารการลา"),
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
        body: loading ? SmartRefresher(
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
            child: Container(
              padding: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 0),
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  Card(
                    child: Container(
                      // height: 200,
                      // alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(15),
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
                                        // hint: Container(
                                        //   // padding: const EdgeInsets.only(right: 5, left: 8),
                                        //     alignment: AlignmentDirectional.centerStart,
                                        //     // width: 180,
                                        //     child: Text(
                                        //       ListYear.first,
                                        //       style: const TextStyle(
                                        //         color: Colors.black,fontSize: 16,
                                        //       ),
                                        //     )
                                        // ),
                                        icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                                        value: selectedYear,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedYear = value as String;
                                            searchdata(selectedYear,selectedMonth,selectedStatus,selectedEmployeename);
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
                                            searchdata(selectedYear,selectedMonth,selectedStatus,selectedEmployeename);
                                          });
                                        },
                                        items: ListMonth.map((valueItem) {
                                          return DropdownMenuItem(
                                              value: valueItem['id'].toString(),child: Text(valueItem['name'].toString())
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
                              Theme(
                                data: Theme.of(context).copyWith(
                                    dividerColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.white,
                                    colorScheme:  const ColorScheme.light(
                                      primary: Colors.black,
                                      // background: Colors.red
                                      // onSurface: Colors.transparent,
                                    )

                                ),
                                child: ExpansionTile(
                                  title: const Text('ค้นหาแบบละเอียด',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700
                                    ),
                                  ),
                                  // subtitle: Text('Trailing expansion arrow icon'),
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.only(top: 0,left: 15,right: 15,bottom: 0),
                                      child: Column(
                                        children: [
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
                                                  searchdata(selectedYear,selectedMonth,selectedStatus,selectedEmployeename);
                                                });
                                              },
                                              items: ListStatus.map((valueItem) {
                                                return DropdownMenuItem(
                                                    value: valueItem,child: Text(valueItem)
                                                );
                                              }).toList(),
                                            ),
                                          ),

                                          const SizedBox(height: 15,),
                                          Container(
                                            padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                                            alignment: Alignment.topLeft,
                                            child: const Text(
                                              "ชื่อพนักงาน",
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
                                              // hint: Container(
                                              //   // padding: const EdgeInsets.only(right: 5, left: 8),
                                              //     alignment: AlignmentDirectional.centerStart,
                                              //     // width: 180,
                                              //     child: Text(
                                              //       ListEmployeename.first,
                                              //       style: const TextStyle(
                                              //         color: Colors.black,fontSize: 16,
                                              //       ),
                                              //     )
                                              // ),
                                              icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                                              value: selectedEmployeename,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedEmployeename = value as String;
                                                  searchdata(selectedYear,selectedMonth,selectedStatus,selectedEmployeename);
                                                });
                                              },
                                              items: ListEmployeename.map((valueItem) {
                                                return DropdownMenuItem(
                                                    value: valueItem['id'].toString(),child: Text(valueItem['name'].toString())
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )

                                  ],
                                ),
                              ),
                              // const SizedBox(width: 30,),
                            ],
                          ),
                          // const SizedBox(height: 10,),
                        ],
                      ),
                    ),
                    elevation: 3,
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Colors.white)
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                    alignment: Alignment.topLeft,
                    child: const Text(
                      "รายการ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  dataApprove.isEmpty ? Nulldata() :
                  ListView.builder(
                    itemCount: dataApprove.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context , i){
                      return getCard(dataApprove[i]);
                    },
                  ),
                  const SizedBox(height: 150)
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

  Widget getCard(item) {
    var fullName = item['rl_emp']['name'].toString().split(' ');
    var firstName = fullName;
    var nickName = item['rl_emp']['nick_name'];
    var datecreated = item['rl_date_created'];
    var note = item['rl_details'];
    var leave = item['leave_type'];
    var status = item['rl_status'];
    var IDdoc = item['rl_id'];
    var appStatus = item['rl_approve'];
    var Sdate = item['rl_date_start'];
    var Edate = item['rl_date_end'];
    bool approve = false;

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

    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Card(
            child: Column(
              children: <Widget> [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: <Widget> [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${IDdoc}",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
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
                                color: status == 'อนุมัติ' ? Colors.green
                                    : status == 'ไม่อนุมัติ' || status == 'ยกเลิก' ? Colors.red
                                    : status == 'ตีกลับ' ? Colors.orange
                                    : Colors.black87,
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
                          "${firstName[1]} ${firstName[2]}($nickName) ยื่นขอ ${leave} ",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),

                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child:  Text(
                          "ขอลางาน ตั้งแต่วันที่ ${Sdate} ถึงวันที่ ${Edate}",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),

                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 5),
                        child: Text(
                          "เหตุผลที่ขอ : ${note}",
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
                  indent: 10,
                  endIndent: 10,
                  height: 0,
                  color: Colors.black,
                ),

                const SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(///อนุมัติ
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          elevation: 3,
                          shape: CircleBorder(),
                        ),
                        onPressed: status == "อนุมัติ" || status == "ไม่อนุมัติ" ||  status == "ตีกลับ" || status == "ยกเลิก" || approve == false ? null
                            :(){
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
                              setStatus(IDdoc,"อนุมัติ","");
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
                    ElevatedButton(///ยกเลิก
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            elevation: 3,
                            shape: CircleBorder()
                        ),
                        onPressed: status == "อนุมัติ" || status == "ไม่อนุมัติ" ||  status == "ตีกลับ" || status == "ยกเลิก" || approve == false ? null
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
                                      setStatus(IDdoc, "ไม่อนุมัติ", _note.text);
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
                    ElevatedButton(///ตีกลับ
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            elevation: 3,
                            shape: CircleBorder()
                        ),
                        onPressed: status == "อนุมัติ" || status == "ไม่อนุมัติ" ||  status == "ตีกลับ" || status == "ยกเลิก" || approve == false ? null
                            : (){
                          AwesomeDialog(
                            context: context,
                            // dismissOnTouchOutside: false,
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
                                      setStatus(IDdoc, "ตีกลับ", _note.text);
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
                    ElevatedButton(///รายละเอียด
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            elevation: 3,
                            shape: CircleBorder()
                        ),
                        onPressed: (){
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => const DocApproveDetailPage())).then(onGoBack);
                          Navigator.of(context).push(
                              PageTransition(
                                child: DetailApproveDocLa(id: IDdoc),
                                type: PageTransitionType.fade,
                                alignment: Alignment.bottomCenter,
                                duration: Duration(milliseconds: 600),
                                reverseDuration: Duration(milliseconds: 600),
                              )
                          ).then(onGoBack);
                        },
                        child: const Icon(
                          Icons.help_outlined,
                          size: 50,
                          color: Colors.white,
                        )
                    ),
                  ],
                ),
                const SizedBox(height: 10)
              ],
            ),
            elevation: 3,
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Colors.white)
            ),
          ),
          // const SizedBox(height: 50)
        ],
      ),
    );
  }

  Widget Nulldata(){
    return Container(
      padding: const EdgeInsets.only(top: 10),
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
