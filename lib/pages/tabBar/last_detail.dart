import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LastDetailPage extends StatefulWidget {
  const LastDetailPage({Key? key}) : super(key: key);

  @override
  State<LastDetailPage> createState() => _LastDetailPageState();
}

class _LastDetailPageState extends State<LastDetailPage> {
  bool loading = false;

  var sa = 500;
  var ho = 400;
  var wo = 100;
  void _sum(){
    List<Map<String, dynamic>> products = [
      {
        "name": "sa",
        "price": sa
      },
      {
        "name": "wo",
        "price": ho
      },
      {
        "name": "ho",
        "price": wo
      }

    ];
    num total = products.fold(0, (result, item) => result+item["price"]);
  }

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
      body: loading ? SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
              top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
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
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 5.0, bottom: 0.0),
                    alignment: Alignment.topLeft,
                    child: const Text(
                      "ผลรวมเวลา",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    // alignment: Alignment.centerLeft,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: DataTable(
                          showBottomBorder: true,
                          // headingRowHeight: 20,
                          // dataRowColor: MaterialStateColor.resolveWith(
                          //     (states) => Colors.deepPurpleAccent.shade100),
                          columnSpacing: 35,
                          horizontalMargin: 10,
                          headingRowColor: MaterialStateColor.resolveWith(
                              (states) => Colors.deepPurpleAccent),
                          // dividerThickness: 5,
                          border: const TableBorder(
                              verticalInside:
                                  BorderSide(width: 2, color: Colors.white70)),
                          columns: const [
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'รายการ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'ผลรวมเวลา',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
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
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
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
                                    'เงินเดือน',
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              DataCell(Text('')),
                              DataCell(Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '12,000.00',
                                  ))),
                            ]),
                            DataRow(
                                cells: [
                              DataCell(Text('วันมาทำงาน')),
                              DataCell(Container(
                                  alignment: Alignment.centerRight,
                                  child: Text('26.00 วัน'))),
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
                              DataCell(
                                  Text('วันหยุดนักขตฤกษ์\nวันหยุดพนักงาน')),
                              DataCell(Container(
                                  alignment: Alignment.centerRight,
                                  child: Text('0/4 วัน'))),
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
                                    '12,000.00',
                                  ))),
                            ]),
                          ]),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Container(
                    padding: const EdgeInsets.only(left: 5.0, bottom: 0.0),
                    alignment: Alignment.topLeft,
                    child: const Text(
                      "รายรับ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    // alignment: Alignment.centerLeft,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: DataTable(
                          showBottomBorder: true,
                          // headingRowHeight: 20,
                          // dataRowColor: MaterialStateColor.resolveWith(
                          //     (states) => Colors.deepPurpleAccent.shade100),
                          columnSpacing: 20,
                          horizontalMargin: 10,
                          headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.deepPurpleAccent),
                          // dividerThickness: 5,
                          border: const TableBorder(
                              verticalInside:
                              BorderSide(width: 2, color: Colors.white70)),
                          columns:  [
                            DataColumn(
                              label: Expanded(
                                child: Container(
                                  width: 230,
                                  child: Text(
                                    'รายการ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                flex: 11,
                                child: Text(
                                  'รวมเป็นเงิน',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
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
                                        'ค่ากะ',
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '0.00',
                                      ))),
                                ]),
                            DataRow(
                                cells: [
                                  DataCell(Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('ค่าอาหาร'))),
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

                                  DataCell(Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('เบี้ยขยัน'))),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '400.00',
                                      ))),
                                ]),
                            DataRow(cells: [
                              DataCell(Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text('รายการทัวร์'))),
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
                                  DataCell(Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('ค่าน้ำมันรถ'))),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '0.00',
                                      ))),
                                ]),
                            DataRow(
                                cells: [
                                  DataCell(Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('ตกเบิก'))),
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
                                  DataCell(Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('ค่าโทรศัพท์'))),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '0.00',
                                      ))),
                                ]),
                            DataRow(
                                cells: [
                                  DataCell(Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('โบนัส'))),
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
                                  DataCell(Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('ค่าคอมมิชชั่น'))),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '0.00',
                                      ))),
                                ]),
                            DataRow(
                                cells: [
                                  DataCell(Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('ค่าประกอบวิชาชีพ'))),
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
                                  DataCell(Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('ค่าเงินประกัน'))),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '0.00',
                                      ))),
                                ]),
                            DataRow(
                                cells: [
                                  DataCell(Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('ค่าตำแหน่ง'))),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '1,000.00',
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
                                    '1,400.00',
                                  ))),
                            ]),

                          ]),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Container(
                    padding: const EdgeInsets.only(left: 5.0, bottom: 0.0),
                    alignment: Alignment.topLeft,
                    child: const Text(
                      "รายจ่าย",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    // alignment: Alignment.centerLeft,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: DataTable(
                          showBottomBorder: true,
                          // headingRowHeight: 20,
                          // dataRowColor: MaterialStateColor.resolveWith(
                          //     (states) => Colors.deepPurpleAccent.shade100),
                          columnSpacing: 20,
                          horizontalMargin: 10,
                          headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.deepPurpleAccent),
                          // dividerThickness: 5,
                          border: const TableBorder(
                              verticalInside:
                              BorderSide(width: 2, color: Colors.white70)),
                          columns:  [
                            DataColumn(
                              label: Expanded(
                                child: Container(
                                  width: 230,
                                  child: Text(
                                    'รายการ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                flex: 11,
                                child: Text(
                                  'รวมเป็นเงิน',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
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
                                        'ภาษี',
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '0.00',
                                      ))),
                                ]),
                            DataRow(
                                cells: [
                                  DataCell(Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('ประกันสังคม'))),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '600.00',
                                      ))),
                                ]),
                            DataRow(
                                color: MaterialStateColor.resolveWith(
                                        (states) => Colors.deepPurple.shade50),
                                cells: [

                                  DataCell(Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('กองทุนสำรองฯ'))),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '0.00',
                                      ))),
                                ]),
                            DataRow(cells: [
                              DataCell(Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text('เงินกู้ฉุกเฉิน'))),
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
                                  DataCell(Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('ค่าไฟฟ้า'))),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '0.00',
                                      ))),
                                ]),
                            DataRow(
                                cells: [
                                  DataCell(Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('ค่าประกันห้อง'))),
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
                                  DataCell(Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('ค่าน้ำประปา'))),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '0.00',
                                      ))),
                                ]),
                            DataRow(
                                cells: [
                                  DataCell(Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('ค่าเสื้อพนักงาน'))),
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
                                  DataCell(Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('ค่าประกันงาน'))),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '0.00',
                                      ))),
                                ]),
                            DataRow(
                                cells: [
                                  DataCell(Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('ค่าใช้จ่ายอื่นๆ'))),
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
                                  DataCell(Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('ค่าธรรมเนียม'))),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '5.00',
                                      ))),
                                ]),
                            DataRow(
                                cells: [
                                  DataCell(Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('ค่าบำรุงห้องพัก'))),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '0.00',
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
                                    '605.00',
                                  ))),
                            ]),

                          ]),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  // Container(
                  //   padding: const EdgeInsets.only(left: 5.0, bottom: 0.0),
                  //   alignment: Alignment.topLeft,
                  //   child: const Text(
                  //     "เบิกล่วงหน้า",
                  //     style: TextStyle(
                  //       color: Colors.black,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 16,
                  //     ),
                  //     textAlign: TextAlign.left,
                  //   ),
                  // ),
                  // Container(
                  //   width: double.infinity,
                  //   // alignment: Alignment.centerLeft,
                  //   child: Card(
                  //     clipBehavior: Clip.antiAlias,
                  //     child: DataTable(
                  //         showBottomBorder: true,
                  //         // headingRowHeight: 20,
                  //         // dataRowColor: MaterialStateColor.resolveWith(
                  //         //     (states) => Colors.deepPurpleAccent.shade100),
                  //         columnSpacing: 20,
                  //         horizontalMargin: 10,
                  //         headingRowColor: MaterialStateColor.resolveWith(
                  //                 (states) => Colors.deepPurpleAccent),
                  //         // dividerThickness: 5,
                  //         border: const TableBorder(
                  //             verticalInside:
                  //             BorderSide(width: 2, color: Colors.white70)),
                  //         columns:  [
                  //           DataColumn(
                  //             label: Expanded(
                  //               child: Container(
                  //                 width: 230,
                  //                 child: Text(
                  //                   'รายการ',
                  //                   textAlign: TextAlign.center,
                  //                   style: TextStyle(
                  //                       fontSize: 16,
                  //                       fontWeight: FontWeight.bold,
                  //                       color: Colors.white),
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //           DataColumn(
                  //             label: Expanded(
                  //               flex: 11,
                  //               child: Text(
                  //                 'รวมเป็นเงิน',
                  //                 textAlign: TextAlign.center,
                  //                 style: TextStyle(
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.bold,
                  //                     color: Colors.white),
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //         rows: [
                  //           DataRow(
                  //               color: MaterialStateColor.resolveWith(
                  //                       (states) => Colors.deepPurple.shade50),
                  //               cells: [
                  //                 DataCell(
                  //                   Container(
                  //                     alignment: Alignment.centerLeft,
                  //                     child: Text(
                  //                       '',
                  //                       textAlign: TextAlign.left,
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 DataCell(Container(
                  //                     alignment: Alignment.centerRight,
                  //                     child: Text(
                  //                       '',
                  //                     ))),
                  //               ]),
                  //           DataRow(
                  //               cells: [
                  //                 DataCell(Container(
                  //                     alignment: Alignment.centerLeft,
                  //                     child: Text(''))),
                  //                 DataCell(Container(
                  //                     alignment: Alignment.centerRight,
                  //                     child: Text(
                  //                       '',
                  //                     ))),
                  //               ]),
                  //         ]),
                  //   ),
                  // ),
                  // const SizedBox(height: 30,),
                  Container(
                    padding: const EdgeInsets.only(left: 5.0, bottom: 0.0),
                    alignment: Alignment.topLeft,
                    child: const Text(
                      "ผลการคำนวณสุทธิ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    // alignment: Alignment.centerLeft,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: DataTable(
                          showBottomBorder: true,
                          // headingRowHeight: 20,
                          // dataRowColor: MaterialStateColor.resolveWith(
                          //     (states) => Colors.deepPurpleAccent.shade100),
                          columnSpacing: 20,
                          horizontalMargin: 10,
                          headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.deepPurpleAccent),
                          // dividerThickness: 5,
                          border: const TableBorder(
                              verticalInside:
                              BorderSide(width: 2, color: Colors.white70)),
                          columns:  [
                            DataColumn(
                              label: Expanded(
                                child: Container(
                                  width: 230,
                                  child: Text(
                                    'รายการ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
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
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
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
                                        'เงินเดือนที่ได้รับ',
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '12,000.00',
                                      ))),
                                ]),
                            DataRow(
                                cells: [
                                  DataCell(Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('ทำล่วงเวลา'))),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '1,250.00',
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
                                        'รวมรายรับ',
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '1,400.00',
                                      ))),
                                ]),
                            DataRow(
                                cells: [
                                  DataCell(Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text('รวมลางาน'))),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '400.00',
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
                                        'รวมเวลาผิดปกติ\n(สาย/ออกก่อน/ขาดงาน)',
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '11.00',
                                      ))),
                                ]),
                            DataRow(
                                cells: [
                                  DataCell(
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'รวมรายจ่าย',
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  DataCell(Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '605.00',
                                      ))),
                                ]),
                            DataRow(
                                color: MaterialStateColor.resolveWith(
                                        (states) => Colors.deepPurple.shade50),
                                cells: [
                              DataCell(Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'คงเหลือ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurpleAccent),
                                  ))),
                              DataCell(Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '1,634.00',
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
                                    '13,634.00',
                                  ))),
                            ]),
                          ]),
                    ),
                  ),
                ],
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
}
