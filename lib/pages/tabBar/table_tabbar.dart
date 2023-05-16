import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:index/pages/bottom_pages/DateTimePage/table_time_work_values.dart';
import 'package:index/pages/widjet/myAlertLocation.dart';

class TableTabbarPage extends StatefulWidget {
  const TableTabbarPage({Key? key}) : super(key: key);

  @override
  State<TableTabbarPage> createState() => _TableTabbarPageState();
}

class _TableTabbarPageState extends State<TableTabbarPage> {

  String? selectedYear;
  List ListYear = [
    '2012',
    '2013',
    '2014',
    '2015',
    '2016',
    '2017',
    '2018',
    '2019',
    '2020',
    '2021',
    '2022',
    '2023',
  ];

  String? selectedMonth;
  List ListMonth = [
    'ทั้งหมด',
    'มกราคม',
    'กุมภาพันธ์',
    'มีนาคม',
    'เมษายน',
    'พฤษภาคม',
    'มิถุนายน',
    'กรกฎาคม',
    'สิงหาคม',
    'กันยายน',
    'ตุลาคม',
    'พฤศจิกายน',
    'ธันวาคม',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
              top: 30.0, left: 10.0, right: 10.0, bottom: 10.0),
          child: Column(
            children: [
              Card(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 0.0, bottom: 4.0),
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
                              padding:
                                  const EdgeInsets.only(right: 16, left: 16),
                              // margin: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade500),
                                  borderRadius: BorderRadius.circular(5)),
                              child: DropdownButton(
                                isExpanded: true,
                                underline: SizedBox(),
                                hint: Container(
                                    // padding: const EdgeInsets.only(right: 5, left: 8),
                                    alignment: AlignmentDirectional.centerStart,
                                    // width: 180,
                                    child: Text(
                                      ListYear.last,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    )),
                                icon: Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: Colors.grey.shade700,
                                ),
                                value: selectedYear,
                                onChanged: (value) {
                                  setState(() {
                                    selectedYear = value as String;
                                  });
                                },
                                items: ListYear.map((valueItem) {
                                  return DropdownMenuItem(
                                      value: valueItem, child: Text(valueItem));
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 0.0, bottom: 4.0),
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
                              padding:
                                  const EdgeInsets.only(right: 16, left: 16),
                              // margin: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade500),
                                  borderRadius: BorderRadius.circular(5)),
                              child: DropdownButton(
                                isExpanded: true,
                                underline: SizedBox(),
                                hint: Container(
                                    // padding: const EdgeInsets.only(right: 5, left: 8),
                                    alignment: AlignmentDirectional.centerStart,
                                    // width: 180,
                                    child: Text(
                                      ListMonth.first,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    )),
                                icon: Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: Colors.grey.shade700,
                                ),
                                value: selectedMonth,
                                onChanged: (value) {
                                  setState(() {
                                    selectedMonth = value as String;
                                  });
                                },
                                items: ListMonth.map((valueItem) {
                                  return DropdownMenuItem(
                                      value: valueItem, child: Text(valueItem));
                                }).toList(),
                              ),
                            ),
                            // const SizedBox(width: 30,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(
                    top: 0.0, left: 10.0, right: 10.0, bottom: 10.0),
                child: Row(
                  children: [
                    Text(
                      "รายการ",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        onPressed: (){
                          MyDialog().alertlistmenu(context);
                      },
                        icon: Icon(Icons.help_outline_outlined))
                  ],
                ),
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              GestureDetector(
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (BuildContext context) {
                  //   return TableTimeWorkValuesPage();
                  // }));
                },
                child: Card(
                  color: Colors.yellow.shade100,
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.arrow_forward,
                          size: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    "สถานะ : ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    "วันทำงาน",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Text(
                                    "วันที่ : ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    "wed 26/01/2022",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Text(
                                    "กะ : ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    "WC0001 08:00 - 17:00",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Text(
                                    "เวลาทำงาน : ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    "08:00 - 17:00",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Center(
                                child: Text(
                                  "ไม่พบข้อมูล",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              )

                              // Text("กะ : WC0001 08:00 - 17:00",style: TextStyle(fontSize: 16,color: Colors.black),),
                              // Text("เวลา : ",style: TextStyle(fontSize: 16,color: Colors.black),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  elevation: 3,
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.transparent)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
