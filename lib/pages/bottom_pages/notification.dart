import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text("การแจ้งเตือน"),
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
          width: double.infinity,
          padding: const EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0,bottom: 10.0),
          child: Column(
            children: <Widget>[
               Theme(
                 data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                 child: ExpansionTile(
                  title: Text('ใหม่ (0)'),
                  // subtitle: Text('Trailing expansion arrow icon'),
                  children: <Widget>[
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
                    )
                  ],
              ),
               ),
               Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text('ก่อนหน้านี้ (12)'),
                  // subtitle: Text('Trailing expansion arrow icon'),
                  children: <Widget>[
                    Card(
                      child: Container(
                        width: double.infinity,
                        // height: 150,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 0),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.orange,
                                    child: Icon(Icons.rotate_right_outlined,size: 55,color: Colors.white,),
                                  ),
                                ),
                                // const SizedBox(height: 7,),
                                // Text('ออก',style: TextStyle(color: Colors.grey,fontSize: 18),)
                              ],
                            ),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget> [
                                     Text("[ลาพักร้อน: รออนุมัติ]",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.black),),
                                     Text("กรรณิการ์ แก้วอุดม ได้ยื่นเรื่อง ''ขอลาพักร้อน'' "
                                         "ตั้งแต่วันที่ 04/03/2022 ถึงวันที่ 04/03/2022 "
                                         "เนื่องจากว่า '''' ",
                                       style: TextStyle(
                                           fontSize: 14,
                                           color: Colors.black
                                       ),
                                     ),
                                  ],
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
                    Card(
                      child: Container(
                        width: double.infinity,
                        // height: 150,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 0),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.orange,
                                    child: Icon(Icons.rotate_right_outlined,size: 55,color: Colors.white,),
                                  ),
                                ),
                                // const SizedBox(height: 7,),
                                // Text('ออก',style: TextStyle(color: Colors.grey,fontSize: 18),)
                              ],
                            ),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget> [
                                    Text("[ลาพักร้อน: รออนุมัติ]",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.black),),
                                    Text("กรรณิการ์ แก้วอุดม ได้ยื่นเรื่อง ''ขอลาพักร้อน'' "
                                        "ตั้งแต่วันที่ 04/03/2022 ถึงวันที่ 04/03/2022 "
                                        "เนื่องจากว่า '''' ",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black
                                      ),
                                    ),
                                  ],
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
                    Card(
                      child: Container(
                        width: double.infinity,
                        // height: 150,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 0),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.orange,
                                    child: Icon(Icons.rotate_right_outlined,size: 55,color: Colors.white,),
                                  ),
                                ),
                                // const SizedBox(height: 7,),
                                // Text('ออก',style: TextStyle(color: Colors.grey,fontSize: 18),)
                              ],
                            ),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget> [
                                    Text("[ลาพักร้อน: รออนุมัติ]",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.black),),
                                    Text("กรรณิการ์ แก้วอุดม ได้ยื่นเรื่อง ''ขอลาพักร้อน'' "
                                        "ตั้งแต่วันที่ 04/03/2022 ถึงวันที่ 04/03/2022 "
                                        "เนื่องจากว่า '''' ",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black
                                      ),
                                    ),
                                  ],
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
                    Card(
                      child: Container(
                        width: double.infinity,
                        // height: 150,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 0),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.orange,
                                    child: Icon(Icons.rotate_right_outlined,size: 55,color: Colors.white,),
                                  ),
                                ),
                                // const SizedBox(height: 7,),
                                // Text('ออก',style: TextStyle(color: Colors.grey,fontSize: 18),)
                              ],
                            ),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget> [
                                    Text("[ลาพักร้อน: รออนุมัติ]",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.black),),
                                    Text("กรรณิการ์ แก้วอุดม ได้ยื่นเรื่อง ''ขอลาพักร้อน'' "
                                        "ตั้งแต่วันที่ 04/03/2022 ถึงวันที่ 04/03/2022 "
                                        "เนื่องจากว่า '''' ",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black
                                      ),
                                    ),
                                  ],
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
                    Card(
                      child: Container(
                        width: double.infinity,
                        // height: 150,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 0),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.orange,
                                    child: Icon(Icons.rotate_right_outlined,size: 55,color: Colors.white,),
                                  ),
                                ),
                                // const SizedBox(height: 7,),
                                // Text('ออก',style: TextStyle(color: Colors.grey,fontSize: 18),)
                              ],
                            ),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget> [
                                    Text("[ลาพักร้อน: รออนุมัติ]",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.black),),
                                    Text("กรรณิการ์ แก้วอุดม ได้ยื่นเรื่อง ''ขอลาพักร้อน'' "
                                        "ตั้งแต่วันที่ 04/03/2022 ถึงวันที่ 04/03/2022 "
                                        "เนื่องจากว่า '''' ",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black
                                      ),
                                    ),
                                  ],
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
                    Card(
                      child: Container(
                        width: double.infinity,
                        // height: 150,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 0),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.orange,
                                    child: Icon(Icons.rotate_right_outlined,size: 55,color: Colors.white,),
                                  ),
                                ),
                                // const SizedBox(height: 7,),
                                // Text('ออก',style: TextStyle(color: Colors.grey,fontSize: 18),)
                              ],
                            ),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget> [
                                    Text("[ลาพักร้อน: รออนุมัติ]",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.black),),
                                    Text("กรรณิการ์ แก้วอุดม ได้ยื่นเรื่อง ''ขอลาพักร้อน'' "
                                        "ตั้งแต่วันที่ 04/03/2022 ถึงวันที่ 04/03/2022 "
                                        "เนื่องจากว่า '''' ",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black
                                      ),
                                    ),
                                  ],
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
                    Card(
                      child: Container(
                        width: double.infinity,
                        // height: 150,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 0),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.orange,
                                    child: Icon(Icons.rotate_right_outlined,size: 55,color: Colors.white,),
                                  ),
                                ),
                                // const SizedBox(height: 7,),
                                // Text('ออก',style: TextStyle(color: Colors.grey,fontSize: 18),)
                              ],
                            ),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget> [
                                    Text("[ลาพักร้อน: รออนุมัติ]",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.black),),
                                    Text("กรรณิการ์ แก้วอุดม ได้ยื่นเรื่อง ''ขอลาพักร้อน'' "
                                        "ตั้งแต่วันที่ 04/03/2022 ถึงวันที่ 04/03/2022 "
                                        "เนื่องจากว่า '''' ",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black
                                      ),
                                    ),
                                  ],
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
