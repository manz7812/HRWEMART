import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:page_transition/page_transition.dart';

import '../bottom_pages/DocToMe/DocCondition/DTM_DocCondition.dart';
import '../bottom_pages/DocToMe/DocGoodMemory/DTM_DocGoodMemory.dart';
import '../bottom_pages/DocToMe/DocHoliday/DTM_DocHoliday.dart';
import '../bottom_pages/DocToMe/DocKa/DTM_DocKa.dart';
import '../bottom_pages/DocToMe/DocOT/DTM_DocOT.dart';
import '../bottom_pages/DocToMe/DocWarning/DTM_DocWarning.dart';

class docToMe{
 static Widget change_Ka(BuildContext context){
    return  Card(
        margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        child: ListTile(
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text("เปลี่ยนกะทำงาน"),
          ),
          // subtitle: Text("Lower the anchor."),
          // leading: Icon(MaterialCommunityIcons.calendar_outline,color: Colors.deepPurpleAccent,),
          leading: Icon(MaterialCommunityIcons.calendar_outline,color: Colors.deepPurpleAccent,),
          trailing: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
          onTap: (){
            Navigator.of(context).push(
                PageTransition(
                  child: const DTMDocKaPage(),
                  type: PageTransitionType.fade,
                  alignment: Alignment.center,
                  // fullscreenDialog: true,
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                )
            );
          },
        )
    );
  }

 static Widget change_holiday(BuildContext context){
   return  Card(
       margin: EdgeInsets.all(10),
       clipBehavior: Clip.antiAlias,
       elevation: 20,
       shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(50)
       ),
       child: ListTile(
         title: Container(
             alignment: Alignment.centerLeft,
             child: Text("เปลี่ยนวันหยุด")
         ),
         // subtitle: Text("Lower the anchor."),
         leading: Icon(Ionicons.calendar_outline,color: Colors.deepPurpleAccent,),
         trailing: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
         onTap: (){
           Navigator.of(context).push(
               PageTransition(
                 child: const DTMDocHolidayPage(),
                 type: PageTransitionType.fade,
                 alignment: Alignment.center,
                 // fullscreenDialog: true,
                 duration: Duration(milliseconds: 600),
                 reverseDuration: Duration(milliseconds: 600),
               )
           );
         },
       )
   );
 }

 static Widget doc_OT(BuildContext context){
   return  Card(
       margin: EdgeInsets.all(10),
       clipBehavior: Clip.antiAlias,
       elevation: 20,
       shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(50)
       ),
       child: ListTile(
         title: Container(
           alignment: Alignment.centerLeft,
           child: Text("โอที"),
         ),
         // subtitle: Text("Lower the anchor."),
         leading: Icon(Ionicons.hourglass_outline,color: Colors.deepPurpleAccent,),
         trailing: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
         onTap: (){
           Navigator.of(context).push(
               PageTransition(
                 child: const DTMDocOTPage(),
                 type: PageTransitionType.fade,
                 alignment: Alignment.center,
                 duration: Duration(milliseconds: 600),
                 reverseDuration: Duration(milliseconds: 600),
               )
           );
         },
       )
   );
 }

 static Widget doc_warning(BuildContext context){
   return  Card(
       margin: EdgeInsets.all(10),
       clipBehavior: Clip.antiAlias,
       elevation: 20,
       shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(50)
       ),
       child: ListTile(
         title: Container(
             alignment: Alignment.centerLeft,
             child: Text("หนังสือเตือน")
         ),
         // subtitle: Text("Lower the anchor."),
         leading: Icon(Icons.warning_amber_rounded,color: Colors.deepPurpleAccent,),
         trailing: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
         onTap: (){
           Navigator.of(context).push(
               PageTransition(
                 child: const DTMDocWarningPage(),
                 type: PageTransitionType.fade,
                 alignment: Alignment.center,
                 duration: Duration(milliseconds: 600),
                 reverseDuration: Duration(milliseconds: 600),
               )
           );
         },
       )
   );
 }

 static Widget doc_change_condition(BuildContext context){
   return  Card(
       margin: EdgeInsets.all(10),
       clipBehavior: Clip.antiAlias,
       elevation: 20,
       shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(50)
       ),
       child: ListTile(
         title: Container(
             alignment: Alignment.centerLeft,
             child: Text("ใบแจ้งเปลี่ยนสภาพ")
         ),
         // subtitle: Text("Lower the anchor."),
         leading: Icon(Icons.change_circle_outlined,color: Colors.deepPurpleAccent,),
         trailing: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
         onTap: (){
           Navigator.of(context).push(
               PageTransition(
                 child: const DTMDocCondiTionPage(),
                 type: PageTransitionType.fade,
                 alignment: Alignment.center,
                 duration: Duration(milliseconds: 600),
                 reverseDuration: Duration(milliseconds: 600),
               )
           );
         },
       )
   );
 }

 static Widget doc_to_me(BuildContext context){
   return  Card(
       margin: EdgeInsets.all(10),
       clipBehavior: Clip.antiAlias,
       elevation: 20,
       shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(50)
       ),
       child: ListTile(
         title: Container(
             alignment: Alignment.centerLeft,
             child: Text("บันทึกความดี")
         ),
         // subtitle: Text("Lower the anchor."),
         leading: Icon(Ionicons.book_outline,color: Colors.deepPurpleAccent,),
         trailing: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
         onTap: (){
           Navigator.of(context).push(
               PageTransition(
                 child: const DTMDocGoodMemoryPage(),
                 type: PageTransitionType.fade,
                 alignment: Alignment.center,
                 duration: Duration(milliseconds: 600),
                 reverseDuration: Duration(milliseconds: 600),
               )
           );
         },
       )
   );
 }
}