import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

class DocApproveDetailPage extends StatefulWidget {
  const DocApproveDetailPage({Key? key}) : super(key: key);

  @override
  State<DocApproveDetailPage> createState() => _DocApproveDetailPageState();
}

class _DocApproveDetailPageState extends State<DocApproveDetailPage> {
  bool loading = false;
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
        title: const Text("รายละเอียดอนุมัติเอกสาร"),
        // leading: IconButton(
        //   onPressed: () {
        //     // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyDrawer(),), (route) => true);
        //     Navigator.of(context).pop();
        //   },
        //   icon: Icon(Icons.arrow_back),
        // ),
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
      body: loading ? SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Card(
                elevation: 3,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.white)
                ),
                child: Container(
                  width: double.infinity,
                  // alignment: Alignment.center,
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 10,left: 10,right: 20),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey.shade400,
                              child: Icon(Icons.person,size: 50,color: Colors.grey.shade700),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("กรรณิการ์ แก้วอุดม",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.black87),),
                              Text("ตำแหน่ง : Call Center",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.deepPurpleAccent),),
                              Text("แผนก : ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.deepPurpleAccent),),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.only(left: 12.0, top: 10, bottom: 4.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "ยื่นขอ ''เปลี่ยนกะการทำงาน'' ",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 5),
                              child: Text(
                                "   ขอวันที่ 30/03/2022 เปลี่ยนเป็น WC0002: 06:30-10:30 - 11:30-15:30",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 20),
                              child: Text(
                                "หมายเหตุ: งานด่วนช่วงเช้า",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "ข้อมูลประกอบ",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const[
                            Text(
                              "วันที่สร้าง : ",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "29/03/2022",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const[
                            Text(
                              "วันที่ : ",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "30/03/2022",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const[
                            Text(
                              "สถานะ : ",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "วันทำงาน",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "กะ : ",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Expanded(
                              flex: 0,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  "จากเดิม : WC001 08:30-12:00 - 13:00-17:30",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 0,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 5),
                                child: Text(
                                  "เปลี่ยนเป็น : WC0002 08:30-12:00 - 13:00-17:30",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const[
                            Text(
                              "เวลาการทำงาน : ",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "",
                              style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.check_circle,
                            ),
                            iconSize: 50,
                            color: Colors.green,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.cancel,
                            ),
                            iconSize: 50,
                            color: Colors.red,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onPressed: () {
                              AwesomeDialog(
                                context: context,
                                // dismissOnTouchOutside: false,
                                // padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
                                dialogType: DialogType.NO_HEADER,
                                body: Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        alignment: Alignment.topLeft,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "หมายเหตุ:",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                            TextFormField(),
                                            const SizedBox(height: 5),
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
                                                          backgroundColor: Colors.transparent,
                                                          primary: Colors.black87,
                                                          // minimumSize: Size(width, 100),
                                                        ),
                                                        onPressed: (){
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Text('ยกเลิก')),
                                                  ),
                                                ),

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
                                                          backgroundColor: Colors.transparent,
                                                          primary: Colors.green,
                                                          // minimumSize: Size(width, 100),
                                                        ),
                                                        onPressed: (){},
                                                        child: Text('ตกลง')),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // keyboardAware: false,
                                // dialogBackgroundColor: Colors.orange,
                                // borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
                                width: 400,
                                buttonsBorderRadius: BorderRadius.all(Radius.circular(0)),
                                headerAnimationLoop: false,
                                animType: AnimType.SCALE,
                                // autoHide: Duration(seconds: 2),
                                // dialogBackgroundColor: Colors.deepPurpleAccent,
                                // title: 'คุณอยู่นอกรัศมีที่กำหนด',
                                // desc: 'กรุณาอยู่ในพื้นที่ บริษัท วิรัชทุ่งสงค้าข้าว จำกัด',
                              ).show();
                            },
                          ),
                          IconButton(
                            icon:
                            // const FaIcon(
                            //     FontAwesomeIcons.react
                            // ),
                            const Icon(
                              Ionicons.reload_circle,
                            ),
                            iconSize: 50,
                            color: Colors.orange,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onPressed: () {
                              AwesomeDialog(
                                context: context,
                                // dismissOnTouchOutside: false,
                                // padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
                                dialogType: DialogType.NO_HEADER,
                                body: Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        alignment: Alignment.topLeft,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "หมายเหตุ:",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                            TextFormField(),
                                            const SizedBox(height: 5),
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
                                                          backgroundColor: Colors.transparent,
                                                          primary: Colors.black87,
                                                          // minimumSize: Size(width, 100),
                                                        ),
                                                        onPressed: (){
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Text('ยกเลิก')),
                                                  ),
                                                ),

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
                                                          backgroundColor: Colors.transparent,
                                                          primary: Colors.green,
                                                          // minimumSize: Size(width, 100),
                                                        ),
                                                        onPressed: (){},
                                                        child: Text('ตกลง')),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // keyboardAware: false,
                                // dialogBackgroundColor: Colors.orange,
                                // borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
                                width: 400,
                                buttonsBorderRadius: BorderRadius.all(Radius.circular(0)),
                                headerAnimationLoop: false,
                                animType: AnimType.SCALE,
                                // autoHide: Duration(seconds: 2),
                                // dialogBackgroundColor: Colors.deepPurpleAccent,
                                // title: 'คุณอยู่นอกรัศมีที่กำหนด',
                                // desc: 'กรุณาอยู่ในพื้นที่ บริษัท วิรัชทุ่งสงค้าข้าว จำกัด',
                              ).show();
                            },
                          ),
                        ],
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
              strokeWidth: 5,
            )
      ),
    );
  }
}
