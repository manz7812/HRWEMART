import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../api/url.dart';
import '../../widjet/ButtonInsertWork.dart';
import '../../drawer_page/dropdownSelect.dart';
import '../../widjet/popupAlert.dart';
import 'Doc_Human_detail.dart';

class InsertDocHumanPage extends StatefulWidget {
  final Function? onGoBack;
  const InsertDocHumanPage({Key? key,this.onGoBack}) : super(key: key);

  @override
  State<InsertDocHumanPage> createState() => _InsertDocHumanPageState();
}

class _InsertDocHumanPageState extends State<InsertDocHumanPage> {
  onGoBack(dynamic value) {
    getToken();
  }

  bool loading = false;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

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
    getdata();
    // print(token);
  }

  List dataDocHuman = [];

  Future<Null> getdata() async {
    try{
      setState(() {
        loading = false;
      });
      String url = pathurl.urldataHumanById;
      final response =
      await get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
      var data = jsonDecode(response.body);
      // print(data);
      if (response.statusCode == 200) {
        setState(() {
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              loading = true;
            });
          });
          dataDocHuman = data["data"];
          _refreshController.refreshCompleted();
          // dataHuman = Usermodel.fromMap(data['data'][0]);
          // print(dataHuman!.toMap());
        });
      }else if(response.statusCode == 401){
        popup().sessionexpire(context);
        setState(() {
          dataDocHuman = [];
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
          dataDocHuman = [];
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

  Future<Null> searchdata(year,month,status) async{
    print(status);
    try{
      setState(() {
        loading = false;
      });
      final String url = pathurl.urldataHumanById+'?status=$status&year=$year&month=$month';
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
          dataDocHuman = data["data"];
          print(dataDocHuman);
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
    listyear();
    getToken();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        loading = true;
        selectedYear = ListYear.first;
        selectedMonth = "00";
        selectedStatus = "ทั้งหมด";
        // radius = 100;
      });
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
        title: const Text("ขอกำลังพล"),
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
      body: loading && dataDocHuman.length >=0
          ? Column(
              children: [
                ButtonInsert().show_ButtonInsert_DocHuman(context,onGoBack),
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
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(6.0),
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
                                dataDocHuman.isEmpty ? Nulldata() :
                                ListView.builder(
                                  itemCount: dataDocHuman.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemBuilder: (context , i){
                                    return getCard(dataDocHuman[i]);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
    var fullName = item['req_emp']['name'];
    var pos = item['req_pos']['name'];
    var datewant = item['req_date_created'];
    var note = item['req_remark'];
    var status = item['req_status'];
    var IDdoc = item['req_id'];
    var name = fullName.toString().split('นาย')[1];

    return InkWell(
      onTap: (){
        // Navigator.push(context,MaterialPageRoute(builder: (context) => DetailDocHuman(id: IDdoc))).then(onGoBack);
        Navigator.of(context).push(
            PageTransition(
              child: DetailDocHuman(id: IDdoc),
              type: PageTransitionType.fade,
              alignment: Alignment.bottomCenter,
              duration: Duration(milliseconds: 600),
              reverseDuration: Duration(milliseconds: 600),
            )
        ).then(onGoBack);
      },
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
          ],
        ),
        elevation: 3,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide:
            const BorderSide(color: Colors.white)),
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
