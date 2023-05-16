import 'dart:convert';

import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:index/api/url.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DocDebHolyDetail extends StatefulWidget {
  final String id;
  const DocDebHolyDetail({Key? key, required this.id}) : super(key: key);

  @override
  State<DocDebHolyDetail> createState() => _DocDebHolyDetailState();
}

class _DocDebHolyDetailState extends State<DocDebHolyDetail> {
  bool loading = false;

  String token = "";
  Future<Null> getToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
    await getdata();
  }

  String? dt;
  String? img;
  List dataNote = [];
  List dataID = [];
  List dataEmp = [];
  Future<Null> getdata() async{
    try{
      String url = pathurl.fHolyId + widget.id;
      final respones = await get(
          Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
      );
      var data = jsonDecode(respones.body);
      if(respones.statusCode == 200){
        setState(() {
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              loading = true;
            });
          });
          dataID = data['data'];
          dataEmp = data['data'][0]['rh_emp'];
          if(data['data'][0]['rh_note'] == ""){
            dataNote = [];
          }else{
            dataNote = data['data'][0]['rh_note'];
          }
          var startDate = dataID[0]['rh_date_holiday'];
          var createdDate = dataID[0]['rh_date_created'];
          checkDate(startDate,createdDate);
        });
      }
    }catch(e){

    }
  }

  int? numDay;
  int? numHH;
  DateTime? St;
  DateTime? Cre;
  Future<Null> checkDate(start,create) async{
    var dateStart = DateFormat("dd/MM/yyyy HH:mm").parse("${start} 00:00");
    var dateCreate = DateFormat("dd/MM/yyyy HH:mm").parse(create);
    St = dateStart;
    Cre = dateCreate;
    print(St);
    print(Cre);
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
    super.initState();

    Future.delayed(const Duration(seconds: 1),(){
      setState(() {
        loading = true;
      });
    });

    getToken();
    print(widget.id);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text("รายละเอียดเปลี่ยนวันหยุด"),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
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
      body: loading ? SingleChildScrollView(
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
                  decoration: dataID[0]['rh_status'] == 'ยกเลิก' ? BoxDecoration(
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
                              "วันที่หยุด",
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
                                "${dataID[0]['rh_date_holiday']}",
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
                              "เปลี่ยนเป็นวันที่",
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
                                "${dataID[0]['rh_date_change']}",
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
                                "${dataID[0]['rh_details']}",
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
                              "${dataID[0]['rh_status']}",
                              style: TextStyle(
                                color: dataID[0]['rh_status'] == 'อนุมัติ' ? Colors.green
                                    : dataID[0]['rh_status'] == 'ไม่อนุมัติ' || dataID[0]['rh_status'] == 'ยกเลิก'? Colors.red
                                    : dataID[0]['rh_status'] == 'ตีกลับ' ? Colors.orange
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
