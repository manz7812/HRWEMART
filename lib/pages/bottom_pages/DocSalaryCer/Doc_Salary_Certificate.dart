import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:index/api/url.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widjet/popupAlert.dart';

class DocSalaryCertificatePage extends StatefulWidget {
  const DocSalaryCertificatePage({Key? key}) : super(key: key);

  @override
  State<DocSalaryCertificatePage> createState() => _DocSalaryCertificatePageState();
}

class _DocSalaryCertificatePageState extends State<DocSalaryCertificatePage> {

  bool isButtonActive = false;
  bool loading = false;
  final  controllerhedpon = TextEditingController();
  final  controlleraddress = TextEditingController();

  String token = "";
  Future<Null> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
  }

  Future<Null> senddata(data) async{
    String url = pathurl.sendDTDocSalaryCer;
    final response = await post(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
      body: data,
    );
    print(response.statusCode);
    if(response.statusCode == 201){
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
        // autoHide: Duration(seconds: 3),
        // dialogBackgroundColor: Colors.deepPurpleAccent,
        title: 'บันทึกข้อมูลสำเร็จ',
        showCloseIcon: false,
        btnOkText: "ตกลง",
        btnOkOnPress: () {
          Navigator.of(context).pop();
        },
      ).show();
      // Future.delayed(const Duration(seconds: 4),(){
      //   Navigator.of(context).pop();
      // });
    }else if(response.statusCode == 401){
      context.loaderOverlay.hide();
      popup().sessionexpire(context);
    }else if(response.statusCode == 403){
      context.loaderOverlay.hide();
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
          desc: 'เนื่องจากไม่มีการตั้งค่าผู้อนุมัติ\nติดต่อHR',
          btnOkText: "ตกลง",
          btnCancelText: "ยกเลิก",
          btnOkOnPress: () {
            Navigator.pop(context);
          },
        ).show();
      });
    }
    else{
      context.loaderOverlay.hide();
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
            Navigator.pop(context);
          },
        ).show();
      });
    }
  }

  @override
  void initState() {
    getToken();
    controllerhedpon.addListener(() {
      setState(() {
        // isButtonActive = controllerhedpon.text.isNotEmpty;
      });
    });
    controlleraddress.addListener(() {
      setState(() {
        // isButtonActive = controlleraddress.text.isNotEmpty;
      });
    });
    Future.delayed(const Duration(seconds: 1),(){
      setState(() {
        loading = true;
      });
    });
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
        title: const Text("หนังสือรับรองเงินเดือน"),
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.of(pageContext).pop();
        //     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => InsertDocLAPage(),), (route) => route.isFirst);
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
      body: loading ? LoaderOverlay(
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
                            'ขอหนังสือรับรองเงินเดือน',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Column(
                          children: [
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
                              enabled: true,
                              maxLines: 3,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                hintText: "กรุณากรอกรายละเอียด",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade700)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 0.0, bottom: 4.0),
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
                              enabled: true,
                              maxLines: 5,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                hintText: "จัดส่งเอกสารไปที่...,รับด้วยตัวเองที่แผนกบุคคล",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade700)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
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
                                    borderRadius:
                                    BorderRadius.circular(5)),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 3,
                                      backgroundColor: Colors.amber,
                                      // minimumSize: Size(width, 100),
                                    ),
                                    onPressed: controllerhedpon.text.isNotEmpty && controlleraddress.text.isNotEmpty
                                              ? (){
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
                                                      context.loaderOverlay.show();
                                                    },
                                                    btnCancelOnPress: (){
                                                      FocusScope.of(context).requestFocus(FocusNode());
                                                    },
                                                  ).show();
                                                });
                                              }
                                              : null,
                                    child: Text('บันทึก')),
                              ),
                            ),
                          ],
                        ),
                        // Expanded(
                        //   flex: 0,
                        //   child: Container(
                        //     width: double.infinity,
                        //     // padding: const EdgeInsets.only(right: 16, left: 16),
                        //     // margin: EdgeInsets.all(10),
                        //     // alignment: Alignment.center,
                        //     decoration: BoxDecoration(
                        //       // border: Border.all(
                        //       //     color: Colors.grey.shade500
                        //       // ),
                        //         borderRadius: BorderRadius.circular(5)
                        //     ),
                        //     child: TextButton(
                        //         style: TextButton.styleFrom(
                        //           backgroundColor: Colors.green,
                        //           primary: Colors.white,
                        //           // minimumSize: Size(width, 100),
                        //         ),
                        //         onPressed: (){},
                        //         child: Text('บันทึก')),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
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
}
