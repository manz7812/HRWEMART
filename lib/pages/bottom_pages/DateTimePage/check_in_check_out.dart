import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CheckInCheckOutToDayTimePage extends StatefulWidget {
  const CheckInCheckOutToDayTimePage({Key? key}) : super(key: key);

  @override
  State<CheckInCheckOutToDayTimePage> createState() => _CheckInCheckOutToDayTimePageState();
}

class _CheckInCheckOutToDayTimePageState extends State<CheckInCheckOutToDayTimePage> {

  DateTime _date = DateTime.now();
  final dateFormat = DateFormat("dd/MM/yyyy");
  // DateFormat('dd-MM-yyyy').format(DateTime.now());

  void _selectDate() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime(3000),
      helpText: 'เลือกวันที่',
    );
    if (newDate != null) {
      setState(() {
        _date = newDate;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text("เวลาเข้า-ออก"),
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          width: double.infinity,
          child: Column(
            children: [
              Card(
                child: Container(
                  padding: EdgeInsets.all(12),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "เลือกวันทำงาน",
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
                        // padding: const EdgeInsets.only(right: 16, left: 16),
                        // margin: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade500
                            ),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: ElevatedButton(

                          // minWidth: width,
                          // height: 48,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  DateFormat('dd/MM/yyyy').format(_date),
                                  style: const TextStyle(
                                    color: Colors.black,
                                  )
                              ),
                              // SizedBox(width: 10),
                              Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                          onPressed: (){
                            _selectDate();
                          },
                        ),
                      ),
                      // DateTimeField(
                      //   format: dateFormat,
                      //   onShowPicker: (context, currentValue) {
                      //     return showDatePicker(
                      //         context: context,
                      //         firstDate: DateTime(1900),
                      //         initialDate: currentValue ?? DateTime.now(),
                      //         lastDate: DateTime(2100));
                      //   },
                      // ),
                      const SizedBox(height: 10,),
                      Container(
                        padding: const EdgeInsets.only(left: 0.0, bottom: 4.0),
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "คำค้นหา",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          // hintText: "กรุณากรอกรายละเอียด",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade700)
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
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
                          child: ElevatedButton(

                              onPressed: (){
                                // Navigator.of(context).pop();
                              },
                              child: Text('ค้นหา',style: TextStyle(color: Colors.white,fontSize: 18),)
                          ),
                        ),
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
              const SizedBox(height: 20,),
              Card(
                child: Container(
                  width: double.infinity,
                  height: 150,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(15),
                  child: Text('ไม่พบข้อมูล',style: TextStyle(color: Colors.grey,fontSize: 20),),
                ),
                elevation: 3,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.white)
                ),
              ),
              const SizedBox(height: 20,),
              Card(
                child: Container(
                  width: double.infinity,
                  height: 150,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 15),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.grey.shade400,
                            ),
                          ),
                          const SizedBox(height: 7,),
                          Text('ออก',style: TextStyle(color: Colors.grey,fontSize: 18),)
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:  [
                            const Text("ธีรภัทร์ เจริญวงค์ (แมน)",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.black),),
                            Row(
                              children: const[
                                Text("สถานะ : ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.black),),
                                Text("วันทำงาน",style: TextStyle(fontSize: 16,color: Colors.black),),
                              ],
                            ),
                            Row(
                              children: const[
                                Text("กะ : ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.black),),
                                Text("WC0001 08:00 - 17:00",style: TextStyle(fontSize: 16,color: Colors.black),),
                              ],
                            ),
                            Row(
                              children: const[
                                Text("เวลา : ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.black),),
                                Text("08:00 - 17:00",style: TextStyle(fontSize: 16,color: Colors.black),),
                              ],
                            ),



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
