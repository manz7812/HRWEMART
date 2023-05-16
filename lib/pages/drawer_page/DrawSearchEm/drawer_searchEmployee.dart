import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

import 'drawer_EmployeeDetail.dart';
import 'drawer_scoreEmployee.dart';


class SearchEmployeePage extends StatefulWidget {
  final String title;
  const SearchEmployeePage({Key? key, required this.title}) : super(key: key);

  @override
  State<SearchEmployeePage> createState() => _SearchEmployeePageState();
}

class _SearchEmployeePageState extends State<SearchEmployeePage> {

  bool loading = false;

  String? selectedCompany;
  List ListCompany =[
    'กรุณาเลือก',
    'บริษัท วีมาร์ท จำกัด (สำนักงานใหญ่)'
  ];


  String? selectedDep;
  List ListDep =[
    'บุคคล', 'ขาย', 'IT',
    'การตลาด', 'บัญชี', 'วีมาร์ท',
  ];

  @override
  void initState() {
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
      // appBar: AppBar(
      //   title: Text(widget.title),
      //   centerTitle: true,
      //   flexibleSpace : Container(
      //     decoration: const BoxDecoration(
      //       borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
      //       // border: Border.all(width: 15, color: Colors.white),
      //       gradient:  LinearGradient(
      //         colors: [
      //           Color(0xff6200EA),
      //           Colors.white,
      //         ],
      //         begin:  FractionalOffset(0.0, 1.0),
      //         end:  FractionalOffset(1.5, 1.5),
      //       ),
      //       // boxShadow: [
      //       //   BoxShadow(
      //       //     color: Colors.deepPurpleAccent,
      //       //     spreadRadius: 5, blurRadius: 30,
      //       //     offset: Offset(5, 3),
      //       //   ),
      //       // ],
      //       // image: DecorationImage(image: NetworkImage('https://www.pngitem.com/pimgs/m/391-3918613_personal-service-platform-person-icon-circle-png-transparent.png'))
      //     ),
      //   ),
      // ),
      body: loading ? SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 10,right: 10,top: 20,bottom: 10),
          child: Column(
            children: [
              Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          hintText: "ค้นหา",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade700)
                          ),
                        ),
                      ),

                      Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          title: Text('ค้นหาแบบละเอียด'),
                          // subtitle: Text('Trailing expansion arrow icon'),
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(top: 0,left: 15,right: 15,bottom: 0),
                              child: Column(
                                children: [
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
                                      hint: Container(
                                        // padding: const EdgeInsets.only(right: 5, left: 8),
                                          alignment: AlignmentDirectional.centerStart,
                                          // width: 180,
                                          child: Text(
                                            ListCompany.first,
                                            style: const TextStyle(
                                              color: Colors.black,fontSize: 16,
                                            ),
                                          )
                                      ),
                                      icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                                      value: selectedCompany,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedCompany = value as String;
                                        });
                                      },
                                      items: ListCompany.map((valueItem) {
                                        return DropdownMenuItem(
                                            value: valueItem,child: Text(valueItem)
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  const SizedBox(height: 15,),
                                  Container(
                                    padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                                    alignment: Alignment.topLeft,
                                    child: const Text(
                                      "ประเภทเอกสาร",
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
                                      hint: Container(
                                        // padding: const EdgeInsets.only(right: 5, left: 8),
                                          alignment: AlignmentDirectional.centerStart,
                                          // width: 180,
                                          child: Text(
                                            ListDep.first,
                                            style: const TextStyle(
                                              color: Colors.black,fontSize: 16,
                                            ),
                                          )
                                      ),
                                      icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                                      value: selectedDep,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedDep = value as String;
                                        });
                                      },
                                      items: ListDep.map((valueItem) {
                                        return DropdownMenuItem(
                                            value: valueItem,child: Text(valueItem)
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  const SizedBox(height: 20,),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      Expanded(
                        flex: 0,
                        child: Container(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: ()  {

                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                              ),
                              child: Text('ค้นหา',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Sarabun",
                                ),)
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                elevation: 3,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.white)
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Stack(
                  children: [
                    Positioned(
                        // top: -5,left: 320,width: 25,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: (){
                              Navigator.of(context).push(
                                  PageTransition(
                                    child: EditScoreEmployeePage(),
                                    type: PageTransitionType.fade,
                                    alignment: Alignment.bottomCenter,
                                    duration: Duration(milliseconds: 600),
                                    reverseDuration: Duration(milliseconds: 600),
                                  )
                              );
                            },
                            icon: Icon(Icons.edit,color: Colors.orange,size: 30,),
                          ),
                        )
                    ),
                    Container(
                      width: double.infinity,
                      // height: 150,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 0),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.grey.shade400,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:  [
                                  const Text("ธีรภัทร์ เจริญวงค์ (แมน)",
                                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.deepPurpleAccent),),
                                  Row(
                                    children: const[
                                      Text("ตำแน่ง : ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black),),
                                      Text("Programmer",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.black),),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Text("อีเมล : ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.black),)),
                                      Expanded(
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            child: Text("Theeraphad2541@gmail.com",
                                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.black),),
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: const[
                                      Text("เบอร์โทรศัพท์ : ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.black),),
                                      Text("0869497812",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.black),),
                                    ],
                                  ),
                                  Row(
                                    children: const[
                                      Text("คะแนน : ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.black),),
                                      Text("100",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.black),),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
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
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          child: TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors.amber,
                                                primary: Colors.white,
                                                // minimumSize: Size(width, 100),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                    side: BorderSide(color: Colors.transparent)
                                                ),
                                              ),
                                              onPressed: () async{
                                                final mailtoUri = Uri(
                                                    scheme: 'mailto',
                                                    path: 'theeraphad2541@gmail.com',
                                                    queryParameters: {'subject': 'Example'}
                                                );
                                                await launchUrl(mailtoUri);
                                              },
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.email_outlined),
                                                  // const SizedBox(width: 10),
                                                  // Text('อีเมล'),
                                                ],
                                              )),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
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
                                                backgroundColor: Colors.green,
                                                primary: Colors.white,
                                                // minimumSize: Size(width, 100),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                    side: BorderSide(color: Colors.transparent)
                                                ),
                                              ),
                                              onPressed: () async {
                                                final Uri launchUri = Uri(
                                                  scheme: 'tel',
                                                  path: "0869497812",
                                                );
                                                await launchUrl(launchUri);
                                              },
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.call),
                                                  // const SizedBox(width: 10),
                                                  // Text('โทร'),
                                                ],
                                              )),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
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
                                                backgroundColor: Colors.blue,
                                                primary: Colors.white,
                                                // minimumSize: Size(width, 100),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                    side: BorderSide(color: Colors.transparent)
                                                ),
                                              ),
                                              onPressed: (){
                                                Navigator.push(context, MaterialPageRoute(
                                                    builder: (BuildContext context){
                                                      return SearchDetailEmployee();
                                                    })
                                                );
                                              },
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.list_alt),
                                                  // const SizedBox(width: 10),
                                                  // Text('รายละเอียด'),
                                                ],
                                              )),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
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
              )
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
}
