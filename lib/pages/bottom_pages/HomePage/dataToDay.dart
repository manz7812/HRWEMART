import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DataToDayPage extends StatefulWidget {
  const DataToDayPage({Key? key}) : super(key: key);

  @override
  State<DataToDayPage> createState() => _DataToDayPageState();
}

class _DataToDayPageState extends State<DataToDayPage> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1),(){
      setState(() {
        loading = true;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    Intl.defaultLocale = 'th';
    var now = DateTime.now();
    // var toShow = now.yearInBuddhistCalendar;
    var dateth = DateFormat.yMMMMEEEEd().format(now);
    var formatter = DateFormat.yMMMMEEEEd();
    var datetimeTH = dateth.split('ค.ศ.');
    var DTN = datetimeTH[1].split(' ');

    var MY = DateFormat.MMMM().format(now);

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text("ข้อมูลประจำวัน"),
        centerTitle: true,
        elevation: 0,
        shadowColor: Colors.transparent,
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
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            children: [
              Card(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${datetimeTH[0]}${DTN[1]}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.deepPurpleAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const[
                          Text('วันทำงาน : ',
                            style:  TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text('08:00-12:00 - 13:00-17:00',
                            style:  TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children:  const[
                                Text("เวลาเข้างาน",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.deepPurpleAccent,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text('08:00',
                                  style:  TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const VerticalDivider(
                              width: 20,
                              thickness: 1,
                              color: Colors.grey,
                            ),
                            Column(
                              children: const [
                                Text("เวลาออกงาน",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.deepPurpleAccent,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text("17:00",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],),
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
              const SizedBox(height: 10),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      height: 50,
                      color: Colors.deepPurpleAccent.shade100,
                      child: Row(
                        children: [
                          Text('รายการยื่นเอกสาร',
                            style:  TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const Spacer(),
                          Text('${MY} ${DTN[1]}',
                            style:  TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 5,color: Colors.blue),
                                  shape: BoxShape.circle,
                                  //borderRadius: new BorderRadius.circular(30.0),
                                  // color: Colors.amber,
                                ),
                                child: const Center(
                                  child: Text('0',
                                    style:  TextStyle(
                                    fontSize: 50,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 8.0, bottom: 0.0),
                                // alignment: Alignment.topLeft,
                                child: const Text(
                                  "รออนุมัติ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 5,color: Colors.green),
                                    shape: BoxShape.circle,
                                    //borderRadius: new BorderRadius.circular(30.0),
                                    // color: Colors.amber,
                                  ),
                                  child: const Center(
                                    child: Text('0',
                                      style:  TextStyle(
                                        fontSize: 50,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 8.0, bottom: 0.0),
                                // alignment: Alignment.topLeft,
                                child: const Text(
                                  "อนุมัติแล้ว",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 5,color: Colors.red),
                                    shape: BoxShape.circle,
                                    //borderRadius: new BorderRadius.circular(30.0),
                                    // color: Colors.amber,
                                  ),
                                  child: const Center(
                                    child: Text('0',
                                      style:  TextStyle(
                                        fontSize: 50,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 8.0, bottom: 0.0),
                                // alignment: Alignment.topLeft,
                                child: const Text(
                                  "ไม่อนุมัติ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                elevation: 3,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.transparent)
                ),
              ),
              const SizedBox(height: 10),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      height: 50,
                      color: Colors.deepPurpleAccent.shade100,
                      child: Row(
                        children: [
                          Text('รายการเวลาการทำงาน',
                            style:  TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const Spacer(),
                          Text('${MY} ${DTN[1]}',
                            style:  TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Container(
                                  width: 150,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 5,color: Colors.blue),
                                    shape: BoxShape.rectangle,
                                    borderRadius: new BorderRadius.circular(10.0),
                                    // color: Colors.amber,
                                  ),
                                  child: const Center(
                                    child: Text('0 วัน\n11 นาที',
                                      textAlign: TextAlign.center,
                                      style:  TextStyle(
                                        fontSize: 30,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,

                                      ),
                                    ),
                                  )
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 8.0, bottom: 0.0),
                                // alignment: Alignment.topLeft,
                                child: const Text(
                                  "สาย",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                  width: 150,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 5,color: Colors.orange),
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10.0),
                                    // color: Colors.amber,
                                  ),
                                  child: const Center(
                                    child: Text('0 วัน\n0 นาที',
                                      textAlign: TextAlign.center,
                                      style:  TextStyle(
                                        fontSize: 30,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 8.0, bottom: 0.0),
                                // alignment: Alignment.topLeft,
                                child: const Text(
                                  "กลับก่อน",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                elevation: 3,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.transparent)
                ),
              ),
              const SizedBox(height: 10),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      color: Colors.deepPurpleAccent.shade100,
                      child: Row(
                        children: [
                          Text('รายการโอที',
                            style:  TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const Spacer(),
                          Text('${MY} ${DTN[1]}',
                            style:  TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 0.3),
                    Container(
                      width: double.infinity,
                      // alignment: Alignment.centerLeft,
                      child: DataTable(
                          showBottomBorder: true,
                          headingRowHeight: 30,
                          // dataRowColor: MaterialStateColor.resolveWith(
                          //     (states) => Colors.deepPurpleAccent.shade100),
                          columnSpacing: 20,
                          horizontalMargin: 10,
                          headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.deepPurpleAccent.shade100),
                          // dividerThickness: 5,
                          border: const TableBorder(
                              verticalInside:
                              BorderSide(width: 2, color: Colors.white70)),
                          columns:  [
                            DataColumn(
                              label: Expanded(
                                child: Container(
                                  width: 150,
                                  child: Text(
                                    'วันที่ขอ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87),
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                // flex: 11,
                                child: Text(
                                  'รวมเป็นเงิน',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87),
                                ),
                              ),
                            ),
                          ],
                          rows: [
                            DataRow(
                                color: MaterialStateColor.resolveWith(
                                        (states) => Colors.deepPurple.shade50),
                                cells: [
                                  DataCell(
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '13/03/2022',
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '250.00',
                                      ))),
                                ]),
                            DataRow(
                                cells: [
                                  DataCell(Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('10/03/2022'))),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '200.00',
                                      ))),
                                ]),
                            DataRow(
                                color: MaterialStateColor.resolveWith(
                                        (states) => Colors.deepPurple.shade50),
                                cells: [
                                  DataCell(
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '09/03/2022',
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '250.00',
                                      ))),
                                ]),
                            DataRow(
                                cells: [
                                  DataCell(Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('05/03/2022'))),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '250.00',
                                      ))),
                                ]),
                            DataRow(
                                color: MaterialStateColor.resolveWith(
                                        (states) => Colors.deepPurple.shade50),
                                cells: [
                                  DataCell(
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '02/03/2022',
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '300.00',
                                      ))),
                                ]),
                            DataRow(cells: [
                              DataCell(Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'รวมเป็นเงิน',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurpleAccent),
                                  ))),
                              DataCell(Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '1,250.00',
                                  ))),
                            ]),
                          ]),
                    ),
                  ],
                ),
                elevation: 3,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.transparent)
                ),
              ),
              const SizedBox(height: 10),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      height: 50,
                      color: Colors.deepPurpleAccent.shade100,
                      child: Row(
                        children: [
                          Text('รายลางาน',
                            style:  TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const Spacer(),
                          Text('${MY} ${DTN[1]}',
                            style:  TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 0.5),
                    Container(
                      width: double.infinity,
                      // alignment: Alignment.centerLeft,
                      child: DataTable(
                          showBottomBorder: true,
                          headingRowHeight: 30,
                          // dataRowColor: MaterialStateColor.resolveWith(
                          //     (states) => Colors.deepPurpleAccent.shade100),
                          columnSpacing: 35,
                          horizontalMargin: 10,
                          headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.deepPurpleAccent.shade100),
                          // dividerThickness: 5,
                          border: const TableBorder(
                              verticalInside:
                              BorderSide(width: 2, color: Colors.white70)),
                          columns: const [
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'วันที่ลา',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'ประเภทการลา',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'รวมเป็นเงิน',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87),
                                ),
                              ),
                            ),
                          ],
                          rows: [
                            DataRow(
                                color: MaterialStateColor.resolveWith(
                                        (states) => Colors.deepPurple.shade50),
                                cells: [
                                  DataCell(
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '21/03/2022',
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text('ลาป่วย'))),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '0.00',
                                      ))),
                                ]),
                            DataRow(
                                cells: [
                                  DataCell(Text('17/03/2022')),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text('ลาไม่รับเงินเดือน'))),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '350.00',
                                      ))),
                                ]),
                            DataRow(
                                color: MaterialStateColor.resolveWith(
                                        (states) => Colors.deepPurple.shade50),
                                cells: [
                                  DataCell(Text('04/03/2022')),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text('ลากิจ'))),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '0.00',
                                      ))),
                                ]),
                            DataRow(cells: [
                              DataCell(
                                  Text('28/02/2022')),
                              DataCell(Container(
                                  alignment: Alignment.centerRight,
                                  child: Text('ลาป่วย'))),
                              DataCell(Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '0.00',
                                  ))),
                            ]),
                            DataRow(
                                color: MaterialStateColor.resolveWith(
                                        (states) => Colors.deepPurple.shade50),
                                cells: [
                                  DataCell(Text('26/02/2022')),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text('ลาพักร้อน'))),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '0.00',
                                      ))),
                                ]),
                            DataRow(cells: [
                              DataCell(Text('')),
                              DataCell(Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'รวมเป็นเงิน',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurpleAccent),
                                  ))),
                              DataCell(Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '350.00',
                                  ))),
                            ]),
                          ]),
                    ),
                  ],
                ),
                elevation: 3,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.transparent)
                ),
              ),
            ],
          ),
        ),
      )
          : const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
              strokeWidth: 5,
            )
        ),
    );
  }
}
