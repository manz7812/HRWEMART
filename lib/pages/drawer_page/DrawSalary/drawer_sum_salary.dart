import 'package:flutter/material.dart';

class SumSalaryPage extends StatefulWidget {
  const SumSalaryPage({Key? key}) : super(key: key);

  @override
  State<SumSalaryPage> createState() => _SumSalaryPageState();
}

class _SumSalaryPageState extends State<SumSalaryPage> {
  bool loading = false;

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

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2),(){
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
        title: Text('สรุปเงินเดือน'),
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
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Column(
            children: [
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
              const SizedBox(height: 20),
              Card(
                elevation: 3,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.white)
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        // padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                        alignment: Alignment.center,
                        child: const Text(
                          "งวดปกติ",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        // padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                        alignment: Alignment.center,
                        child: const Text(
                          "เดือน เมษายน 2022",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "เงินเดือน",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Container(
                                // padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "เงินเดือนที่ได้รับ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                                color: Colors.amber.shade200
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  // padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                                  alignment: Alignment.centerLeft,
                                  child: const Text(
                                    "0.00",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Container(
                                  // padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                                  alignment: Alignment.centerLeft,
                                  child: const Text(
                                    "0.00",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        flex: 0,
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
                                backgroundColor: Colors.amber.shade600,
                                primary: Colors.white,
                                // minimumSize: Size(width, 100),
                              ),
                              onPressed: (){},
                              child: Text('สลิปเงินเดือน',style: TextStyle(fontSize: 18),)),
                        ),
                      ),
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
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
              strokeWidth: 5,)
        )
    );
  }
}
