import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchSelectDropdown extends StatefulWidget {
  const SearchSelectDropdown({Key? key}) : super(key: key);

  @override
  State<SearchSelectDropdown> createState() => _SearchSelectDropdownState();
}

class _SearchSelectDropdownState extends State<SearchSelectDropdown> {

  String? selectedYear;
  List ListYear = [];

  Future<Null> listyear() async{
    var df = DateFormat('yyyy').format(DateTime.now());
    for (var i = int.parse(df); i > int.parse(df) - 20; i--) {
      ListYear.add(i.toString());
    }
  }

  String? selectedMonth;
  List ListMonth =[
    {"id":"00",
      "name":"ทั้งหมด"
    },
    {"id":"01",
      "name":"มกราคม"
    },
    {"id":"02",
      "name":"กุมภาพันธ์"
    },
    {"id":"03",
      "name":"มีนาคม"
    },
    {"id":"04",
      "name":"เมษายน"
    },
    {"id":"05",
      "name":"พฤษภาคม"
    },
    {"id":"06",
      "name":"มิถุนายน"
    },
    {"id":"07",
      "name":"กรกฎาคม"
    },
    {"id":"08",
      "name":"สิงหาคม"
    },
    {"id":"09",
      "name":"กันยายน"
    },
    {"id":"10",
      "name":"ตุลาคม"
    },
    {"id":"11",
      "name":"พฤศจิกายน"
    },
    {"id":"12",
      "name":"ธันวาคม"
    }
  ];

  String? selectedStatus;
  List ListStatus =[
    'ทั้งหมด',
    'รออนุมัติ', 'อนุมัติ', 'ไม่อนุมัติ','ตีกลับ','ยกเลิก',
  ];

  @override
  void initState() {
    listyear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(6.0),
      child: Card(
        child: Container(
          // height: 200,
          // alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(20),
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
                            // hint: Container(
                            //   // padding: const EdgeInsets.only(right: 5, left: 8),
                            //     alignment: AlignmentDirectional.centerStart,
                            //     // width: 180,
                            //     child: Text(
                            //       ListMonth.first,
                            //       style: const TextStyle(
                            //         color: Colors.black,fontSize: 16,
                            //       ),
                            //     )
                            // ),
                            icon: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey.shade700,),
                            value: selectedMonth,
                            onChanged: (value) {
                              setState(() {
                                selectedMonth = value as String;
                              });
                            },
                            items: ListMonth.map((valueItem) {
                              return DropdownMenuItem(
                                  value: valueItem['id'].toString(),child: Text(valueItem['name'])
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
                  // const SizedBox(width: 30,),
                ],
              ),
              const SizedBox(height: 10,),
            ],
          ),
        ),
        elevation: 3,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.white)
        ),
      ),
    );
  }
}
