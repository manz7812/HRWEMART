import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:index/api/url.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuotaLaPage extends StatefulWidget {
  final String title;
  const QuotaLaPage({Key? key , required this.title}) : super(key: key);

  @override
  State<QuotaLaPage> createState() => _QuotaLaPageState();
}

class _QuotaLaPageState extends State<QuotaLaPage> {
  bool loading = false;
  String? selectedYearLa;
  List ListYearLa =[
    '2012', '2013', '2014', '2015',
    '2016', '2017', '2018', '2019',
    '2020', '2021', '2022', '2023',
  ];

  String? selectedListLa;
  List ListLa =[];
  String? token;

  Future<Null> getToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
    listLA();
  }
  Future<Null> listLA() async{
    String Url = pathurl.listLa;
    final response = await get(
        Uri.parse(Url),
        headers: {"Authorization": "Bearer $token"}
    );
    print(response.statusCode);
    var data = jsonDecode(response.body.toString());

    setState(() {
      ListLa=data["data"] ;
    });
  }

  @override
  void initState() {
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
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.deepPurpleAccent,
            //     spreadRadius: 5, blurRadius: 30,
            //     offset: Offset(5, 3),
            //   ),
            // ],
            // image: DecorationImage(image: NetworkImage('https://www.pngitem.com/pimgs/m/391-3918613_personal-service-platform-person-icon-circle-png-transparent.png'))
          ),
        ),
      ),
      body: loading ? SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 10,right: 10,top: 20,bottom: 10),
          child: Column(
            children: [
              // Card(
              //   child: Container(
              //     width: double.infinity,
              //     padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
              //     child: Column(
              //       children: [
              //         Container(
              //           alignment: Alignment.topLeft,
              //           child: const Text(
              //             "เลือกปี",
              //             style: TextStyle(
              //               color: Colors.black,
              //               fontWeight: FontWeight.w500,
              //               fontSize: 16,
              //             ),
              //             textAlign: TextAlign.left,
              //           ),
              //         ),
              //         DropdownButtonFormField<String>(
              //           icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
              //           value: selectedYearLa,
              //           onChanged: (value) {
              //             setState(() {
              //               selectedYearLa = value as String;
              //             });
              //           },
              //           validator: (value) => (selectedYearLa == '' || selectedYearLa == null)
              //               ? ''
              //               : null,
              //           // autovalidateMode: AutovalidateMode.onUserInteraction,
              //           decoration: InputDecoration(
              //             enabledBorder: OutlineInputBorder(
              //               borderSide: BorderSide(
              //                   color: selectedYearLa != null
              //                       ? Colors.green
              //                       : Colors.red, width: 2.0
              //               ),
              //             ),
              //             border: OutlineInputBorder(
              //               // borderSide: const BorderSide(color: Colors.green, width: 2.0),
              //             ),
              //             focusedBorder: OutlineInputBorder(
              //               borderSide: BorderSide(
              //                   color: selectedYearLa != null
              //                       ? Colors.green
              //                       : Colors.red, width: 2.0),
              //             ),
              //           ),
              //           items: ListYearLa.map((valueItem) {
              //             return DropdownMenuItem<String>(
              //                 value: valueItem,child: Text(valueItem)
              //             );
              //           }).toList(),
              //         ),
              //       ],
              //     ),
              //   ),
              //   elevation: 3,
              //   shape: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(5),
              //       borderSide: const BorderSide(color: Colors.white)
              //   ),
              // ),
              // const SizedBox(height: 20,),
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.topLeft,
                child: const Text(
                  "โควต้าของคุณ",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              ListLa == null
              ? Card(
                child: Container(
                  height: 150,
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
                itemCount: ListLa.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (context , i){
                  return getCard(ListLa[i]);
                },
              ),
              
            ],
          ),
        ),
      )
          : const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
              strokeWidth: 5,)
      )
    );
  }

  Widget getCard(item){
    var name = item['name'];
    var quota = item['quota']['total'];
    var Myquota = item['quota']['remain'];
    var total;
    if(quota == 0){
      total = 0.0;
    }else{
      total = Myquota/quota;
    }
    return Card(
      child: Container(
        padding: const EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 20),
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "$name",
                      style: TextStyle(
                        color: Colors.black87,
                        // fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "$Myquota/$quota วัน",
                    style: TextStyle(
                      color: Colors.black87,
                      // fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            LinearPercentIndicator(
              animation: true,
              animationDuration: 1500,
              lineHeight: 10,
              percent: total,
              progressColor: Colors.green,
              backgroundColor: quota == 0 && Myquota == 0 ? Colors.red : Colors.grey,
              linearStrokeCap: LinearStrokeCap.roundAll,
            ),
          ],
        ),
      ),
      elevation: 3,
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.white)
      ),
    );
  }
}
