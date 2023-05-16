import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AboutUsPage extends StatefulWidget {
  final String title;
  const AboutUsPage({Key? key , required this.title}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  bool loading = false;

  DateTime DateAbout = DateTime.now();
  final _dateAbout = DateFormat('dd/MM/yyyy').format(DateTime.now());
  final ValueNotifier<DateTime?> dateAbout = ValueNotifier(null);

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
    print("Total: $total");
  }


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
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurpleAccent,
                // spreadRadius: 5, blurRadius: 30,
                // offset: Offset(5, 3),
              ),
            ],
            // image: DecorationImage(image: NetworkImage('https://www.pngitem.com/pimgs/m/391-3918613_personal-service-platform-person-icon-circle-png-transparent.png'))
          ),
        ),
      ),
      body: loading ? Container(
        padding: const EdgeInsets.only(left: 10,right: 10,top: 15,bottom: 10),
        width: double.infinity,
        child: Column(
          children: [
            Card(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
                      alignment: Alignment.topLeft,
                      child: const Text(
                        "วันที่",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    ValueListenableBuilder<DateTime?>(
                        valueListenable: dateAbout,
                        builder: (context, dateVal, child) {
                          return InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                DateTime? date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(DateTime.now().year - 5),
                                    lastDate: DateTime(DateTime.now().year + 5),
                                    currentDate: DateTime.now(),
                                    initialEntryMode: DatePickerEntryMode.calendar,
                                    initialDatePickerMode: DatePickerMode.day,
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                            colorScheme:  ColorScheme.light(
                                              primary: Colors.deepPurpleAccent,
                                              onSurface: Colors.grey,
                                            )
                                        ),
                                        child: child!,
                                      );
                                    });
                                dateAbout.value = date;
                              },
                              child: buildDatePicker(
                                  dateVal != null ? convertDate(dateVal) : '')
                          );
                        }),
                    const SizedBox(height: 10,),
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        hintText: "ค้นหา",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade700)
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
            Container(
              padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
              alignment: Alignment.topLeft,
              child: const Text(
                "รายการ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 20,),
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
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
                      ),
                      const SizedBox(height: 20,),
                      Card(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(10, 20, 10, 30),
                              child: const Text(
                                "วันที่ 05/02/2022 ตรวจพบว่าเป็นวันทำงาน แต่ไม่มีการลงเวลาการทำงานเลย เพื่อป้องกันไม่ให้ระบบหักขาดงาน เราจึงแนะนำให้...",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 70,),
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
                                          backgroundColor: Colors.deepPurpleAccent,
                                          primary: Colors.white,
                                          // minimumSize: Size(width, 100),
                                        ),
                                        onPressed: (){
                                          _sum();
                                          // var sum = [1, 2, 3].reduce((a, b) => a + b);
                                          // print(sum);
                                        },
                                        child: Text('ขอลางาน')),
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
                                        ),
                                        onPressed: (){},
                                        child: Text('เปลี่ยนวันหยุด')),
                                  ),
                                ),
                                const SizedBox(width: 70,),
                              ],
                            ),
                            const SizedBox(height: 20,),
                          ],
                        ),
                        elevation: 3,
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.white)
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Card(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(10, 20, 10, 30),
                              child: const Text(
                                "วันที่ 06/02/2022 ตรวจพบว่าคุณได้มาทำงานในวันหยุด เพื่อประโยชน์สูงสุดของคุณ เราจึงแนะนำให้...",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 70,),
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
                                          backgroundColor: Colors.deepPurpleAccent,
                                          primary: Colors.white,
                                          // minimumSize: Size(width, 100),
                                        ),
                                        onPressed: (){
                                        },
                                        child: Text('ขอโอที')),
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
                                        ),
                                        onPressed: (){},
                                        child: Text('เปลี่ยนวันหยุด')),
                                  ),
                                ),
                                const SizedBox(width: 70,),
                              ],
                            ),
                            const SizedBox(height: 20,),
                          ],
                        ),
                        elevation: 3,
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.white)
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Card(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(10, 20, 10, 30),
                              child: const Text(
                                "วันที่ 04/02/2022 ตรวจพบว่าคุณได้มาทำงานก่อนเวลาทำการ 8ชั่วโมง 0 นาที เพื่อประโยชน์สูงสุดของคุณ เราจึงแนะนำให้...",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 70,),
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
                                          backgroundColor: Colors.deepPurpleAccent,
                                          primary: Colors.white,
                                          // minimumSize: Size(width, 100),
                                        ),
                                        onPressed: (){
                                        },
                                        child: Text('ขอโอที')),
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
                                        ),
                                        onPressed: (){},
                                        child: Text('เปลี่ยนกะ')),
                                  ),
                                ),
                                const SizedBox(width: 70,),
                              ],
                            ),
                            const SizedBox(height: 20,),
                          ],
                        ),
                        elevation: 3,
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.white)
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Card(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(10, 20, 10, 30),
                              child: const Text(
                                "วันที่ 26/03/2022 ตรวจพบการลงเวลาจำนวน 1 ครั้ง กรุณาเพิ่มเวลาการทำงานให้ครบคู่ เพื่อป้องกันไม่ให้ระบบหักขาดงาน",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 70,),
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
                                          backgroundColor: Colors.deepPurpleAccent,
                                          primary: Colors.white,
                                          // minimumSize: Size(width, 100),
                                        ),
                                        onPressed: (){
                                        },
                                        child: Text('เพิ่มเวลา')),
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
                                        ),
                                        onPressed: (){},
                                        child: Text('ขอลางาน')),
                                  ),
                                ),
                                const SizedBox(width: 70,),
                              ],
                            ),
                            const SizedBox(height: 20,),
                          ],
                        ),
                        elevation: 3,
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(color: Colors.white)
                        ),
                      ),
                    ],
                  ),
                )
            )

          ],
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

String convertDate(DateTime dateTime) {
  return DateFormat('dd/MM/yyyy').format(dateTime);
}


Widget buildDatePicker(String data) {
  return ListTile(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
      side:  BorderSide(color: Colors.grey, width: 1.5),
    ),
    title: Text(data),
    trailing: const Icon(
      Icons.calendar_today,
      color: Colors.grey,
    ),
  );
}
