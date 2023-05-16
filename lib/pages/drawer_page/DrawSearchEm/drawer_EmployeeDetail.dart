import 'package:flutter/material.dart';
import 'package:geira_icons/geira_icons.dart';

class SearchDetailEmployee extends StatefulWidget {
  const SearchDetailEmployee({Key? key}) : super(key: key);

  @override
  State<SearchDetailEmployee> createState() => _SearchDetailEmployeeState();
}

class _SearchDetailEmployeeState extends State<SearchDetailEmployee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text('รายละเอียดพนักงาน'),
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 5.0,left: 5.0,right: 5.0,bottom: 5.0),
          child: Column(
            children: [
              Card(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // height: 150,
                          // width: double.infinity,
                          // alignment: Alignment.center,
                          padding: const EdgeInsets.only(top: 20.0,left: 10.0,right: 10.0,bottom: 10.0),
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
                        //
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
                          Text("รหัสพนักงาน : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                          Text("F92042001",style: TextStyle(fontSize: 16,color: Colors.black87),),
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
                          Text("ชาย",style: TextStyle(fontSize: 16,color: Colors.black87),),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                      child: Row(
                        children: [
                          Text("สัญชาติ : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                          Text("ไทย",style: TextStyle(fontSize: 16,color: Colors.black87),),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                      child: Row(
                        children: [
                          Text("สถานะ : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                          Text("โสด",style: TextStyle(fontSize: 16,color: Colors.black87),),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                      child: Row(
                        children: [
                          Text("เลขประจำตัวประชาชน : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                          Text("1809700307442",style: TextStyle(fontSize: 16,color: Colors.black87),),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                      child: Row(
                        children: [
                          Text("เลขประกันสังคม : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                          Text("F92042001",style: TextStyle(fontSize: 16,color: Colors.black87),),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                      child: Row(
                        children: [
                          Text("วันเกิด : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                          Text("15/02/2022",style: TextStyle(fontSize: 16,color: Colors.black87),),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                      child: Row(
                        children: [
                          Text("บริษัท : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                          Text("",style: TextStyle(fontSize: 16,color: Colors.black87),),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                      child: Row(
                        children: [
                          Text("สำนักงานสาขา : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                          Text("",style: TextStyle(fontSize: 16,color: Colors.black87),),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                      child: Row(
                        children: [
                          Text("แผนก : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                          Text("",style: TextStyle(fontSize: 16,color: Colors.black87),),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                      child: Row(
                        children: [
                          Text("ตำแหน่ง : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                          Text("",style: TextStyle(fontSize: 16,color: Colors.black87),),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                      child: Row(
                        children: [
                          Text("ประเภทพนักงาน : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                          Text("",style: TextStyle(fontSize: 16,color: Colors.black87),),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                      child: Row(
                        children: [
                          Text("เงินเดือน : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                          Text("",style: TextStyle(fontSize: 16,color: Colors.black87),),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                      child: Row(
                        children: [
                          Text("วงเงินเบิกล่วงหน้า : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                          Text("",style: TextStyle(fontSize: 16,color: Colors.black87),),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                      child: Row(
                        children: [
                          Text("วันที่เริ่มงาน : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                          Text("",style: TextStyle(fontSize: 16,color: Colors.black87),),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                      child: Row(
                        children: [
                          Text("วันที่บรรจุ : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                          Text("",style: TextStyle(fontSize: 16,color: Colors.black87),),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                      child: Row(
                        children: [
                          Text("ภาษี : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                          Text("",style: TextStyle(fontSize: 16,color: Colors.black87),),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                      child: Row(
                        children: [
                          Text("ช่องทางการชำระเงิน : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                          Text("",style: TextStyle(fontSize: 16,color: Colors.black87),),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 0.0),
                      child: Row(
                        children: [
                          Text("ธนาคาร : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                          Text("",style: TextStyle(fontSize: 16,color: Colors.black87),),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 0.0,left: 10.0,right: 10.0,bottom: 10.0),
                      child: Row(
                        children: [
                          Text("เลขบัญชี : ",style: TextStyle(fontSize: 16,color: Colors.black87),),
                          Text("",style: TextStyle(fontSize: 16,color: Colors.black87),),
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
      ),
    );
  }
}
