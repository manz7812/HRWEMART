import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/url.dart';
import '../../widjet/popupAlert.dart';

class DetailDocSalaryCertificatePage extends StatefulWidget {
  final String id;
  final Function? onGoBack;
  const DetailDocSalaryCertificatePage({Key? key, required this.id,this.onGoBack}) : super(key: key);

  @override
  State<DetailDocSalaryCertificatePage> createState() =>
      _DetailDocSalaryCertificatePageState();
}

class _DetailDocSalaryCertificatePageState extends State<DetailDocSalaryCertificatePage> {
  bool loading = false;
  final controllerhedpon = TextEditingController();
  final controlleraddress = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool checkbotton = false;

  int _index = 0;
  List aryStep = [];
  List<Step> steps =  [];

  String token = "";
  Future<Null> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
    getdata();
  }

  List dataNote = [];
  List dataID = [];
  bool checkStatus = false;

  Future<Null> getdata() async {
    try{
      setState(() {
        loading = false;
      });
      String url = pathurl.getDTDocSalaryCerID+widget.id;
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

          if(dataID[0]['sc_bounce'] == ""){
            dataNote = [];
          }else{
            dataNote = dataID[0]['sc_bounce'];
          }

          if(dataID[0]['sc_status'] == "อนุมัติ"){
            checkStatus = false;
          }else if(dataID[0]['sc_status'] == "ตีกลับ"){
            checkStatus = true;
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

  Future<Null> senddata(data) async{
    String url = pathurl.updateDTDocSalaryCerID+widget.id;
    final response = await put(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
      body: data,
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
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => super.widget));
          },
        ).show();
      });
    }
  }

  @override
  void initState() {
    getToken();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        loading = true;
        aryStep = dataID[0]['sc_step'];
        for(var i = 0; i<aryStep.length; i++){
          steps.add(
               Step(
                title: Text('${aryStep[i]['status']}',style: TextStyle(color: i == aryStep.length -1 ? Colors.green : Colors.grey),),
                subtitle: Text("${aryStep[i]['date']}",style: TextStyle(color: i == aryStep.length -1 ? Colors.green : Colors.grey),),
                // content: Container(),
                   content: SizedBox(),
                isActive: i == aryStep.length -1,
                   // isActive: i == 3,
                state: StepState.complete
              )
          );
        }
        _index = aryStep.length -1;
        print(dataID[0]['sc_reason']);
        controllerhedpon.text = dataID[0]['sc_reason'];
        controlleraddress.text = dataID[0]['sc_details'];
      });
    });
    print(widget.id);

    super.initState();
  }

  @override
  void dispose() {
    controllerhedpon.dispose();
    controlleraddress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          title: const Text("รายละเอียดหนังสือรับรองเงินเดือน"),
          // leading: IconButton(
          //   onPressed: () {
          //     Navigator.of(pageContext).pop();
          //     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => InsertDocLAPage(),), (route) => route.isFirst);
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
        body: loading
            ? LoaderOverlay(
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
                              borderSide: const BorderSide(color: Colors.white)),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  // height: 200,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(8),
                                  child: const Text(
                                    'ขอเอกสารรับรองเงินเดือน',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 0.0, bottom: 4.0),
                                  alignment: Alignment.topLeft,
                                  child: const Text(
                                    "เหตุผลที่ขอ",
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
                                  enabled: checkbotton ? true : false,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    // hintText: "กรุณากรอกรายละเอียด",
                                    filled: checkbotton == true ? false: true,
                                    fillColor: Colors.grey.shade200,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade700)),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                                  alignment: Alignment.topLeft,
                                  child: const Text(
                                    "รายละเอียด",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                TextFormField(
                                  controller: controlleraddress,
                                  enabled: checkbotton ? true : false,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    filled: checkbotton == true ? false: true,
                                    fillColor: Colors.grey.shade200,
                                    hintText: "กรุณากรอกรายละเอียด",
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade700)),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                checkStatus == true
                                ? Row(
                                  children: [
                                    checkbotton == true
                                    ? Expanded(
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
                                              backgroundColor: Colors.red,
                                              // primary: Colors.white,
                                              // minimumSize: Size(width, 100),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                checkbotton = false;
                                              });
                                            },
                                            child: Text('ยกเลิก (แก้ไข)')),
                                      ),
                                    )
                                    : Expanded(
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
                                              backgroundColor: Colors.red,
                                              // primary: Colors.white,
                                              // minimumSize: Size(width, 100),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('ยกเลิก (เอกสาร)')),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    checkbotton == true
                                    ?Expanded(
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
                                              backgroundColor: Colors.green,
                                              // minimumSize: Size(width, 100),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                var jsdt = {
                                                  "sc_reason": controllerhedpon.text,
                                                  "sc_details": controlleraddress.text
                                                };
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
                                                    checkbotton = false;
                                                    // senddata();
                                                    // context.loaderOverlay.show();
                                                  },
                                                  btnCancelOnPress: (){
                                                    FocusScope.of(context).requestFocus(FocusNode());
                                                  },
                                                ).show();
                                              });
                                            },
                                            child: Text('บันทึก')),
                                      ),
                                    )
                                    :Expanded(
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
                                              backgroundColor: Colors.amber,
                                              // minimumSize: Size(width, 100),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                checkbotton = true;
                                              });
                                            },
                                            child: Text('แก้ไข')),
                                      ),
                                    ),
                                  ],
                                )
                                : Container()
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 3,
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(color: Colors.white)),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  // height: 200,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(8),
                                  child: const Text(
                                    'หนังสือรับรองเงินเดือนพนักงาน',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                // Container(
                                //   width: double.infinity,
                                //   // height: 200,
                                //   alignment: Alignment.center,
                                //   padding: const EdgeInsets.all(8),
                                //   child: const Text(
                                //     'โดยหนังสือฉบับนี้ ออกให้ นางสาว กรรณิการ์ แก้วอุดม '
                                //         'ปฎิบัติงานเป็นพนักงานรายเดือน ในตำแหน่ง เจ้าหน้าที่ Call Center ของบริษัทวีมาร์ท จำกัด มีอัตราเงินเดือนล่าสุด 0.00 บาท ต่อเดือน'
                                //         'โดยเริ่มเป็นพนักงานเมื่อวันที่ 16/03/2022 จนถึงปัจจุบัน',
                                //     style: TextStyle(
                                //         fontSize: 16,
                                //         fontWeight: FontWeight.w500),
                                //   ),
                                // ),
                                Container(
                                  width: double.infinity,
                                  // height: 200,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(8),
                                  child: RichText(
                                    text:  TextSpan(
                                      // text: 'hello',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                          fontFamily: 'Prompt',
                                      ),
                                      children: [
                                        TextSpan(
                                            text: 'หนังสือฉบับนี้ให้ไว้เพื่อรับรองว่า '
                                        ),
                                        TextSpan(
                                            text: '${dataID[0]['emp']['name']}',
                                            style: TextStyle(
                                                // decoration: TextDecoration.underline,
                                                // decorationStyle: TextDecorationStyle.solid,
                                              fontWeight: FontWeight.w700
                                            ),
                                        ),
                                        const TextSpan(
                                            text: ' ตำแหน่ง '
                                        ),
                                        TextSpan(
                                          text: '${dataID[0]['emp']['pos_name']}',
                                          style: TextStyle(
                                            // decoration: TextDecoration.underline,
                                            // decorationStyle: TextDecorationStyle.solid
                                              fontWeight: FontWeight.w700
                                          ),
                                        ),

                                        TextSpan(
                                            text: ' ${dataID[0]['section']} ',
                                          style: TextStyle(
                                            // decoration: TextDecoration.underline,
                                            // decorationStyle: TextDecorationStyle.solid
                                              fontWeight: FontWeight.w700
                                          ),
                                        ),
                                        TextSpan(
                                          text: '${dataID[0]['department']}',
                                          style: TextStyle(
                                            // decoration: TextDecoration.underline,
                                            // decorationStyle: TextDecorationStyle.solid
                                              fontWeight: FontWeight.w700
                                          ),
                                        ),
                                        const TextSpan(
                                            text: ' โดยเริ่มปฎิบัติงานตั้งแต่วันที่ '
                                        ),
                                        TextSpan(
                                            text: '${dataID[0]['emp_date']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700
                                              // decoration: TextDecoration.underline,
                                              // decorationStyle: TextDecorationStyle.solid
                                            )
                                        ),
                                        const TextSpan(
                                            text: ' จนถึงปัจจุบัน'
                                        ),
                                        const TextSpan(
                                            text: ' มีอัตราเงินเดือน '
                                        ),
                                        TextSpan(
                                            text: '${dataID[0]['emp_salary']}',
                                            style: TextStyle(
                                                // decoration: TextDecoration.underline,
                                                // decorationStyle: TextDecorationStyle.solid
                                                fontWeight: FontWeight.w700
                                            )
                                        ),
                                        TextSpan(
                                            text: ' (${dataID[0]['salary_baht']})',
                                        ),
                                      ]
                                    ),
                                  ),
                                ),
                                // Expanded(
                                //   flex: 0,
                                //   child: Container(
                                //     width: double.infinity,
                                //     // height: 200,
                                //     alignment: Alignment.center,
                                //     padding: const EdgeInsets.all(8),
                                //     child: Column(
                                //       children: [
                                //         Text(
                                //           'จึงออกหนังสือรับรองนี้ไว้เป็นหลักฐาน ไห้ไว้ ณ วันที่ ',
                                //           style: TextStyle(
                                //               fontSize: 16,
                                //           ),
                                //         ),
                                //         Container(
                                //           alignment: Alignment.centerRight,
                                //           child: Text(
                                //             '31/12/2565',
                                //             style: TextStyle(
                                //                 fontSize: 16,
                                //                 fontWeight: FontWeight.w700),
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                Container(
                                  width: double.infinity,
                                  // height: 200,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children:[
                                       Text(
                                        'สถานะ : ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        '${dataID[0]['sc_status']}',
                                        style: TextStyle(
                                          color: dataID[0]['sc_status'] == 'อนุมัติ' || dataID[0]['sc_status'] == 'สำเร็จ' ?Colors.green
                                              : dataID[0]['sc_status'] == 'ไม่อนุมัติ' || dataID[0]['sc_status'] == 'ยกเลิก'? Colors.red
                                              : dataID[0]['sc_status'] == 'ตีกลับ' ? Colors.orange
                                              : dataID[0]['sc_status'] == 'รออนุมัติ' ? Colors.yellow : Colors.blue,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Container(
                                //   width: double.infinity,
                                //   // height: 200,
                                //   padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                //   child: Row(
                                //     children: [
                                //       Container(
                                //         padding: const EdgeInsets.fromLTRB(100, 0, 0, 0),
                                //         child: Text(
                                //           'ยื่นขอเมื่อ',
                                //           style: TextStyle(
                                //               fontSize: 16,
                                //               fontWeight: FontWeight.w500),
                                //         ),
                                //       ),
                                //       const Spacer(),
                                //       Text(
                                //         '29/03/2022',
                                //         style: TextStyle(
                                //             fontSize: 16,
                                //             fontWeight: FontWeight.w500),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // Container(
                                //   width: double.infinity,
                                //   // height: 200,
                                //   padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                //   child: Row(
                                //     children: [
                                //       Container(
                                //         padding: const EdgeInsets.fromLTRB(100, 0, 0, 0),
                                //         child: Text(
                                //           'อนุมัติเมื่อ',
                                //           style: TextStyle(
                                //               fontSize: 16,
                                //               fontWeight: FontWeight.w500),
                                //         ),
                                //       ),
                                //       const Spacer(),
                                //       Text(
                                //         '',
                                //         style: TextStyle(
                                //             fontSize: 16,
                                //             fontWeight: FontWeight.w500),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // Container(
                                //   width: double.infinity,
                                //   // height: 200,
                                //   padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                //   child: Row(
                                //     children: [
                                //       Container(
                                //         padding: const EdgeInsets.fromLTRB(100, 0, 0, 0),
                                //         child: Text(
                                //           'ส่งเอกสารเมื่อ',
                                //           style: TextStyle(
                                //               fontSize: 16,
                                //               fontWeight: FontWeight.w500),
                                //         ),
                                //       ),
                                //       const Spacer(),
                                //       Text(
                                //         '',
                                //         style: TextStyle(
                                //             fontSize: 16,
                                //             fontWeight: FontWeight.w500),
                                //       ),
                                //     ],
                                //   ),
                                // ),

                                Container(
                                  padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                  child: Stepper(
                                    key: _key,
                                    physics: ClampingScrollPhysics(),
                                    controlsBuilder: (context, _) {
                                      return Container();
                                      //   Row(
                                      //   children: <Widget>[
                                      //     TextButton(
                                      //       onPressed: () {},
                                      //       child: const Text(
                                      //         'NEXT',
                                      //         style:
                                      //         TextStyle(color: Colors.blue),
                                      //       ),
                                      //     ),
                                      //     TextButton(
                                      //       onPressed: () {},
                                      //       child: const Text(
                                      //         'EXIT',
                                      //         style:
                                      //         TextStyle(color: Colors.blue),
                                      //       ),
                                      //     ),
                                      //   ],
                                      // );
                                    },
                                    currentStep: _index,
                                    // onStepCancel: () {
                                    //   if (_index > 0) {
                                    //     setState(() {
                                    //       _index -= 1;
                                    //     });
                                    //   }
                                    // },
                                    // onStepContinue: () {
                                    //   if (_index <= 0) {
                                    //     setState(() {
                                    //       _index += 1;
                                    //     });
                                    //   }
                                    // },
                                    // onStepTapped: (int index) {
                                    //   setState(() {
                                    //     _index = index;
                                    //   });
                                    // },
                                    steps: steps,
                                  ),
                                ),

                                dataNote.isEmpty ? Container() :
                                Container(
                                  padding: const EdgeInsets.only(left: 12.0, top: 0, bottom: 4.0),
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
                                const SizedBox(height: 10),
                                dataID[0]['sc_status'] == "ส่งเอกสาร"
                                ? Expanded(
                                  flex: 0,
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
                                    child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          primary: Colors.white,
                                          // minimumSize: Size(width, 100),
                                        ),
                                        onPressed: () {},
                                        child: Text('ยืนยันรับเอกสาร')),
                                  ),
                                )
                                : Container()
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
              )));
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
