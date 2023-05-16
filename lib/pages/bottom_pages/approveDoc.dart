import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ionicons/ionicons.dart';

import '../drawer_page/dropdownSelect.dart';
import 'DocApprove/Doc_Approve_detail.dart';


class FavouritPage extends StatefulWidget {
  const FavouritPage({Key? key}) : super(key: key);

  @override
  _FavouritPageState createState() => _FavouritPageState();
}

class _FavouritPageState extends State<FavouritPage> {

  bool loading = false;

  String? selectedValue;
  List<String> items = [
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


  String? selectedYear;
  List ListYear = [
    '2012','2013',
    '2014', '2015',
    '2016', '2017',
    '2018', '2019',
    '2020', '2021',
    '2022', '2023',
  ];

  String? selectedMonth;
  List ListMonth =[
    'ทั้งหมด',
    'มกราคม', 'กุมภาพันธ์', 'มีนาคม',
    'เมษายน', 'พฤษภาคม', 'มิถุนายน',
    'กรกฎาคม', 'สิงหาคม', 'กันยายน',
    'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม',
  ];

  String? selectedStatus;
  List ListStatus =[
    'ทั้งหมด',
    'รออนุมัติ', 'อนุมัติ', 'ไม่อนุมัติ',
  ];


  String? selectedDoc;
  List ListDoc =[
    'ทั้งหมด', 'ขอโอที', 'ขอลางาน',
    'ขอเพิ่มเวลา', 'ขอเปลี่ยนวันหยุด', 'ขอเปลี่ยนกะการทำงาน',
  ];

  String? selectedEmployeename;
  List ListEmployeename =[
    'ทั้งหมด', 'กรรณิการ์ แก้วอุดม ()', 'ธีรภัทร์ เจริญวงค์ (แมน)',
    // 'ขอเพิ่มเวลา', 'ขอเปลี่ยนวันหยุด', 'ขอเปลี่ยนกะการทำงาน',
  ];

  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items) {
    List<DropdownMenuItem<String>> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(),
            ),
        ],
      );
    }
    return _menuItems;
  }

  List<int> _getDividersIndexes() {
    List<int> _dividersIndexes = [];
    for (var i = 0; i < (items.length * 2) - 1; i++) {
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        _dividersIndexes.add(i);
      }
    }
    return _dividersIndexes;
  }

  @override
  void initState(){
    Future.delayed(const Duration(seconds: 1),(){
      setState(() {
        loading = true;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text("อนุมัติเอกสาร"),
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
      body: loading ? Container(
        padding: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 0),
        child: Column(
          children: <Widget>[
            Card(
              child: Container(
                // height: 200,
                // alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      children: <Widget>[
                        // const SizedBox(width: 3),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
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
                                        ListYear.first,
                                        style: const TextStyle(
                                          color: Colors.black,fontSize: 16,
                                        ),
                                      )
                                  ),
                                  icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                                  value: selectedYear,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedYear = value as String;
                                    });
                                  },
                                  items: ListYear.map((valueItem) {
                                    return DropdownMenuItem(
                                        value: valueItem,child: Text(valueItem)
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // const Spacer(),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
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
                                        ListMonth.first,
                                        style: const TextStyle(
                                          color: Colors.black,fontSize: 16,
                                        ),
                                      )
                                  ),
                                  icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                                  value: selectedMonth,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedMonth = value as String;
                                    });
                                  },
                                  items: ListMonth.map((valueItem) {
                                    return DropdownMenuItem(
                                        value: valueItem,child: Text(valueItem)
                                    );
                                  }).toList(),
                                ),
                              ),
                              // const SizedBox(width: 30,),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Theme(
                          data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              splashColor: Colors.white,
                              colorScheme:  const ColorScheme.light(
                                primary: Colors.black,
                                // background: Colors.red
                                // onSurface: Colors.transparent,
                              )

                          ),
                          child: ExpansionTile(
                            title: const Text('ค้นหาแบบละเอียด',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
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
                                              ListStatus.first,
                                              style: const TextStyle(
                                                color: Colors.black,fontSize: 16,
                                              ),
                                            )
                                        ),
                                        icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                                        value: selectedStatus,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedStatus = value as String;
                                          });
                                        },
                                        items: ListStatus.map((valueItem) {
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
                                              ListDoc.first,
                                              style: const TextStyle(
                                                color: Colors.black,fontSize: 16,
                                              ),
                                            )
                                        ),
                                        icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                                        value: selectedDoc,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedDoc = value as String;
                                          });
                                        },
                                        items: ListDoc.map((valueItem) {
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
                                        "ชื่อพนักงาน",
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
                                              ListEmployeename.first,
                                              style: const TextStyle(
                                                color: Colors.black,fontSize: 16,
                                              ),
                                            )
                                        ),
                                        icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                                        value: selectedEmployeename,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedEmployeename = value as String;
                                          });
                                        },
                                        items: ListEmployeename.map((valueItem) {
                                          return DropdownMenuItem(
                                              value: valueItem,child: Text(valueItem)
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              )

                            ],
                          ),
                        ),
                        // const SizedBox(width: 30,),
                      ],
                    ),
                    // const SizedBox(height: 10,),
                  ],
                ),
              ),
              elevation: 3,
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.white)
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              alignment: Alignment.topLeft,
              child: const Text(
                "รายการ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: <Widget>[
                            Card(
                              child: Container(
                                height: 150,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(15),
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
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: <Widget>[
                            Card(
                              child: Column(
                                children: <Widget> [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: <Widget> [
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: const Text(
                                                "ภายในบริษัท",
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              alignment: AlignmentDirectional.centerEnd,
                                              child: const Text(
                                                "รออนุมัติ",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ],
                                        ),

                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: const Text(
                                            "กรรณิการ์ แก้วอุดม () ยื่นขอ ''เปลี่ยนกะการทำงาน'' ",
                                            style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),

                                        Container(
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.only(top: 15),
                                          child: const Text(
                                            "ขอวันที่ 30/03/2022 เปลี่ยนเป็น WC0002:06:30-10:30 - 11:30-15:30",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),

                                        Container(
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.only(top: 15,bottom: 15),
                                          child: const Text(
                                            "หมายเหตุ : งานด่วนช่วงเช้า",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),


                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    indent: 10,
                                    endIndent: 10,
                                    height: 0,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(height: 15,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                           primary: Colors.green,
                                           elevation: 3,
                                           shape: CircleBorder(),
                                        ),
                                        onPressed: (){},
                                        child: const Icon(
                                          Icons.check_circle,
                                          size: 50,
                                          color: Colors.white,
                                        )
                                      ),
                                      // IconButton(
                                      //   icon: const Icon(
                                      //     Icons.check_circle,
                                      //   ),
                                      //   iconSize: 50,
                                      //   color: Colors.green,
                                      //   hoverColor: Colors.transparent,
                                      //   highlightColor: Colors.transparent,
                                      //   splashColor: Colors.transparent,
                                      //   onPressed: (){},
                                      // ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.red,
                                              elevation: 3,
                                              shape: CircleBorder()
                                          ),
                                          onPressed: (){},
                                          child: const Icon(
                                            Icons.cancel,
                                            size: 50,
                                            color: Colors.white,
                                          )
                                      ),
                                      // IconButton(
                                      //   icon: const Icon(
                                      //     Icons.cancel,
                                      //   ),
                                      //   iconSize: 50,
                                      //   color: Colors.red,
                                      //   hoverColor: Colors.transparent,
                                      //   highlightColor: Colors.transparent,
                                      //   splashColor: Colors.transparent,
                                      //   onPressed: () {
                                      //     AwesomeDialog(
                                      //       context: context,
                                      //       // dismissOnTouchOutside: false,
                                      //       // padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
                                      //       dialogType: DialogType.NO_HEADER,
                                      //       body: Container(
                                      //         padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                                      //         child: Column(
                                      //           mainAxisAlignment: MainAxisAlignment.start,
                                      //           crossAxisAlignment: CrossAxisAlignment.start,
                                      //           children: [
                                      //             Container(
                                      //               padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      //               alignment: Alignment.topLeft,
                                      //               child: Column(
                                      //                 crossAxisAlignment: CrossAxisAlignment.start,
                                      //                 children: [
                                      //                   const Text(
                                      //                     "หมายเหตุ:",
                                      //                     style: TextStyle(
                                      //                       color: Colors.black,
                                      //                       fontWeight: FontWeight.w700,
                                      //                       fontSize: 16,
                                      //                     ),
                                      //                     textAlign: TextAlign.left,
                                      //                   ),
                                      //                   TextFormField(),
                                      //                   const SizedBox(height: 5),
                                      //                   Row(
                                      //                     children: [
                                      //                       Expanded(
                                      //                         child: Container(
                                      //                           width: double.infinity,
                                      //                           // padding: const EdgeInsets.only(right: 16, left: 16),
                                      //                           // margin: EdgeInsets.all(10),
                                      //                           // alignment: Alignment.center,
                                      //                           decoration: BoxDecoration(
                                      //                             // border: Border.all(
                                      //                             //     color: Colors.grey.shade500
                                      //                             // ),
                                      //                               borderRadius: BorderRadius.circular(5)
                                      //                           ),
                                      //                           child: TextButton(
                                      //                               style: TextButton.styleFrom(
                                      //                                 backgroundColor: Colors.transparent,
                                      //                                 primary: Colors.black87,
                                      //                                 // minimumSize: Size(width, 100),
                                      //                               ),
                                      //                               onPressed: (){
                                      //                                 Navigator.of(context).pop();
                                      //                               },
                                      //                               child: Text('ยกเลิก')),
                                      //                         ),
                                      //                       ),
                                      //
                                      //                       Expanded(
                                      //                         child: Container(
                                      //                           width: double.infinity,
                                      //                           // padding: const EdgeInsets.only(right: 16, left: 16),
                                      //                           // margin: EdgeInsets.all(10),
                                      //                           // alignment: Alignment.center,
                                      //                           decoration: BoxDecoration(
                                      //                             // border: Border.all(
                                      //                             //     color: Colors.grey.shade500
                                      //                             // ),
                                      //                               borderRadius: BorderRadius.circular(5)
                                      //                           ),
                                      //                           child: TextButton(
                                      //                               style: TextButton.styleFrom(
                                      //                                 backgroundColor: Colors.transparent,
                                      //                                 primary: Colors.green,
                                      //                                 // minimumSize: Size(width, 100),
                                      //                               ),
                                      //                               onPressed: (){},
                                      //                               child: Text('ตกลง')),
                                      //                         ),
                                      //                       ),
                                      //                     ],
                                      //                   )
                                      //                 ],
                                      //               ),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ),
                                      //       // keyboardAware: false,
                                      //       // dialogBackgroundColor: Colors.orange,
                                      //       // borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
                                      //       width: 400,
                                      //       buttonsBorderRadius: BorderRadius.all(Radius.circular(0)),
                                      //       headerAnimationLoop: false,
                                      //       animType: AnimType.SCALE,
                                      //       // autoHide: Duration(seconds: 2),
                                      //       // dialogBackgroundColor: Colors.deepPurpleAccent,
                                      //       // title: 'คุณอยู่นอกรัศมีที่กำหนด',
                                      //       // desc: 'กรุณาอยู่ในพื้นที่ บริษัท วิรัชทุ่งสงค้าข้าว จำกัด',
                                      //     ).show();
                                      //   },
                                      // ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.orange,
                                              elevation: 3,
                                              shape: CircleBorder()
                                          ),
                                          onPressed: (){},
                                          child: const Icon(
                                            Ionicons.reload_circle,
                                            size: 50,
                                            color: Colors.white,
                                          )
                                      ),
                                      // IconButton(
                                      //   icon:
                                      //   // const FaIcon(
                                      //   //     FontAwesomeIcons.react
                                      //   // ),
                                      //   const Icon(
                                      //     Ionicons.reload_circle,
                                      //   ),
                                      //   iconSize: 50,
                                      //   color: Colors.orange,
                                      //   hoverColor: Colors.transparent,
                                      //   highlightColor: Colors.transparent,
                                      //   splashColor: Colors.transparent,
                                      //   onPressed: () {
                                      //     AwesomeDialog(
                                      //       context: context,
                                      //       // dismissOnTouchOutside: false,
                                      //       // padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
                                      //       dialogType: DialogType.NO_HEADER,
                                      //       body: Container(
                                      //         padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                                      //         child: Column(
                                      //           mainAxisAlignment: MainAxisAlignment.start,
                                      //           crossAxisAlignment: CrossAxisAlignment.start,
                                      //           children: [
                                      //             Container(
                                      //               padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      //               alignment: Alignment.topLeft,
                                      //               child: Column(
                                      //                 crossAxisAlignment: CrossAxisAlignment.start,
                                      //                 children: [
                                      //                   const Text(
                                      //                     "หมายเหตุ:",
                                      //                     style: TextStyle(
                                      //                       color: Colors.black,
                                      //                       fontWeight: FontWeight.w700,
                                      //                       fontSize: 16,
                                      //                     ),
                                      //                     textAlign: TextAlign.left,
                                      //                   ),
                                      //                   TextFormField(),
                                      //                   const SizedBox(height: 5),
                                      //                   Row(
                                      //                     children: [
                                      //                       Expanded(
                                      //                         child: Container(
                                      //                           width: double.infinity,
                                      //                           // padding: const EdgeInsets.only(right: 16, left: 16),
                                      //                           // margin: EdgeInsets.all(10),
                                      //                           // alignment: Alignment.center,
                                      //                           decoration: BoxDecoration(
                                      //                             // border: Border.all(
                                      //                             //     color: Colors.grey.shade500
                                      //                             // ),
                                      //                               borderRadius: BorderRadius.circular(5)
                                      //                           ),
                                      //                           child: TextButton(
                                      //                               style: TextButton.styleFrom(
                                      //                                 backgroundColor: Colors.transparent,
                                      //                                 primary: Colors.black87,
                                      //                                 // minimumSize: Size(width, 100),
                                      //                               ),
                                      //                               onPressed: (){
                                      //                                 Navigator.of(context).pop();
                                      //                               },
                                      //                               child: Text('ยกเลิก')),
                                      //                         ),
                                      //                       ),
                                      //
                                      //                       Expanded(
                                      //                         child: Container(
                                      //                           width: double.infinity,
                                      //                           // padding: const EdgeInsets.only(right: 16, left: 16),
                                      //                           // margin: EdgeInsets.all(10),
                                      //                           // alignment: Alignment.center,
                                      //                           decoration: BoxDecoration(
                                      //                             // border: Border.all(
                                      //                             //     color: Colors.grey.shade500
                                      //                             // ),
                                      //                               borderRadius: BorderRadius.circular(5)
                                      //                           ),
                                      //                           child: TextButton(
                                      //                               style: TextButton.styleFrom(
                                      //                                 backgroundColor: Colors.transparent,
                                      //                                 primary: Colors.green,
                                      //                                 // minimumSize: Size(width, 100),
                                      //                               ),
                                      //                               onPressed: (){},
                                      //                               child: Text('ตกลง')),
                                      //                         ),
                                      //                       ),
                                      //                     ],
                                      //                   )
                                      //                 ],
                                      //               ),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ),
                                      //       // keyboardAware: false,
                                      //       // dialogBackgroundColor: Colors.orange,
                                      //       // borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
                                      //       width: 400,
                                      //       buttonsBorderRadius: BorderRadius.all(Radius.circular(0)),
                                      //       headerAnimationLoop: false,
                                      //       animType: AnimType.SCALE,
                                      //       // autoHide: Duration(seconds: 2),
                                      //       // dialogBackgroundColor: Colors.deepPurpleAccent,
                                      //       // title: 'คุณอยู่นอกรัศมีที่กำหนด',
                                      //       // desc: 'กรุณาอยู่ในพื้นที่ บริษัท วิรัชทุ่งสงค้าข้าว จำกัด',
                                      //     ).show();
                                      //   },
                                      // ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.blue,
                                              elevation: 3,
                                              shape: CircleBorder()
                                          ),
                                          onPressed: (){},
                                          child: const Icon(
                                            Icons.help_outlined,
                                            size: 50,
                                            color: Colors.white,
                                          )
                                      ),
                                      // IconButton(
                                      //   icon: const Icon(
                                      //     Icons.help_outlined,
                                      //   ),
                                      //   iconSize: 50,
                                      //   color: Colors.blue,
                                      //   hoverColor: Colors.transparent,
                                      //   highlightColor: Colors.transparent,
                                      //   splashColor: Colors.transparent,
                                      //   onPressed: () {
                                      //     Navigator.push(context, MaterialPageRoute(builder: (context) => const DocApproveDetailPage()));
                                      //   },
                                      // ),
                                    ],
                                  ),
                                  const SizedBox(height: 10)
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
                      const SizedBox(height: 100)
                    ],
                  ),
                ),
              ),
            ),
            // const SizedBox(height: 20)
          ],
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
