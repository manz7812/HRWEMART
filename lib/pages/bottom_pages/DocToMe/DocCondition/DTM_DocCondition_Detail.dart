import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:index/api/url.dart';
import '../../../widjet/popupAlert.dart';

class DTMDocConditionDetailPage extends StatefulWidget {
  final String id;
  const DTMDocConditionDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DTMDocConditionDetailPage> createState() => _DTMDocConditionDetailPageState();
}

class _DTMDocConditionDetailPageState extends State<DTMDocConditionDetailPage> {
  bool loading = false;


  int _index = 0;
  List aryStep = [];
  List<Step> steps =  [];

  onGoBack(dynamic value) {
    getToken();
  }

  String token = "";
  Future<Null> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
    getdata();
  }
  String? dt;
  String? img;
  List dataNote = [];
  List dataID = [];
  List dataEmp = [];

  Future<Null> getdata() async {
    try{
      setState(() {
        dataEmp = [];
        loading = false;
      });
      String url = pathurl.dtmKConditionId+widget.id;
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
          // print(dataID[0]['wl_emp']);
          dataEmp.add(dataID[0]['cc_emp']);
          if(dataID[0]['cc_bounce'] == ""){
            dataNote = [];
          }else{
            dataNote = dataID[0]['cc_bounce'];
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
      print("e=$e");
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


  @override
  void initState() {
    getToken();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        loading = true;
        aryStep = dataID[0]['cc_step'];
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
      });
    });
    print(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text("รายละเอียดแจ้งเปลี่ยนสภาพพนักงาน"),
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
                    decoration: dataID[0]['cc_status'] == 'ยกเลิก' ? BoxDecoration(
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
                          children: <Widget>[
                            Text("หมายเลขเอกสาร : ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.black),),
                            Text("${widget.id}",style: TextStyle(fontSize: 16,color: Colors.black),),
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
                                "วันที่ขอ",
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
                                  "${dataID[0]['cc_date_created']}",
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
                                "วันที่มีผล",
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
                                  "${dataID[0]['cc_date']}",
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
                          padding: const EdgeInsets.only(left: 12.0, bottom: 0.0),
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "เรื่อง",
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
                                  "${dataID[0]['cc_title']}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(25, 0, 10, 10),
                                child: Text(
                                  "${dataID[0]['cc_other']}",
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
                                padding: EdgeInsets.fromLTRB(25, 0, 10, 10),
                                child: Text(
                                  "${dataID[0]['cc_details']}",
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
                                "${dataID[0]['cc_status']}",
                                style: TextStyle(
                                  color: dataID[0]['cc_status'] == 'อนุมัติ' || dataID[0]['cc_status'] == 'สำเร็จ' ?Colors.green
                                      : dataID[0]['cc_status'] == 'ไม่อนุมัติ' || dataID[0]['cc_status'] == 'ยกเลิก'? Colors.red
                                      : dataID[0]['cc_status'] == 'ตีกลับ' ? Colors.orange
                                      : dataID[0]['cc_status'] == 'รออนุมัติ' ? Colors.yellow : Colors.blue,
                                  fontWeight: FontWeight.w700,
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
                          child: Row(
                            children:[
                              Text(
                                'ติดตามสถานะ : ',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '${dataID[0]['cc_status']}',
                                style: TextStyle(
                                  color: dataID[0]['cc_status'] == 'อนุมัติ' || dataID[0]['cc_status'] == 'สำเร็จ' ?Colors.green
                                      : dataID[0]['cc_status'] == 'ไม่อนุมัติ' || dataID[0]['cc_status'] == 'ยกเลิก'? Colors.red
                                      : dataID[0]['cc_status'] == 'ตีกลับ' ? Colors.orange
                                      : dataID[0]['cc_status'] == 'รออนุมัติ' ? Colors.yellow : Colors.blue,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: Stepper(
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

                        const SizedBox(height: 10),
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
