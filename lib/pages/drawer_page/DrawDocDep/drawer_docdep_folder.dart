import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:index/api/url.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widjet/popupAlert.dart';
import 'drawer_docdeb_folder_condition.dart';
import 'drawer_docdeb_folder_goodmem.dart';
import 'drawer_docdeb_folder_holy.dart';
import 'drawer_docdeb_folder_human.dart';
import 'drawer_docdeb_folder_ka.dart';
import 'drawer_docdeb_folder_la.dart';
import 'drawer_docdeb_folder_ot.dart';
import 'drawer_docdeb_folder_resign.dart';
import 'drawer_docdeb_folder_time.dart';
import 'drawer_docdeb_folder_warning.dart';

class DocDepNamePage extends StatefulWidget {
  final String name;
  const DocDepNamePage({Key? key, required this.name}) : super(key: key);

  @override
  State<DocDepNamePage> createState() => _DocDepNamePageState();
}

class _DocDepNamePageState extends State<DocDepNamePage> {
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

  String token = "";
  Future<Null> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
    setState(() {
      selectedYear = ListYear.first;
      selectedMonth = "00";
      selectedStatus = "ทั้งหมด";
    });
    getdata();
  }

  List dataDoc = [];
  Future<Null> getdata() async {
    try{
      setState(() {
        loading = false;
      });
      print(widget.name);
      String url = "";
      switch(widget.name){
        case "ขออัตรากำลังพล" :
          url = pathurl.fHuman+"?search=&status=$selectedStatus&year=$selectedYear&month=$selectedMonth";
          break;
        case "ลางาน" :
          url = pathurl.fLa+"?search=&status=$selectedStatus&year=$selectedYear&month=$selectedMonth";
          break;
        case "เพิ่มเวลา" :
          url = pathurl.fTime+"?search=&status=$selectedStatus&year=$selectedYear&month=$selectedMonth";
          break;
        case "ลาออก" :
          url = pathurl.fResign+"?search=&status=$selectedStatus&year=$selectedYear&month=$selectedMonth";
          break;
        case "เปลี่ยนกะทำงาน" :
          url = pathurl.fKa+"?search=&status=$selectedStatus&year=$selectedYear&month=$selectedMonth";
          break;
        case "เปลี่ยนวันหยุด" :
          url = pathurl.fHoly+"?search=&status=$selectedStatus&year=$selectedYear&month=$selectedMonth";
          break;
        case "โอที" :
          url = pathurl.fOT+"?search=&status=$selectedStatus&year=$selectedYear&month=$selectedMonth";
          break;
        case "หนังสือเตือน" :
          url = pathurl.fWarning+"?search=&status=$selectedStatus&year=$selectedYear&month=$selectedMonth";
          break;
        case "ใบแจ้งเปลี่ยนสภาพ" :
          url = pathurl.fCondition+"?search=&status=$selectedStatus&year=$selectedYear&month=$selectedMonth";
          break;
        case "บันทึกความดี" :
          url = pathurl.fScore+"?search=&status=$selectedStatus&year=$selectedYear&month=$selectedMonth";
          break;
      }

      final response = await get(
          Uri.parse(url),
          headers: {"Authorization": "Bearer $token"}
      );

      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              loading = true;
            });
          });
          dataDoc = data["data"];
          print(dataDoc.length);
        });
      }else if(response.statusCode == 401){
        popup().sessionexpire(context);
        setState(() {
          dataDoc = [];
        });
      }else{
        print(response.statusCode);
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

            },
          ).show();
          dataDoc = [];
        });
      }
    }catch(e){
      print(e);
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

        },
      ).show();
    }
  }

  Future<Null> searchdata(year,month,status) async{
    print(status);
    try{
      setState(() {
        loading = false;
      });
      print(widget.name);
      String url = "";
      switch(widget.name){
        case "ขออัตรากำลังพล" :
          url = pathurl.fHuman+"?search=&status=$selectedStatus&year=$selectedYear&month=$selectedMonth";
          break;
        case "ลางาน" :
          url = pathurl.fLa+"?search=&status=$selectedStatus&year=$selectedYear&month=$selectedMonth";
          break;
        case "เพิ่มเวลา" :
          url = pathurl.fTime+"?search=&status=$selectedStatus&year=$selectedYear&month=$selectedMonth";
          break;
        case "ลาออก" :
          url = pathurl.fResign+"?search=&status=$selectedStatus&year=$selectedYear&month=$selectedMonth";
          break;
        case "เปลี่ยนกะทำงาน" :
          url = pathurl.fKa+"?search=&status=$selectedStatus&year=$selectedYear&month=$selectedMonth";
          break;
        case "เปลี่ยนวันหยุด" :
          url = pathurl.fHoly+"?search=&status=$selectedStatus&year=$selectedYear&month=$selectedMonth";
          break;
        case "โอที" :
          url = pathurl.fOT+"?search=&status=$selectedStatus&year=$selectedYear&month=$selectedMonth";
          break;
        case "หนังสือเตือน" :
          url = pathurl.fWarning+"?search=&status=$selectedStatus&year=$selectedYear&month=$selectedMonth";
          break;
        case "ใบแจ้งเปลี่ยนสภาพ" :
          url = pathurl.fCondition+"?search=&status=$selectedStatus&year=$selectedYear&month=$selectedMonth";
          break;
        case "บันทึกความดี" :
          url = pathurl.fScore+"?search=&status=$selectedStatus&year=$selectedYear&month=$selectedMonth";
          break;
      }

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
          dataDoc = data["data"];
          print(dataDoc);
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

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1),(){
      setState(() {
        loading = true;
      });
    });
    listyear();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text("เอกสาร${widget.name}"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
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
          ),
        ),
      ),
      body: loading ? SingleChildScrollView(
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
                                        searchdata(selectedYear,selectedMonth,selectedStatus);
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
                                        searchdata(selectedYear,selectedMonth,selectedStatus);
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
                                  searchdata(selectedYear,selectedMonth,selectedStatus);
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
                      const SizedBox(height: 10,),
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
            const SizedBox(height: 10,),
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
            dataDoc.isEmpty ? Nulldata() :
            ListView.builder(
              itemCount: dataDoc.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemBuilder: (context , i){
                switch(widget.name){
                  case "ขออัตรากำลังพล" :
                    return getdataHuman(dataDoc[i]);
                  case "ลางาน" :
                    return getdataLa(dataDoc[i]);
                  case "เพิ่มเวลา" :
                    return getdataTime(dataDoc[i]);
                  case "ลาออก" :
                    return getdataResign(dataDoc[i]);
                  case "เปลี่ยนกะทำงาน" :
                    return getdataKa(dataDoc[i]);
                  case "เปลี่ยนวันหยุด" :
                    return getdataHoly(dataDoc[i]);
                  case "โอที" :
                    return getdataOT(dataDoc[i]);
                  case "หนังสือเตือน" :
                    return getdataWarning(dataDoc[i]);
                  case "ใบแจ้งเปลี่ยนสภาพ" :
                    return getdataCondition(dataDoc[i]);
                  case "บันทึกความดี" :
                    return getdataGoodMemmory(dataDoc[i]);

                }

                return Nulldata();

              },
            ),
            const SizedBox(height: 50),
          ],
        ),
      )
      : const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
            strokeWidth: 5,)
      ),
    );
  }

  Widget getdataLa(item){
    var id = item['rl_id'];
    var name = item['rl_emp']['name'].split(' ');
    var Nicname = item['rl_emp']['nick_name'];
    var leavetype = item['leave_type'];
    var status = item['rl_status'];
    var Sdate = item['rl_date_start'];
    var Edate = item['rl_date_end'];
    var detail = item['rl_details'];
    return InkWell(
      onTap: (){
        // Navigator.push(context, MaterialPageRoute(builder: (context) => DetailDocLaPage(id:id))).then(onGoBack);
        Navigator.of(context).push(
            PageTransition(
              child: DocDebLaDetail(id: id),
              type: PageTransitionType.fade,
              alignment: Alignment.bottomCenter,
              duration: Duration(milliseconds: 600),
              reverseDuration: Duration(milliseconds: 600),
            )
        );
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.white38,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        padding: const EdgeInsets.all(6.0),
        child: Card(
          child: Column(
            children: <Widget> [
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: <Widget> [
                        Container(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Text(id,
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
                              color: status == 'อนุมัติ' ? Colors.green
                                  : status == 'ไม่อนุมัติ' || status == 'ยกเลิก'? Colors.red
                                  : status == 'ตีกลับ' ? Colors.orange
                                  : Colors.yellow,
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
                        "${name[1]} ${name[2]} (${Nicname}) ยื่นขอ ''${leavetype}'' ",
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
                      padding: const EdgeInsets.only(top: 15,bottom: 15),
                      child:  Text(
                        "เหตุผลที่ขอ : ${detail}",
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

            ],
          ),
          elevation: 3,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Colors.white)
          ),
        ),
      ),
    );
  }

  Widget getdataTime(item){
    var fullName = item['at_emp']['name'];
    var date= item['at_date'];
    var remark = item['at_remark'];
    var detail = item['at_details'];
    var status = item['at_status'];
    var IDdoc = item['at_id'];
    var name = fullName.toString().split(' ')[1];
    var lastname = fullName.toString().split(' ')[2];

    return InkWell(
      onTap: (){
        Navigator.of(context).push(
            PageTransition(
              child: DocDebTimeDetail(id: IDdoc),
              type: PageTransitionType.fade,
              alignment: Alignment.bottomCenter,
              duration: Duration(milliseconds: 600),
              reverseDuration: Duration(milliseconds: 600),
            )
        );
      },
      child: Container(
        padding: const EdgeInsets.all(6.0),
        child: Card(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: <Widget>[
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
                          child: Text(status,
                            style: TextStyle(
                              color: status == 'อนุมัติ' ? Colors.green
                                  : status == 'ไม่อนุมัติ' || status == 'ยกเลิก' || status == 'ปิดรับสมัคร'? Colors.red
                                  : status == 'ตีกลับ' ? Colors.orange
                                  : Colors.yellow,
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
                        "${name} ${lastname} () ยื่นขอ เพิ่มเวลา",
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
                      padding:
                      const EdgeInsets.only(top: 15),
                      child: Text(
                        "ขอวันที่ ${date}",
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
                          top: 15, bottom: 15),
                      child: Text(
                        "เหตุผลที่ขอ : ${remark} ",
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
            ],
          ),
          elevation: 3,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide:
              const BorderSide(color: Colors.white)),
        ),
      ),
    );
  }

  Widget getdataResign(item){
    var fullName = item['re_emp']['name'];
    var date= item['re_date'];
    var detail = item['re_details'];
    var status = item['re_status'];
    var IDdoc = item['re_id'];
    var name = fullName.toString().split(' ')[1];
    var lastname = fullName.toString().split(' ')[2];

    return InkWell(
      onTap: (){
        Navigator.of(context).push(
            PageTransition(
              child: DocDebResignDetail(id: IDdoc),
              type: PageTransitionType.fade,
              alignment: Alignment.bottomCenter,
              duration: Duration(milliseconds: 600),
              reverseDuration: Duration(milliseconds: 600),
            )
        );
      },
      child: Container(
        padding: const EdgeInsets.all(6.0),
        child: Card(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: <Widget>[
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
                          child: Text(status,
                            style: TextStyle(
                              color: status == 'อนุมัติ' ? Colors.green
                                  : status == 'ไม่อนุมัติ' || status == 'ยกเลิก' || status == 'ปิดรับสมัคร'? Colors.red
                                  : status == 'ตีกลับ' ? Colors.orange
                                  : Colors.yellow,
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
                        "${name} ${lastname} () ยื่นขอ ลาออก",
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
                      padding:
                      const EdgeInsets.only(top: 15),
                      child: Text(
                        "สิ้นสุดการทำงานวันที่ ${date}",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(
                          top: 15, bottom: 15),
                      child: Text(
                        "เหตุผลที่ขอ : ${detail} ",
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
            ],
          ),
          elevation: 3,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide:
              const BorderSide(color: Colors.white)),
        ),
      ),
    );
  }

  Widget getdataKa(item){
    var id = item['rw_id'];
    var status = item['rw_status'];
    var Sdate = item['rw_date_start'];
    var Edate = item['rw_date_end'];
    var detail = item['rw_details'];
    var ka = item['wc_id'].replaceAll('[', '').replaceAll(']','');
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
            PageTransition(
              child: DocDebKaDetail(id: id),
              type: PageTransitionType.fade,
              alignment: Alignment.bottomCenter,
              duration: Duration(milliseconds: 600),
              reverseDuration: Duration(milliseconds: 600),
            )
        );
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.white38,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        padding: const EdgeInsets.all(6.0),
        child: Card(
          child: Column(
            children: <Widget> [
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: <Widget> [
                        Container(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Text(
                            "${id}",
                            style: TextStyle(
                              color: Colors.green,
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
                              color: status == 'อนุมัติ' ? Colors.green
                                  : status == 'ไม่อนุมัติ' || status == 'ยกเลิก'? Colors.red
                                  : status == 'ตีกลับ' ? Colors.orange
                                  : Colors.yellow,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),

                    // Container(
                    //   alignment: Alignment.centerLeft,
                    //   child: Text(
                    //     "${name[1]} ${name[2]} (${Nicname}) ยื่นขอ ''${leavetype}'' ",
                    //     style: TextStyle(
                    //       color: Colors.blueAccent,
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 14,
                    //     ),
                    //     textAlign: TextAlign.left,
                    //   ),
                    // ),

                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 15),
                      child:  Text(
                        "ขอเปลี่ยนกะ ตั้งแต่วันที่ ${Sdate} ถึงวันที่ ${Edate}",
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
                      padding: const EdgeInsets.only(top: 15),
                      child:  Text(
                        "เปลี่ยนเป็น ${ka}",
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
                      padding: const EdgeInsets.only(top: 15,bottom: 15),
                      child:  Text(
                        "เหตุผลที่ขอ : ${detail}",
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
            ],
          ),
          elevation: 3,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Colors.white)
          ),
        ),
      ),
    );
  }

  Widget getdataHoly(item){
    var id = item['rh_id'];
    var status = item['rh_status'];
    var dateHoly = item['rh_date_holiday'];
    var dateHolychang = item['rh_date_change'];
    var detail = item['rh_details'];
    // var ka = item['wc_id'].replaceAll('[', '').replaceAll(']','');
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
            PageTransition(
              child: DocDebHolyDetail(id: id),
              type: PageTransitionType.fade,
              alignment: Alignment.bottomCenter,
              duration: Duration(milliseconds: 600),
              reverseDuration: Duration(milliseconds: 600),
            )
        );
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.white38,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        padding: const EdgeInsets.all(6.0),
        child: Card(
          child: Column(
            children: <Widget> [
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: <Widget> [
                        Container(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Text(
                            "${id}",
                            style: TextStyle(
                              color: Colors.green,
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
                              color: status == 'อนุมัติ' ? Colors.green
                                  : status == 'ไม่อนุมัติ' || status == 'ยกเลิก'? Colors.red
                                  : status == 'ตีกลับ' ? Colors.orange
                                  : Colors.yellow,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),

                    // Container(
                    //   alignment: Alignment.centerLeft,
                    //   child: Text(
                    //     "${name[1]} ${name[2]} (${Nicname}) ยื่นขอ ''${leavetype}'' ",
                    //     style: TextStyle(
                    //       color: Colors.blueAccent,
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 14,
                    //     ),
                    //     textAlign: TextAlign.left,
                    //   ),
                    // ),

                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 15),
                      child:  Text(
                        "ขอเปลี่ยนวันหยุด วันที่ ${dateHoly} เปลี่ยนเป็นวันที่ ${dateHolychang}",
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
                      padding: const EdgeInsets.only(top: 15,bottom: 15),
                      child:  Text(
                        "เหตุผลที่ขอ : ${detail}",
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

            ],
          ),
          elevation: 3,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Colors.white)
          ),
        ),
      ),
    );
  }

  Widget getdataHuman(item){
    var fullName = item['req_emp']['name'];
    var pos = item['req_pos']['name'];
    var datewant = item['req_date_created'];
    var note = item['req_remark'];
    var status = item['req_status'];
    var IDdoc = item['req_id'];
    var name = fullName.toString().split('นาย')[1];

    return InkWell(
      onTap: (){
        Navigator.of(context).push(
            PageTransition(
              child: DocDebHumanDetail(id: IDdoc),
              type: PageTransitionType.fade,
              alignment: Alignment.bottomCenter,
              duration: Duration(milliseconds: 600),
              reverseDuration: Duration(milliseconds: 600),
            )
        );
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
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
                      child: Text(status,
                        style: TextStyle(
                          color: status == 'อนุมัติ' ? Colors.green
                              : status == 'ไม่อนุมัติ' || status == 'ยกเลิก' || status == 'ปิดรับสมัคร'? Colors.red
                              : status == 'ตีกลับ' ? Colors.orange
                              : Colors.yellow,
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
                    "${name} () ยื่นขอกำลังพล \n'' ${pos} '' ",
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
                  padding:
                  const EdgeInsets.only(top: 15),
                  child: Text(
                    "ขอวันที่ ${datewant}",
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
                      top: 15, bottom: 15),
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
          elevation: 3,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide:
              const BorderSide(color: Colors.white)),
        ),
      ),
    );
  }

  Widget getdataOT(item){
    var id = item['ot_id'];
    var status = item['ot_status'];
    var Sdate = item['ot_date_start'];
    var Edate = item['ot_date_end'];
    var detail = item['ot_details'];

    return InkWell(
      onTap: (){
        Navigator.of(context).push(
            PageTransition(
              child: DocDebOTDetail(id: id),
              type: PageTransitionType.fade,
              alignment: Alignment.bottomCenter,
              duration: Duration(milliseconds: 600),
              reverseDuration: Duration(milliseconds: 600),
            )
        );
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.white38,
      borderRadius: BorderRadius.circular(5),
      child: Container(
        padding: const EdgeInsets.all(6.0),
        child: Card(
          child: Column(
            children: <Widget> [
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: <Widget> [
                        Container(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Text(
                            "${id}",
                            style: TextStyle(
                              color: Colors.green,
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
                              color: status == 'อนุมัติ' ? Colors.green
                                  : status == 'ไม่อนุมัติ' || status == 'ยกเลิก'? Colors.red
                                  : status == 'ตีกลับ' ? Colors.orange
                                  : Colors.yellow,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),

                    // Container(
                    //   alignment: Alignment.centerLeft,
                    //   child: Text(
                    //     "${name[1]} ${name[2]} (${Nicname}) ยื่นขอ ''${leavetype}'' ",
                    //     style: TextStyle(
                    //       color: Colors.blueAccent,
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 14,
                    //     ),
                    //     textAlign: TextAlign.left,
                    //   ),
                    // ),

                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 15),
                      child:  Text(
                        "ขอโอที ตั้งแต่วันที่ ${Sdate} ถึงวันที่ ${Edate}",
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
                      padding: const EdgeInsets.only(top: 15,bottom: 15),
                      child:  Text(
                        "เหตุผลที่ขอ : $detail",
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

            ],
          ),
          elevation: 3,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Colors.white)
          ),
        ),
      ),
    );
  }

  Widget getdataWarning(item){
    var IDdoc = item['wl_id'];
    var dtCreate = item['wl_date_created'];
    var header = item['wl_name'];
    // var fullName = item['sc_emp']['name'];
    // var date= item['sc_date'];
    // var reason = item['sc_reason'];
    var detail = item['wl_details'];
    var status = item['wl_status'];
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
                      "${header}",
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
                                  child: DocDebWarningDetail(id: IDdoc),
                                  type: PageTransitionType.fade,
                                  alignment: Alignment.center,
                                  duration: Duration(milliseconds: 600),
                                  reverseDuration: Duration(milliseconds: 600),
                                )
                            );
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

  Widget getdataCondition(item){
    var IDdoc = item['cc_id'];
    var dtCreate = item['cc_date_created'];
    var title = item['cc_title'];
    var detail = item['cc_details'];
    var status = item['cc_status'];


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
                                  child: DocDebConditionDetail(id: IDdoc,),
                                  type: PageTransitionType.fade,
                                  alignment: Alignment.center,
                                  duration: Duration(milliseconds: 600),
                                  reverseDuration: Duration(milliseconds: 600),
                                )
                            );
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

  Widget getdataGoodMemmory(item){
    var IDdoc = item['ss_id'];
    var dtCreate = item['ss_date_created'];
    var title = item['ss_title'];
    var detail = item['ss_name'];
    var status = item['ss_status'];

    return InkWell(
      onTap: (){
        Navigator.of(context).push(
            PageTransition(
              child: DocDebGoodMemmoryDetail(id: IDdoc,),
              type: PageTransitionType.fade,
              alignment: Alignment.center,
              duration: Duration(milliseconds: 600),
              reverseDuration: Duration(milliseconds: 600),
            )
        );
      },
      child: Container(
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
            ],
          ),
          elevation: 3,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Colors.white)
          ),
        ),
      ),
    );
  }


  Widget Nulldata(){
    return Container(
      padding: const EdgeInsets.all(6.0),
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
