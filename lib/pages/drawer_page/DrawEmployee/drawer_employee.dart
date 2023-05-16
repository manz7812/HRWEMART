import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:geira_icons/geira_icons.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:index/api/model_employee.dart';
import 'package:index/api/url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widjet/popupAlert.dart';
import '../drawer_index.dart';
import '../drawer_menu.dart';
import 'edit_data_employee.dart';

class EmployeePage extends StatefulWidget {
  final String title;
  const EmployeePage({Key? key , required this.title}) : super(key: key);

  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {

  bool loading = false;
  PickedFile? _imageFile;
  File? selectedImage;


  final ImagePicker _picker = ImagePicker();

  void pickImage(ImageSource source) async{
    final pickedFile = await _picker.getImage(source: source);

    setState(() {
      _imageFile = pickedFile!;
    });
  }

  Future getImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      selectedImage = File(image!.path); // won't have any error now
    });
  }

  String token = "";
  Future<Null> getToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")??"";
    await getdata();
    await settingApprove();
    await settingHoliday();
    await settingWorkKa();
    await readdress();
    await refamily();
    await reworkhis();
    await reeduhis();
    await retalents();
    await redocs();
    await training();
    await assets();
    await hospital();
    await incomeexpen();
  }

  List dataP = [];
  Future<Null> getdata() async{
    String url = pathurl.urlprofile;
    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
      setState(() {
        dataP.add(data["data"]);
      });
    }else if(response.statusCode == 401){
      popup().sessionexpire(context);
    }
  }

  List dataAP = [];
  Future<Null> settingApprove() async{
    String url = pathurl.settingApprove;
    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
      setState(() {
        dataAP = data["data"];
        // print(dataAP);
      });
    }else if(response.statusCode == 401){
      popup().sessionexpire(context);
    }
  }

  List dataSHoliday = [];
  Future<Null> settingHoliday() async{
    String url = pathurl.settingHoliday;
    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
      if(data["data"].isNotEmpty){
        dataSHoliday.add(data["data"]);
      }else{
        dataSHoliday = [];
      }

    }else if(response.statusCode == 401){
      popup().sessionexpire(context);
    }
  }

  List dataSWKa = [];
  Future<Null> settingWorkKa() async{
    String url = pathurl.settingWKa;
    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
      setState(() {
        dataSWKa = data["data"];
      });
    }else if(response.statusCode == 401){
      popup().sessionexpire(context);
    }
  }

  List dataReAddress = [];
  Future<Null> readdress() async{
    String url = pathurl.reAddress;
    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
      setState(() {
        dataReAddress = data["data"];
      });
    }else if(response.statusCode == 401){
      popup().sessionexpire(context);
    }
  }

  List dataReFamily = [];
  Future<Null> refamily() async{
    String url = pathurl.reFamily;
    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
      setState(() {
        dataReFamily = data["data"];
      });
    }else if(response.statusCode == 401){
      popup().sessionexpire(context);
    }
  }

  List dataReWorkHis = [];
  Future<Null> reworkhis() async{
    String url = pathurl.reWorkHis;
    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
      setState(() {
        dataReWorkHis = data["data"];
      });
    }else if(response.statusCode == 401){
      popup().sessionexpire(context);
    }
  }

  List dataReEduHis = [];
  Future<Null> reeduhis() async{
    String url = pathurl.reEduHis;
    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
      setState(() {
        dataReEduHis = data["data"];
      });
    }else if(response.statusCode == 401){
      popup().sessionexpire(context);
    }
  }

  List dataReTalents = [];
  Future<Null> retalents() async{
    String url = pathurl.reTalent;
    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
      setState(() {
        dataReTalents = data["data"];
      });
    }else if(response.statusCode == 401){
      popup().sessionexpire(context);
    }
  }

  List dataReDocs = [];
  Future<Null> redocs() async{
    String url = pathurl.reDocs;
    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
      setState(() {
        dataReDocs = data["data"];
      });
    }else if(response.statusCode == 401){
      popup().sessionexpire(context);
    }
  }

  List dataTraining = [];
  Future<Null> training() async{
    String url = pathurl.userTraining;
    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
      setState(() {
        dataTraining = data["data"];
      });
    }else if(response.statusCode == 401){
      popup().sessionexpire(context);
    }
  }

  List dataAssets= [];
  Future<Null> assets() async{
    String url = pathurl.userAssets;
    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
      setState(() {
        dataAssets = data["data"];
      });
    }else if(response.statusCode == 401){
      popup().sessionexpire(context);
    }
  }

  List dataHospital = [];
  Future<Null> hospital() async{
    String url = pathurl.userHospital;
    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
      setState(() {
        dataHospital = data["data"];
      });
    }else if(response.statusCode == 401){
      popup().sessionexpire(context);
    }
  }

  List dataIncomExpen = [];
  Future<Null> incomeexpen() async{
    String url = pathurl.userIncomeExpen;
    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
      setState(() {
        dataIncomExpen = data["data"];
      });
    }else if(response.statusCode == 401){
      popup().sessionexpire(context);
    }
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1),(){
      setState(() {
        loading = true;
      });
    });
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  RefreshIndicator(
      color: Colors.white,
      backgroundColor: Colors.deepPurpleAccent.shade100,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 1500));
        setState(() {
          loading = false;
        });
        Future.delayed(const Duration(seconds: 1),(){
          setState(() {
            loading = true;
          });
          getToken();
        });

      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          // title: Text(widget.title),
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
            ),
          ),
          // toolbarHeight:MediaQuery.of(context).size.height/4,
            // shape: const RoundedRectangleBorder(
            //   borderRadius: BorderRadius.vertical(
            //     bottom: Radius.circular(50),
            //   ),
            // ),
        ),
        body: loading && dataP.length > 0 ? Stack(
          children: [
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height/6.5,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
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
                        color: Colors.deepPurpleAccent,
                        spreadRadius: 1, blurRadius: 15,
                        // offset: Offset(5, 3),
                      ),
                    ],
                    // image: DecorationImage(image: NetworkImage('https://www.pngitem.com/pimgs/m/391-3918613_personal-service-platform-person-icon-circle-png-transparent.png'))
                  ),
                  child:  Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 15),
                            // margin: const EdgeInsets.symmetric(
                            //   vertical: 30,horizontal: 0,
                            // ),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.grey.shade400,
                              child:  ClipOval(
                                  child: Center(
                                    child: Image.network(
                                      dataP.length == 0 ? "http://103.82.248.220/node/api/v1/avatars/F9/avatars.png"
                                          : dataP[0]['img_url'],
                                    ),
                                  ),
                              ),
                              // backgroundImage: _imageFile == null
                              //     ? AssetImage("")
                              //     : FileImage(File(_imageFile!.path)) as ImageProvider,
                            ),
                          ),
                          ///position
                        ],
                      ),
                      // Column(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Padding(padding: const EdgeInsets.only(top: 10,left: 10),
                      //       child: Image.asset('images/2.jpg',width: 60,)
                      //     ),
                      //   ],
                      // ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  [
                              Text(dataP.length == 0 ? "" :
                              "${dataP[0]['name'].toString().split(' ')[1]} ${dataP[0]['name'].toString().split(' ')[2]}(${dataP[0]['nick_name']})",
                                style: TextStyle(fontSize: 16,color: Colors.white),),
                              Text(dataP.length == 0 ? "" :
                              "ตำแหน่ง: ${dataP[0]['position']['pos_name']}",
                                style: TextStyle(fontSize: 16,color: Colors.white),),
                              Text(dataP.length == 0 ? "" :
                              "โทร: ${dataP[0]['tel']}",
                                style: TextStyle(fontSize: 16,color: Colors.white),),
                              Text(dataP.length == 0 ? "" :
                              "อีเมล: ${dataP[0]['email']}",
                                style: TextStyle(fontSize: 16,color: Colors.white),),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),

                ),
                const SizedBox(height: 20,),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0,bottom: 10.0),
                      child: Column(
                        children: [
                          Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              title: Text('ข้อมูลพื้นฐาน'),
                              // subtitle: Text('Trailing expansion arrow icon'),
                              children: <Widget>[
                                Card(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            // height: 150,
                                            // width: double.infinity,
                                            // alignment: Alignment.center,
                                            padding: const EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0,bottom: 0.0),
                                            child: const Text(
                                              "ข้อมูลพื้นฐาน",
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          // Container(
                                          //   padding: EdgeInsets.only(top: 8),
                                          //   child: IconButton(
                                          //     onPressed: (){
                                          //       Navigator.push(context, MaterialPageRoute(builder: (context) => const EditDataEmployeePage()));
                                          //     },
                                          //     icon: Icon(
                                          //       GIcons.pencil,
                                          //       size: 35,
                                          //     ),
                                          //   ),
                                          // )
                                        ],
                                      ),
                                      Divider(
                                        // height: 50,
                                        thickness: 1,
                                        color: Colors.grey.shade300,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                                        child: Row(
                                          children: [
                                            dataP.length == 0 ? Text("") :
                                            Text("รหัสพนักงาน : ${dataP[0]['id']}",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                                        child: Row(
                                          children: [
                                            Text("รหัสลายนิ้วมือ : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                            Text("",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                                        child: Row(
                                          children: [
                                            Text("เพศ : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                            dataP.length == 0 ? Text("") :
                                            Text("${dataP[0]['gender']}",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                                        child: Row(
                                          children: [
                                            Text("สัญชาติ : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                            dataP.length == 0 ? Text("") :
                                            Text("${dataP[0]['nationality']}",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                                        child: Row(
                                          children: [
                                            Text("สถานะ : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                            dataP.length == 0 ? Text("") :
                                            Text("${dataP[0]['status']}",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                                        child: Row(
                                          children: [
                                            Text("เลขประจำตัวประชาชน : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                            dataP.length == 0 ? Text("") :
                                            Text("${dataP[0]['card_id']}",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                                        child: Row(
                                          children: [
                                            Text("เลขประกันสังคม : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                            dataP.length == 0 ? Text("") :
                                            Text("${dataP[0]['sso_id']}",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                                        child: Row(
                                          children: [
                                            Text("วันเกิด : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                            dataP.length == 0 ? Text("") :
                                            Text("${dataP[0]['birthday']}",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                                        child: Row(
                                          children: [
                                            Text("บริษัท : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                            dataP.length == 0 ? Text("") :
                                            Text("${dataP[0]['company']['com_name']}",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                                        child: Row(
                                          children: [
                                            Text("ฝ่าย : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                            dataP.length == 0 ? Text("") :
                                            Text("${dataP[0]['department']['dep_name']}",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                                        child: Row(
                                          children: [
                                            Text("แผนก : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                            dataP.length == 0 ? Text("") :
                                            Text("${dataP[0]['section']['sec_name']}",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                                        child: Row(
                                          children: [
                                            Text("ตำแหน่ง : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                            dataP.length == 0 ? Text("") :
                                            Text("${dataP[0]['position']['pos_name']}",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                                        child: Row(
                                          children: [
                                            Text("ประเภทพนักงาน : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                            dataP.length == 0 ? Text("") :
                                            Text("${dataP[0]['level']}",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                                        child: Row(
                                          children: [
                                            Text("เงินเดือน : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                            dataP.length == 0 ? Text("") :
                                            Text("${dataP[0]['salary']}",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                          ],
                                        ),
                                      ),
                                      // Container(
                                      //   padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                                      //   child: Row(
                                      //     children: [
                                      //       Text("วงเงินเบิกล่วงหน้า : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                      //       Text("",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                      //     ],
                                      //   ),
                                      // ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                                        child: Row(
                                          children: [
                                            Text("วันที่เริ่มงาน : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                            dataP.length == 0 ? Text("") :
                                            Text("${dataP[0]['date_start']}",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                                        child: Row(
                                          children: [
                                            Text("วันที่บรรจุ : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                            dataP.length == 0 ? Text("") :
                                            Text("${dataP[0]['date_packing']}",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                                        child: Row(
                                          children: [
                                            Text("ภาษี : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                            dataP.length == 0 ? Text("") :
                                            Text("${dataP[0]['tax_id']}",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                                        child: Row(
                                          children: [
                                            Text("ช่องทางการชำระเงิน : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                            dataP.length == 0 ? Text("") :
                                            Text("${dataP[0]['payment']}",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                                        child: Row(
                                          children: [
                                            Text("ธนาคาร : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                            dataP.length == 0 ? Text("") :
                                            Text("${dataP[0]['bank']}",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 10.0),
                                        child: Row(
                                          children: [
                                            Text("เลขบัญชี : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                            dataP.length == 0 ? Text("") :
                                            Text("${dataP[0]['bank_id']}",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  elevation: 3,
                                  shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: Colors.white)
                                  ),
                                )
                              ],
                            ),
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              title: Text('ตั้งค่า'),
                              // subtitle: Text('Trailing expansion arrow icon'),
                              children: <Widget>[
                                Card(
                                  child: Column(
                                    children: [
                                      Container(
                                        // height: 150,
                                        width: double.infinity,
                                        // alignment: Alignment.center,
                                        padding: const EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0,bottom: 0.0),
                                        child: const Text(
                                          "ตั้งค่า",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Divider(
                                        // height: 50,
                                        thickness: 1,
                                        color: Colors.grey.shade300,
                                      ),
                                      ExpansionTile(
                                        title: Text('ตั้งค่าการอนุมัติ',style: TextStyle(fontSize: 16),),
                                        children: [
                                          dataAP.isEmpty
                                          ? Container(
                                            padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                                            child: Card(
                                              child: Container(
                                                height: 30,
                                                alignment: Alignment.center,
                                                // padding: const EdgeInsets.all(10),
                                                child: const Text(
                                                  "ไม่พบข้อมูล",
                                                  style: TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              elevation: 3,
                                              color: Colors.grey.shade300,
                                              shape: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(50),
                                                  borderSide:  BorderSide(color: Colors.grey.shade300)
                                              ),
                                            ),
                                          )
                                          : Container(
                                            padding: const EdgeInsets.only(top: 0.0,left: 40.0,right:40.0,bottom: 0.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                ListView.builder(
                                                  itemCount: dataAP.length,
                                                  scrollDirection: Axis.vertical,
                                                  shrinkWrap: true,
                                                  physics: ScrollPhysics(),
                                                  itemBuilder: (context , i){
                                                    return getText(dataAP[i]);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      ExpansionTile(
                                        title: Text('ตั้งค่ากะการทำงาน',style: TextStyle(fontSize: 16),),
                                        children: [
                                          dataSWKa.isEmpty
                                          ? Container(
                                            padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                                            child: Card(
                                              child: Container(
                                                height: 30,
                                                alignment: Alignment.center,
                                                // padding: const EdgeInsets.all(10),
                                                child: const Text(
                                                  "ไม่พบข้อมูล",
                                                  style: TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              elevation: 3,
                                              color: Colors.grey.shade300,
                                              shape: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(50),
                                                  borderSide:  BorderSide(color: Colors.grey.shade300)
                                              ),
                                            ),
                                          )
                                          : ListView.builder(
                                              itemCount: dataSWKa.length,
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              physics: ScrollPhysics(),
                                              itemBuilder: (context , i){
                                                return getTextKa(dataSWKa[i]);
                                              },
                                          ),

                                        ],
                                      ),
                                      ExpansionTile(
                                        title: Text('ตั้งค่าวันทำงาน- วันหยุด',style: TextStyle(fontSize: 16),),
                                        children: [
                                          dataSHoliday.isEmpty
                                          ?Container(
                                            padding: EdgeInsets.fromLTRB(50, 0, 50, 10),
                                            child: Card(
                                              child: Container(
                                                height: 30,
                                                alignment: Alignment.center,
                                                // padding: const EdgeInsets.all(10),
                                                child: const Text(
                                                  "ไม่พบข้อมูล",
                                                  style: TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              elevation: 3,
                                              color: Colors.grey.shade300,
                                              shape: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(50),
                                                  borderSide:  BorderSide(color: Colors.grey.shade300)
                                              ),
                                            ),
                                          )
                                          :Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(top: 0.0,left: 40.0,right:40.0,bottom: 0.0),
                                                child: Row(
                                                  children: [
                                                    Text("จ : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                                    Text("${dataSHoliday[0]['mon_day']?? ""}",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(top: 0.0,left: 40.0,right:40.0,bottom: 0.0),
                                                child: Row(
                                                  children: [
                                                    Text("อ : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                                    Text("${dataSHoliday[0]['tue_day']}",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(top: 0.0,left: 40.0,right:40.0,bottom: 0.0),
                                                child: Row(
                                                  children: [
                                                    Text("พ : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                                    Text("${dataSHoliday[0]['wed_day']}",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(top: 0.0,left: 40.0,right:40.0,bottom: 0.0),
                                                child: Row(
                                                  children: [
                                                    Text("พฤ : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                                    Text("${dataSHoliday[0]['thu_day']}",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(top: 0.0,left: 40.0,right:40.0,bottom: 0.0),
                                                child: Row(
                                                  children: [
                                                    Text("ศ : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                                    Text("${dataSHoliday[0]['fri_day']}",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(top: 0.0,left: 40.0,right:40.0,bottom: 0.0),
                                                child: Row(
                                                  children: [
                                                    Text("ส : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                                    Text("${dataSHoliday[0]['sat_day']}",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(top: 0.0,left: 40.0,right:40.0,bottom: 10.0),
                                                child: Row(
                                                  children: [
                                                    Text("อา : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                                    Text("${dataSHoliday[0]['sun_day']}",style: TextStyle(fontSize: 16,color: Colors.black87),),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  elevation: 3,
                                  shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: Colors.white)
                                  ),
                                )
                              ],
                            ),
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              title: Text('ประวัติส่วนตัว'),
                              // subtitle: Text('Trailing expansion arrow icon'),
                              children: <Widget>[
                                Card(
                                  child: Column(
                                    children: [
                                      Container(
                                        // height: 150,
                                        width: double.infinity,
                                        // alignment: Alignment.center,
                                        padding: const EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0,bottom: 0.0),
                                        child: const Text(
                                          "ประวัติส่วนตัว",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Divider(
                                        // height: 50,
                                        thickness: 1,
                                        color: Colors.grey.shade300,
                                      ),
                                      ExpansionTile(
                                        title: Text('ที่อยู่ตามบัตรประชาชน',style: TextStyle(fontSize: 16),),
                                        children: [
                                          dataReAddress.isEmpty
                                          ? Container(
                                            padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                                            child: Card(
                                              child: Container(
                                                height: 30,
                                                alignment: Alignment.center,
                                                // padding: const EdgeInsets.all(10),
                                                child: const Text(
                                                  "ไม่พบข้อมูล",
                                                  style: TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              elevation: 3,
                                              color: Colors.grey.shade300,
                                              shape: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(50),
                                                  borderSide:  BorderSide(color: Colors.grey.shade300)
                                              ),
                                            ),
                                          )
                                          : Container(
                                            padding: const EdgeInsets.only(top: 0.0,left: 40.0,right:40.0,bottom: 0.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text("${dataReAddress[0]['address_card']}")
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      ExpansionTile(
                                        title: Text('ที่อยู่ปัจจุบัน',style: TextStyle(fontSize: 16),),
                                        children: [
                                          dataReAddress.isEmpty
                                          ? Container(
                                            padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                                            child: Card(
                                              child: Container(
                                                height: 30,
                                                alignment: Alignment.center,
                                                // padding: const EdgeInsets.all(10),
                                                child: const Text(
                                                  "ไม่พบข้อมูล",
                                                  style: TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              elevation: 3,
                                              color: Colors.grey.shade300,
                                              shape: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(50),
                                                  borderSide:  BorderSide(color: Colors.grey.shade300)
                                              ),
                                            ),
                                          )
                                          : Container(
                                            padding: const EdgeInsets.only(top: 0.0,left: 40.0,right:40.0,bottom: 0.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text("${dataReAddress[0]['address_current']}")
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      ExpansionTile(
                                        title: Text('ครอบครัว',style: TextStyle(fontSize: 16),),
                                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          dataReFamily.isEmpty
                                          ? Container(
                                        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                                        child: Card(
                                          child: Container(
                                            height: 30,
                                            alignment: Alignment.center,
                                            // padding: const EdgeInsets.all(10),
                                            child: const Text(
                                              "ไม่พบข้อมูล",
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          elevation: 3,
                                          color: Colors.grey.shade300,
                                          shape: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(50),
                                              borderSide:  BorderSide(color: Colors.grey.shade300)
                                          ),
                                        ),
                                      )
                                          : Container(
                                            padding: const EdgeInsets.only(top: 0.0,left: 40.0,right:40.0,bottom: 0.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("${dataReFamily[0]['relation']}"),
                                                Text("${dataReFamily[0]['full_name']}"),
                                                Text("${dataReFamily[0]['tel']}"),
                                                Text("${dataReFamily[0]['email']}"),
                                                Text("${dataReFamily[0]['birthday']}"),
                                                Text("${dataReFamily[0]['address']}"),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      ExpansionTile(
                                        title: Text('ประวัติการทำงาน',style: TextStyle(fontSize: 16),),
                                        children: [
                                          dataReWorkHis.isEmpty
                                          ? Container(
                                        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                                        child: Card(
                                          child: Container(
                                            height: 30,
                                            alignment: Alignment.center,
                                            // padding: const EdgeInsets.all(10),
                                            child: const Text(
                                              "ไม่พบข้อมูล",
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          elevation: 3,
                                          color: Colors.grey.shade300,
                                          shape: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(50),
                                              borderSide:  BorderSide(color: Colors.grey.shade300)
                                          ),
                                        ),
                                      )
                                          : Container(
                                            padding: const EdgeInsets.only(top: 0.0,left: 40.0,right:40.0,bottom: 0.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                ListView.builder(
                                                  itemCount: dataReWorkHis.length,
                                                  scrollDirection: Axis.vertical,
                                                  shrinkWrap: true,
                                                  physics: ScrollPhysics(),
                                                  itemBuilder: (context , i){
                                                    return getWorkHis(dataReWorkHis[i]);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      ExpansionTile(
                                        title: Text('ประวัติการศึกษา',style: TextStyle(fontSize: 16),),
                                        children: [
                                          dataReEduHis.isEmpty
                                          ? Container(
                                        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                                        child: Card(
                                          child: Container(
                                            height: 30,
                                            alignment: Alignment.center,
                                            // padding: const EdgeInsets.all(10),
                                            child: const Text(
                                              "ไม่พบข้อมูล",
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          elevation: 3,
                                          color: Colors.grey.shade300,
                                          shape: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(50),
                                              borderSide:  BorderSide(color: Colors.grey.shade300)
                                          ),
                                        ),
                                      )
                                          : Container(
                                            padding: const EdgeInsets.only(top: 0.0,left: 40.0,right:40.0,bottom: 0.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                ListView.builder(
                                                  itemCount: dataReEduHis.length,
                                                  scrollDirection: Axis.vertical,
                                                  shrinkWrap: true,
                                                  physics: ScrollPhysics(),
                                                  itemBuilder: (context , i){
                                                    return getEduHis(dataReEduHis[i]);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      ExpansionTile(
                                        title: Text('ความสามารถพิเศษ',style: TextStyle(fontSize: 16),),
                                        children: [
                                          dataReTalents.isEmpty
                                          ? Container(
                                        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                                        child: Card(
                                          child: Container(
                                            height: 30,
                                            alignment: Alignment.center,
                                            // padding: const EdgeInsets.all(10),
                                            child: const Text(
                                              "ไม่พบข้อมูล",
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          elevation: 3,
                                          color: Colors.grey.shade300,
                                          shape: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(50),
                                              borderSide:  BorderSide(color: Colors.grey.shade300)
                                          ),
                                        ),
                                      )
                                          : Container(
                                            padding: const EdgeInsets.only(top: 0.0,left: 40.0,right:40.0,bottom: 0.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                ListView.builder(
                                                  itemCount: dataReTalents.length,
                                                  scrollDirection: Axis.vertical,
                                                  shrinkWrap: true,
                                                  physics: ScrollPhysics(),
                                                  itemBuilder: (context , i){
                                                    return getTalent(dataReTalents[i]);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      ExpansionTile(
                                        title: Text('เอกสาร',style: TextStyle(fontSize: 16),),
                                        children: [
                                        ],
                                      ),
                                    ],
                                  ),
                                  elevation: 3,
                                  shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: Colors.white)
                                  ),
                                )
                              ],
                            ),
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              title: Text('รายรับรายจ่ายคงที่'),
                              // subtitle: Text('Trailing expansion arrow icon'),
                              children: <Widget>[
                                dataIncomExpen.isEmpty
                                ?Card(
                                  child: Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(10),
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
                                :ListView.builder(
                                  itemCount: dataIncomExpen.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemBuilder: (context , i){
                                    return getIncomeExpend(dataIncomExpen[i]);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              title: Text('ข้อมูลโรงพยาบาลตามสิทธิ์'),
                              // subtitle: Text('Trailing expansion arrow icon'),
                              children: <Widget>[
                                dataHospital.isEmpty
                                ?Card(
                                  child: Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(10),
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
                                :Card(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${dataHospital[0]['name']}",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.left,
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
                              ],
                            ),
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              title: Text('ข้อมูลฝึกอบรม'),
                              // subtitle: Text('Trailing expansion arrow icon'),
                              children: <Widget>[
                                dataTraining.isEmpty
                                ?Card(
                                  child: Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(10),
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
                                :Card(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "วันที่ : ${dataTraining[0]['date']}",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                          "${dataTraining[0]['name']}",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                          "${dataTraining[0]['hour']}",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.left,
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
                              ],
                            ),
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              title: Text('ข้อมูลสินทรัพย์ถือครอง'),
                              // subtitle: Text('Trailing expansion arrow icon'),
                              children: <Widget>[
                                dataAssets.isEmpty
                                ?Card(
                                  child: Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(10),
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
                                :Card(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "วันที่ : ${dataAssets[0]['date']}",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                          "${dataAssets[0]['name']}",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                          "ราคา : ${dataAssets[0]['price']}",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.left,
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
                              ],
                            ),
                          ),
                          const SizedBox(height: 100)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

          ],
        )
            : const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
                strokeWidth: 5,)
          )
      ),
    );
  }

  Widget getText(item){
    var No = item['No'];
    var Fname = item['first_name'];
    var Lname = item['last_name'];
    var Nickname = item['nick_name'];
    return Text(
      "อนุมัติขั้น ${No} : ${Fname} ${Lname} (${Nickname})",
      style: TextStyle(
          fontSize: 16,
          color: Colors.black87
      ),
    );
  }

  Widget getTextKa(item){
    var Name = item['name'];
    return Container(
      padding: const EdgeInsets.only(top: 0.0,left: 40.0,right:40.0,bottom: 3.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${Name}",style: TextStyle(fontSize: 16,color: Colors.black87),)
        ],
      ),
    );
  }

  Widget getWorkHis(item){
    var dateS = item['date_start'];
    var dateE = item['date_end'];
    var company = item['company'];
    var remark = item['remark'];

    return Card(
      color: Colors.grey.shade200,
      child: Container(
        padding: const EdgeInsets.only(top: 5.0,left: 40.0,right:40.0,bottom: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("วันที่เริ่ม : ${dateS}",style: TextStyle(fontSize: 16,color: Colors.black87),),
            Text("วันที่สิ้นสุด : ${dateE}",style: TextStyle(fontSize: 16,color: Colors.black87),),
            Text("บริษัท : ${company}",style: TextStyle(fontSize: 16,color: Colors.black87),),
            Text("หมายเหตุ : ${remark}",style: TextStyle(fontSize: 16,color: Colors.black87),),
          ],
        ),
      ),
    );
  }

  Widget getEduHis(item){
    var eduyear = item['edu_year'];
    var edulevel = item['edu_level'];
    var eduadd = item['edu_address'];
    var major = item['major'];

    return Card(
      color: Colors.grey.shade200,
      child: Container(
        padding: const EdgeInsets.only(top: 5.0,left: 40.0,right:40.0,bottom: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("ปี : ${eduyear}",style: TextStyle(fontSize: 16,color: Colors.black87),),
            Text("ระดับการศึกษา : ${edulevel}",style: TextStyle(fontSize: 16,color: Colors.black87),),
            Text("${eduadd}",style: TextStyle(fontSize: 16,color: Colors.black87),),
            Text("สาขา : ${major}",style: TextStyle(fontSize: 16,color: Colors.black87),),
          ],
        ),
      ),
    );
  }

  Widget getTalent(item){
    var name = item['name'];
    return Card(
      color: Colors.grey.shade200,
      child: Container(
        padding: const EdgeInsets.only(top: 5.0,left: 40.0,right:40.0,bottom: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("${name}",style: TextStyle(fontSize: 16,color: Colors.black87),),
          ],
        ),
      ),
    );
  }

  Widget getIncomeExpend(item){
    var name = item['name'];
    var tyname = item['type_name'];
    var value = item['value'];
    return Card(
      child: Container(
        padding: const EdgeInsets.only(top: 5.0,left: 40.0,right:40.0,bottom: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("${tyname}",style: TextStyle(fontSize: 16,color: Colors.black87),),
            Text("${name}",style: TextStyle(fontSize: 16,color: Colors.black87),),
            Text("${value}",style: TextStyle(fontSize: 16,color: Colors.black87),),
          ],
        ),
      ),
    );
  }


}
