import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:index/pages/drawer_page/DrawJobWork/pdf_viewjob.dart';
import 'package:index/pages/widjet/ButtonInsertWork.dart';
import 'package:index/pages/widjet/pdf_api.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/url.dart';
import '../../widjet/popupAlert.dart';
import '../web_page.dart';

class DocJobWorkPage extends StatefulWidget {
  final String title;
  const DocJobWorkPage({Key? key, required this.title}) : super(key: key);

  @override
  State<DocJobWorkPage> createState() => _DocJobWorkPageState();
}

class _DocJobWorkPageState extends State<DocJobWorkPage> {
  bool loading = false;

  onGoBack(dynamic value) {
    getToken();
  }

  var log = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      lineLength: 120,
      errorMethodCount: 8,
      colors: true,
      printEmojis: false,
    ),
  );

  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
  );

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
    'ผ่าน', 'ไม่ผ่าน', 'รอคัดเลือก',
  ];

  String token = "";
  Future<Null> getToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
    setState(() {
      loading = false;
      listyear();
      selectedYear = ListYear.first;
      selectedMonth = "00";
      selectedStatus = ListStatus[3];
      getdata();
    });


    // print(token);
  }

  List dataJ = [];
  Future<Null> getdata() async{
    try{
      setState(() {
        loading = false;
      });
      await Future.delayed(Duration(milliseconds: 500));
      final String url =  pathurl.listjob+'?status=${selectedStatus}&year=${ListYear.first}&month=${selectedMonth}';
      final response = await get(
          Uri.parse(url),
          headers: {"Authorization": "Bearer $token"}
      );
      // print(response.statusCode);
      var data = jsonDecode(response.body.toString());
      if(response.statusCode == 200){
        setState(() {
          loading = true;
          dataJ=data["data"];
          // print(dataP);
          log.i(dataJ);
          // developer.log('$dataP', name: 'ข้อมูลพนักงาน');
        });
      }else if(response.statusCode == 401){
        popup().sessionexpire(context);
      }

    }catch(e){

    }
  }

  Future<Null> setStatus(id,status) async{
    try{
      var response = await patch(
          Uri.parse(pathurl.setstatusjob+"${id}"),
          headers: {"Authorization": "Bearer $token"},
          body: {
            "status": "${status}",
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
            getdata();
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
            getdata();
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

  Future<Null> searchdata(year,month,status) async{
    print(status);
    try{
      setState(() {
        loading = false;
      });
      final String url = pathurl.listjob+'?status=$status&year=$year&month=$month';
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
          dataJ = data["data"];
          log.i(dataJ.length);
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
          getToken();
        },
      ).show();
    }
  }

  @override
  void initState(){
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
    double width = double.infinity;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
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
                // ButtonInsert().show_Button_PDF_View(context),
                // Container(
                //   padding: const EdgeInsets.only(left:10, top: 30, bottom: 20 , right: 10),
                //   // width: MediaQuery.of(context).size.width,
                //   width: double.infinity,
                //   child: ElevatedButton.icon(
                //     icon: const Icon(
                //       Icons.picture_as_pdf_outlined,
                //       color: Colors.white,
                //       size: 40,
                //     ),
                //     onPressed: () async{
                //       final path = "images/sample.pdf";
                //       final file = await PDFApi.loadAsset(path);
                //       openPDF(context, file);
                //     },
                //     label: const Text(
                //       "เอกสารใบสมัคร2",
                //       style: TextStyle(
                //           fontSize: 20,
                //           fontWeight: FontWeight.w600,
                //           color: Colors.white),
                //     ),
                //     style: ElevatedButton.styleFrom(
                //       primary: Colors.blue,
                //       fixedSize: Size(width, 70),
                //     ),
                //   ),
                // ),
                // Container(
                //   padding: const EdgeInsets.only(left:10, top: 30, bottom: 20 , right: 10),
                //   // width: MediaQuery.of(context).size.width,
                //   width: double.infinity,
                //   child: ElevatedButton.icon(
                //     icon: const Icon(
                //       Icons.picture_as_pdf_outlined,
                //       color: Colors.white,
                //       size: 40,
                //     ),
                //     onPressed: () async{
                //       // final path = "images/ระบบจัดการเอกสาร WTS Gropu.pdf";
                //       final path = "http://www.songtham.ac.th/managefiles/file/alisa/pdffile.pdf";
                //       final file = await PDFApi.loadNetwork(path);
                //       openPDF(context, file);
                //     },
                //     label: const Text(
                //       "เอกสารใบสมัคร3",
                //       style: TextStyle(
                //           fontSize: 20,
                //           fontWeight: FontWeight.w600,
                //           color: Colors.white),
                //     ),
                //     style: ElevatedButton.styleFrom(
                //       primary: Colors.blue,
                //       fixedSize: Size(width, 70),
                //     ),
                //   ),
                // ),
                dataJ.isEmpty ? Nulldata() :
                ListView.builder(
                  itemCount: dataJ.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (context , i){
                    return getCard(dataJ[i]);
                  },
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

  Widget getCard(item){
    var id = item['id'];
    var reqid = item['req_id'];
    var date_s = item['date_share'];
    var link = item['link'];
    var emp_n = item['emp_share']['name'];
    var emp_nn = item['emp_share']['nick_name'];
    var status = item['status'];


    return InkWell(
      // onTap: (){
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => const WebCheckINChecKOutPage()));
      // },
      splashColor: Colors.transparent,
      highlightColor: Colors.white38,
      borderRadius: BorderRadius.circular(5),
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
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${reqid}",
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
                            "$status",
                            style: TextStyle(
                              color: Colors.black,
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
                    //   child: const Text(
                    //     "ขอเครดิตกับธนาคารกสิกรไทย",
                    //     style: TextStyle(
                    //       color: Colors.blueAccent,
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 16,
                    //     ),
                    //     textAlign: TextAlign.left,
                    //   ),
                    // ),

                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 15),
                      child: Row(
                        children:[
                          Text(
                            "ส่งเอกสารเมื่อ: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            "$date_s",
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
                      child: Row(
                        children:[
                          Text(
                            "ผู้ส่ง: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            "$emp_n($emp_nn)",
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
                    const SizedBox(height: 10),
                    // Container(
                    //   alignment: Alignment.centerLeft,
                    //   padding: const EdgeInsets.only(top: 5,bottom: 10),
                    //   child: const Text(
                    //     "หมายเหตุ : รับเอกสารด้วยตนเอง",
                    //     style: TextStyle(
                    //       color: Colors.black,
                    //       fontWeight: FontWeight.w500,
                    //       fontSize: 14,
                    //     ),
                    //     textAlign: TextAlign.left,
                    //   ),
                    // ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.black87,
                height: 1,
              ),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 5, bottom: 5,left: 20,right: 15),
                        // margin: EdgeInsets.all(10),
                        // alignment: Alignment.center,
                        decoration: BoxDecoration(
                          // border: Border.all(
                          //     color: Colors.grey.shade500
                          // ),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: ElevatedButton(///อนุมัติ
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              elevation: 3,
                              // shape: CircleBorder(),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)
                              ),
                            ),
                            onPressed: status == "รอคัดเลือก" ? (){
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
                                // desc: _note.text,
                                showCloseIcon: false,
                                btnOkText: "ตกลง",
                                btnCancelText: "ยกเลิก",
                                btnOkOnPress: () {
                                  context.loaderOverlay.show();
                                  setStatus(id,"ผ่าน");
                                },
                                btnCancelOnPress: (){
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  // _note.clear();
                                },
                              ).show();
                            } : null,
                            child: const Icon(
                              Icons.check_circle,
                              size: 50,
                              color: Colors.white,
                            )
                        ),
                      ),
                    ),
                    // const SizedBox(width: 20,),
                    const VerticalDivider(
                      width: 10,
                      thickness: 1,
                      color: Colors.black87,
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 5, bottom: 5,left: 20,right: 15),
                        // margin: EdgeInsets.all(10),
                        // alignment: Alignment.center,
                        decoration: BoxDecoration(
                          // border: Border.all(
                          //     color: Colors.grey.shade500
                          // ),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: ElevatedButton(///อนุมัติ
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              elevation: 3,

                              // shape: CircleBorder(),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)
                              ),
                            ),
                            onPressed: status == "รอคัดเลือก" ?(){
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
                                // desc: _note.text,
                                showCloseIcon: false,
                                btnOkText: "ตกลง",
                                btnCancelText: "ยกเลิก",
                                btnOkOnPress: () {
                                  context.loaderOverlay.show();
                                  setStatus(id,"ไม่ผ่าน");
                                },
                                btnCancelOnPress: (){
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  // _note.clear();
                                },
                              ).show();
                            } : null,
                            child: const Icon(
                              Icons.cancel,
                              size: 50,
                              color: Colors.white,
                            )
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      width: 10,
                      thickness: 1,
                      color: Colors.black87,
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(right: 20,left: 20),
                        // margin: EdgeInsets.all(10),
                        // alignment: Alignment.center,
                        decoration: BoxDecoration(
                          // border: Border.all(
                          //     color: Colors.grey.shade500
                          // ),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: ElevatedButton(//
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              elevation: 3,
                              // shape: CircleBorder(),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)
                              ),
                            ),
                            onPressed: (){
                              // showModalBottomSheet(
                              //     elevation: 0,
                              //     enableDrag: true,
                              //     isDismissible: true,
                              //     isScrollControlled: true,
                              //     backgroundColor: Colors.transparent,
                              //     context: context,
                              //     // builder: (context) => CalendarTimeWorkPage()
                              //     builder: (context) => WebCheckINChecKOutPage(link: link),
                              //     // transitionAnimationController: _controller
                              // );
                              Navigator.push(context, MaterialPageRoute(builder: (context) => WebCheckINChecKOutPage(link: link)));
                            },
                            child: const Icon(
                              Icons.description,
                              size: 50,
                              color: Colors.white,
                            )
                        ),
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
