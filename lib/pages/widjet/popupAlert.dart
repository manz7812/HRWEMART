import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:index/pages/widjet/singout.dart';


class popup{
  submitDocHuman(BuildContext context){
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.QUESTION,
      dismissOnTouchOutside: false,
      // dialogBackgroundColor: Colors.orange,
      borderSide: BorderSide(color: Colors.orange.shade300, width: 2),
      width: 350,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(10)),
      headerAnimationLoop: false,
      animType: AnimType.SCALE,
      // dialogBackgroundColor: Colors.deepPurpleAccent,
      title: 'ยืนยันการบันทึก',
      showCloseIcon: false,
      btnOkText: "ตกลง",
      btnCancelText: "ยกเลิก",
      btnOkOnPress: () {
      },
      btnCancelOnPress: (){},
    ).show();
  }

  sessionexpire(BuildContext context){
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO_REVERSED,
      dismissOnTouchOutside: false,
      // dialogBackgroundColor: Colors.orange,
      borderSide: BorderSide(color: Colors.black12, width: 2),
      width: 350,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(20)),
      headerAnimationLoop: false,
      animType: AnimType.SCALE,
      showCloseIcon: false,
      // dialogBackgroundColor: Colors.deepPurpleAccent,
      title: 'เซสชั่นหมดอายุ',
      desc: 'กรุณา Login ใหม่อีกครั้ง',
      btnOkText: "ตกลง",
      btnCancelText: "ยกเลิก",
      btnOkOnPress: () {
        signOut(context);
      },
    ).show();
  }

  server400(BuildContext context){
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO_REVERSED,
      dismissOnTouchOutside: false,
      // dialogBackgroundColor: Colors.orange,
      borderSide: BorderSide(color: Colors.black12, width: 2),
      width: 350,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(10)),
      headerAnimationLoop: false,
      animType: AnimType.SCALE,
      showCloseIcon: false,
      // dialogBackgroundColor: Colors.deepPurpleAccent,
      title: 'เชื่อมต่อเซิพเวอร์ไม่สำเร็จ',
      desc: 'กรุณาลองใหม่อีกครั้ง',
      btnOkText: "ตกลง",
      btnCancelText: "ยกเลิก",
      btnOkOnPress: () {

      },
    ).show();
  }
}