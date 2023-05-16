import 'dart:io';

import 'package:flutter/material.dart';
import 'package:index/pages/bottom_pages/DocHuman/Doc_Human.dart';
import 'package:index/pages/bottom_pages/DocOT/Doc_OT.dart';
import 'package:index/pages/bottom_pages/DocResign/Doc_Resign.dart';
import 'package:index/pages/drawer_page/DrawJobWork/pdf_viewjob.dart';
import 'package:index/pages/widjet/pdf_api.dart';
import 'package:page_transition/page_transition.dart';

import '../bottom_pages/DocAddTime/Doc_AddTime.dart';
import '../bottom_pages/DocCondition/Doc_Condition.dart';
import '../bottom_pages/DocGoodMemory/Doc_GoodMemory.dart';
import '../bottom_pages/DocHoliday/Doc_ChangeHoliday.dart';
import '../bottom_pages/DocKa/Doc_ChangeKa.dart';
import '../bottom_pages/DocLa/Doc_LA.dart';
import '../bottom_pages/DocSalaryCer/Doc_Salary_Certificate.dart';
import '../bottom_pages/DocWarning/Doc_Warning.dart';
import '../bottom_pages/DocWorkCer/Doc_Work_Certificate.dart';

class ButtonInsert{
  Widget show_ButtonInsert_LA(BuildContext context, Function(dynamic value) onGoBack){
    double width = double.infinity;
    return Expanded(
      flex: 0,
      child: Container(
        padding: const EdgeInsets.only(left:10, top: 30, bottom: 20 , right: 10),
        // width: MediaQuery.of(context).size.width,
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(
            Icons.add_circle_outline_outlined,
            color: Colors.white,
            size: 40,
          ),
          onPressed: (){
            // Navigator.push(context, MaterialPageRoute(
            //     builder: (BuildContext context){
            //       return DocLAPage();
            //     })
            // );
            // Navigator.push(context, MaterialPageRoute(builder: (context) => const DocLAPage()));
            // Navigator.push(context, MaterialPageRoute(builder: (context) => const MainDocLa())).then(onGoBack);
            Navigator.of(context).push(
                PageTransition(
                  child: MainDocLa(),
                  type: PageTransitionType.rightToLeft,
                  alignment: Alignment.bottomCenter,
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                )
            ).then(onGoBack);
          },
          label: const Text(
            "ขอลางาน",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            fixedSize: Size(width, 70),
          ),
        ),
      ),
    );
  }

  Widget show_ButtonInsert_KA(BuildContext context, Function(dynamic value) onGoBack){
    double width = double.infinity;
    return Expanded(
      flex: 0,
      child: Container(
        padding: const EdgeInsets.only(left:10, top: 30, bottom: 20 , right: 10),
        // width: MediaQuery.of(context).size.width,
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(
            Icons.add_circle_outline_outlined,
            color: Colors.white,
            size: 40,
          ),
          onPressed: (){
            // Navigator.push(context, MaterialPageRoute(
            //     builder: (BuildContext context){
            //       return DocChangeKaPage();
            //     })
            // ).then(onGoBack);
            Navigator.of(context).push(
                PageTransition(
                  child: DocChangeKaPage(),
                  type: PageTransitionType.rightToLeft,
                  alignment: Alignment.bottomCenter,
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                )
            ).then(onGoBack);
          },
          label: const Text(
            "ขอเปลี่ยนกะการทำงาน",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            fixedSize: Size(width, 70),
          ),
        ),
      ),
    );
  }

  Widget show_ButtonInsert_Holiday(BuildContext context, Function(dynamic value) onGoBack,){
    double width = double.infinity;
    return Expanded(
      flex: 0,
      child: Container(
        padding: const EdgeInsets.only(left:10, top: 30, bottom: 20 , right: 10),
        // width: MediaQuery.of(context).size.width,
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(
            Icons.add_circle_outline_outlined,
            color: Colors.white,
            size: 40,
          ),
          onPressed: (){
            // Navigator.push(context, MaterialPageRoute(
            //     builder: (BuildContext context){
            //       return DocChangeHolidayPage();
            //     })
            // ).then(onGoBack);
            Navigator.of(context).push(
                PageTransition(
                  child: DocChangeHolidayPage(),
                  type: PageTransitionType.rightToLeft,
                  alignment: Alignment.bottomCenter,
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                )
            ).then(onGoBack);
          },
          label: const Text(
            "ขอเปลี่ยนวันหยุด",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            fixedSize: Size(width, 70),
          ),
        ),
      ),
    );
  }

  Widget show_ButtonInsert_AddTime(BuildContext context, Function(dynamic value) onGoBack){
    double width = double.infinity;
    return Expanded(
      flex: 0,
      child: Container(
        padding: const EdgeInsets.only(left:10, top: 30, bottom: 20 , right: 10),
        // width: MediaQuery.of(context).size.width,
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(
            Icons.add_circle_outline_outlined,
            color: Colors.white,
            size: 40,
          ),
          onPressed: (){
            Navigator.of(context).push(
                PageTransition(
                  child: DocAddTimesPage(),
                  type: PageTransitionType.rightToLeft,
                  alignment: Alignment.bottomCenter,
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                )
            ).then(onGoBack);
          },
          label: const Text(
            "ขอเพิ่มเวลา",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            fixedSize: Size(width, 70),
          ),
        ),
      ),
    );
  }

  Widget show_ButtonInsert_OT(BuildContext context, Function(dynamic value) onGoBack){
    double width = double.infinity;
    return Expanded(
      flex: 0,
      child: Container(
        padding: const EdgeInsets.only(left:10, top: 30, bottom: 20 , right: 10),
        // width: MediaQuery.of(context).size.width,
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(
            Icons.add_circle_outline_outlined,
            color: Colors.white,
            size: 40,
          ),
          onPressed: (){
            // Navigator.push(context, MaterialPageRoute(
            //     builder: (BuildContext context){
            //       return DocOTPage();
            //     })
            // ).then(onGoBack);
            Navigator.of(context).push(
                PageTransition(
                  child: DocOTPage(),
                  type: PageTransitionType.rightToLeft,
                  alignment: Alignment.bottomCenter,
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                )
            ).then(onGoBack);
          },
          label: const Text(
            "ขอโอที",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            fixedSize: Size(width, 70),
          ),
        ),
      ),
    );
  }

  Widget show_ButtonInsert_Request_salary_certificate(BuildContext context, Function(dynamic value) onGoBack){
    double width = double.infinity;
    return Expanded(
      flex: 0,
      child: Container(
        padding: const EdgeInsets.only(left:10, top: 30, bottom: 20 , right: 10),
        // width: MediaQuery.of(context).size.width,
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(
            Icons.add_circle_outline_outlined,
            color: Colors.white,
            size: 40,
          ),
          onPressed: (){
            Navigator.of(context).push(
                PageTransition(
                  child: const DocSalaryCertificatePage(),
                  type: PageTransitionType.rightToLeft,
                  alignment: Alignment.center,
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                )
            ).then(onGoBack);
          },
          label: const Text(
            "ขอหนังสือรับรองเงินเดือน",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            fixedSize: Size(width, 70),
          ),
        ),
      ),
    );
  }

  Widget show_ButtonInsert_Request_reimbursement_welfare(BuildContext context){
    double width = double.infinity;
    return Expanded(
      flex: 0,
      child: Container(
        padding: const EdgeInsets.only(left:10, top: 30, bottom: 20 , right: 10),
        // width: MediaQuery.of(context).size.width,
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(
            Icons.add_circle_outline_outlined,
            color: Colors.white,
            size: 40,
          ),
          onPressed: (){

          },
          label: const Text(
            "ขอเบิกสวัสดิการ",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            fixedSize: Size(width, 70),
          ),
        ),
      ),
    );
  }

  Widget show_ButtonInsert_Docwork_certificate(BuildContext context, Function(dynamic value) onGoBack){
    double width = double.infinity;
    return Expanded(
      flex: 0,
      child: Container(
        padding: const EdgeInsets.only(left:10, top: 30, bottom: 20 , right: 10),
        // width: MediaQuery.of(context).size.width,
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(
            Icons.add_circle_outline_outlined,
            color: Colors.white,
            size: 40,
          ),
          onPressed: (){
            Navigator.of(context).push(
                PageTransition(
                  child: const DocWorkCertificatePage(),
                  type: PageTransitionType.rightToLeft,
                  alignment: Alignment.center,
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                )
            ).then(onGoBack);
          },
          label: const Text(
            "ขอหนังสือรับรองการทำงาน",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            fixedSize: Size(width, 70),
          ),
        ),
      ),
    );
  }


  Widget show_ButtonInsert_DocHuman(BuildContext context, Function(dynamic value) onGoBack){
    double width = double.infinity;
    return Expanded(
      flex: 0,
      child: Container(
        padding: const EdgeInsets.only(left:10, top: 30, bottom: 20 , right: 10),
        // width: MediaQuery.of(context).size.width,
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(
            Icons.add_circle_outline_outlined,
            color: Colors.white,
            size: 40,
          ),
          onPressed: (){
            // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){return DocHumanPage();})).then(onGoBack);
            // Navigator.push(context, MaterialPageRoute(builder: (context) => const DocHumanPage())).then(onGoBack);
            Navigator.of(context).push(
                PageTransition(
                  child: DocHumanPage(),
                  type: PageTransitionType.rightToLeft,
                  alignment: Alignment.bottomCenter,
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                )
            ).then(onGoBack);
          },
          label: const Text(
            "ขอกำลังพล",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            fixedSize: Size(width, 70),
          ),
        ),
      ),
    );
  }

  Widget show_ButtonInsert_DocResign(BuildContext context, Function(dynamic value) onGoBack){
    double width = double.infinity;
    return Expanded(
      flex: 0,
      child: Container(
        padding: const EdgeInsets.only(left:10, top: 30, bottom: 20 , right: 10),
        // width: MediaQuery.of(context).size.width,
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(
            Icons.add_circle_outline_outlined,
            color: Colors.white,
            size: 40,
          ),
          onPressed: (){
            // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){return DocHumanPage();})).then(onGoBack);
            // Navigator.push(context, MaterialPageRoute(builder: (context) => const DocResignPage()));
            Navigator.of(context).push(
                PageTransition(
                  child: DocResignPage(),
                  type: PageTransitionType.rightToLeft,
                  alignment: Alignment.bottomCenter,
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                )
            ).then(onGoBack);
          },
          label: const Text(
            "ขอลาออก",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            fixedSize: Size(width, 70),
          ),
        ),
      ),
    );
  }

  Widget show_ButtonInsert_DocWaring(BuildContext context, Function(dynamic value) onGoBack){
    double width = double.infinity;
    return Expanded(
      flex: 0,
      child: Container(
        padding: const EdgeInsets.only(left:10, top: 30, bottom: 20 , right: 10),
        // width: MediaQuery.of(context).size.width,
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(
            Icons.add_circle_outline_outlined,
            color: Colors.white,
            size: 40,
          ),
          onPressed: (){
            Navigator.of(context).push(
                PageTransition(
                  child: const DocWaringPage(),
                  type: PageTransitionType.rightToLeft,
                  alignment: Alignment.center,
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                )
            ).then(onGoBack);
          },
          label: const Text(
            "ขอหนังสือเตือน",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            fixedSize: Size(width, 70),
          ),
        ),
      ),
    );
  }

  Widget show_ButtonInsert_DocCondition(BuildContext context, Function(dynamic value) onGoBack){
    double width = double.infinity;
    return Expanded(
      flex: 0,
      child: Container(
        padding: const EdgeInsets.only(left:10, top: 30, bottom: 20 , right: 10),
        // width: MediaQuery.of(context).size.width,
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(
            Icons.add_circle_outline_outlined,
            color: Colors.white,
            size: 40,
          ),
          onPressed: (){
            Navigator.of(context).push(
                PageTransition(
                  child: const DocConditionPage(),
                  type: PageTransitionType.rightToLeft,
                  alignment: Alignment.center,
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                )
            ).then(onGoBack);
          },
          label: const Text(
            "ขอใบเปลี่ยนสภาพพนักงาน",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            fixedSize: Size(width, 70),
          ),
        ),
      ),
    );
  }

  Widget show_ButtonInsert_DocGoodMemory(BuildContext context, Function(dynamic value) onGoBack){
    double width = double.infinity;
    return Expanded(
      flex: 0,
      child: Container(
        padding: const EdgeInsets.only(left:10, top: 30, bottom: 20 , right: 10),
        // width: MediaQuery.of(context).size.width,
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(
            Icons.add_circle_outline_outlined,
            color: Colors.white,
            size: 40,
          ),
          onPressed: (){
            Navigator.of(context).push(
                PageTransition(
                  child: const DocGoodMemoryPage(),
                  type: PageTransitionType.rightToLeft,
                  alignment: Alignment.center,
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                )
            ).then(onGoBack);
          },
          label: const Text(
            "บันทึกความดี",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            fixedSize: Size(width, 70),
          ),
        ),
      ),
    );
  }

  Widget show_Button_PDF_View(BuildContext context){
    double width = double.infinity;
    return Expanded(
      flex: 0,
      child: Container(
        padding: const EdgeInsets.only(left:10, top: 30, bottom: 20 , right: 10),
        // width: MediaQuery.of(context).size.width,
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(
            Icons.picture_as_pdf_outlined,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () async{
            final path = "images/Flowdoc.pdf";
            final file = await PDFApi.loadAsset(path);
            openPDF(context, file);
          },
          label: const Text(
            "เอกสารใบสมัคร",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            fixedSize: Size(width, 70),
          ),
        ),
      ),
    );
  }

  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
  );

}