import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MyDialog{
  Future<Null>alertLocationService(BuildContext context) async{
    showDialog(context: context, builder: (context)=>
         AlertDialog(
          title: const ListTile(
            leading: Icon(Icons.location_off),
            title: Text('Location Service ปิดอยู่ ?'),
            subtitle: Text('กรุณาเปิด Location Service'),
          ),
          actions: [
            TextButton(onPressed: () async{
                  // Navigator.pop(context);
                  await Geolocator.openLocationSettings();
                  exit(0);
                },
                child: Text('ตกลง'))
          ],
        ),
    );
  }

  alertLocationService2(BuildContext context){
     return AwesomeDialog(
       context: context,
       dialogType: DialogType.WARNING,
       // dialogBackgroundColor: Colors.orange,
       borderSide: BorderSide(color: Colors.orangeAccent, width: 1),
       width: 400,
       buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
       headerAnimationLoop: false,
       animType: AnimType.SCALE,
       title: 'Location Service ปิดอยู่',
       desc: 'กรุณาเปิด Location Service',
       showCloseIcon: false,
       btnOkText: "ตกลง",
       // btnOkOnPress: () {},
     ).show();
  }

  // alertLocationService3(BuildContext context){
  //   return SweetAlert.show(context,
  //       title: "ไม่อนุญาตให้เข้าถึงตำแหน่ง",
  //       subtitle: "กรุณาเปิดการเข้าถึงตำแหน่ง",
  //       style: SweetAlertStyle.confirm,
  //       showCancelButton: false,
  //       confirmButtonText: "ตกลง",
  //       onPress: (bool isConfirm) {
  //         if(isConfirm) {
  //           SweetAlert.show(
  //               context,
  //               title: "Please Open Location!",
  //               style: SweetAlertStyle.loading
  //           );
  //           // Future.delayed(Duration(seconds: 2),(){
  //           //   SweetAlert.show(context,
  //           //       title: "Please Open Location Before Use.",
  //           //       style: SweetAlertStyle.error
  //           //   );
  //           // });
  //           Future.delayed(const Duration(seconds: 2),(){
  //             Geolocator.openLocationSettings();
  //             exit(0);
  //           });
  //
  //           // SweetAlert.show(context,subtitle: "Deleting...", style: SweetAlertStyle.loading);
  //         }else{
  //           Geolocator.openLocationSettings();
  //           exit(0);
  //           // SweetAlert.show(context,subtitle: "Canceled!", style: SweetAlertStyle.error);
  //         }
  //         // return false to keep dialog
  //         return false;
  //       });
  // }

  // alertLogin(BuildContext context)async{
  //   return SweetAlert.show(
  //       context,
  //       title: "เข้าสู่ระบบสำเร็จ",
  //       // subtitle: "เข้าสู่ระบบสำเร็จ",
  //       style: SweetAlertStyle.success,
  //       confirmButtonColor: Colors.green,
  //   );
  // }
  alertLogin2(BuildContext context){
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      // dialogBackgroundColor: Colors.orange,
      borderSide: BorderSide(color: Colors.green, width: 2),
      width: 350,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(10)),
      headerAnimationLoop: false,
      animType: AnimType.SCALE,
      autoHide: Duration(seconds: 2),
      // dialogBackgroundColor: Colors.deepPurpleAccent,
      title: 'สำเร็จ',
      desc: 'เข้าสู่ระบบสำเร็จ',
      showCloseIcon: false,
      btnOkText: "ตกลง",
      // btnOkOnPress: () {},
    ).show();
  }
  // alertLogin3(BuildContext context)async{
  //   return SweetAlert.show(
  //     context,
  //     title: "เข้าสู่ระบบไม่สำเร็จ",
  //     subtitle: "โปรดลองใหม่อีกครั้ง",
  //     style: SweetAlertStyle.error,
  //     // confirmButtonColor: Colors.green,
  //   );
  // }
  alertLogin4(BuildContext context)async{
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      // dialogBackgroundColor: Colors.orange,
      borderSide: BorderSide(color: Colors.red, width: 2),
      width: 300,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(10)),
      headerAnimationLoop: false,
      animType: AnimType.SCALE,
      title: 'เข้าสู่ระบบไม่สำเร็จ',
      desc: 'โปรดลองใหม่อีกครั้ง',
      showCloseIcon: false,
      btnOkText: "ตกลง",
      // btnOkOnPress: () {},
    ).show();
  }

  alertLogin5(BuildContext context)async{
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      // dialogBackgroundColor: Colors.orange,
      borderSide: BorderSide(color: Colors.amber.shade600, width: 2),
      width: 300,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(10)),
      headerAnimationLoop: false,
      animType: AnimType.SCALE,
      autoHide: Duration(seconds: 3),
      title: 'กรุณากรอกข้อมูล',
      desc: 'โปรดลองใหม่อีกครั้ง',
      showCloseIcon: false,
      btnOkText: "ตกลง",
      // btnOkOnPress: () {},
    ).show();
  }

  alertLogin6(BuildContext context)async{
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      // dialogBackgroundColor: Colors.orange,
      borderSide: BorderSide(color: Colors.amber.shade600, width: 2),
      width: 350,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(10)),
      headerAnimationLoop: false,
      animType: AnimType.SCALE,
      autoHide: Duration(seconds: 3),
      title: 'ชื่อผู้หรือรหัสผ่านไม่ถูกต้อง',
      desc: 'โปรดลองใหม่อีกครั้ง',
      showCloseIcon: false,
      btnOkText: "ตกลง",
      // btnOkOnPress: () {},
    ).show();
  }

  alertLogin7(BuildContext context)async{
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      // dialogBackgroundColor: Colors.orange,
      borderSide: BorderSide(color: Colors.red.shade600, width: 2),
      width: 350,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(10)),
      headerAnimationLoop: false,
      animType: AnimType.SCALE,
      // autoHide: Duration(seconds: 3),
      title: '400 Bad Request',
      desc: 'Please try again later.',
      showCloseIcon: false,
      btnOkText: "ตกลง",
      // btnOkOnPress: () {},
    ).show();
  }

  alertLogout(BuildContext context){
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      // dialogBackgroundColor: Colors.orange,
      borderSide: BorderSide(color: Colors.green, width: 2),
      width: 300,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(10)),
      headerAnimationLoop: false,
      animType: AnimType.SCALE,
      autoHide: Duration(seconds: 2),
      // dialogBackgroundColor: Colors.deepPurpleAccent,
      title: 'สำเร็จ',
      desc: 'ออกจากระบบสำเร็จ',
      showCloseIcon: false,
      btnOkText: "ตกลง",
      // btnOkOnPress: () {},
    ).show();
  }

  alerchecklocationsuccess(BuildContext context){
    return AwesomeDialog(
        context: context,
        dismissOnTouchOutside: false,
        dialogType: DialogType.SUCCES,
        // dialogBackgroundColor: Colors.orange,
        borderSide: BorderSide(color: Colors.green, width: 2),
        width: 500,
        buttonsBorderRadius: BorderRadius.all(Radius.circular(10)),
        headerAnimationLoop: false,
        animType: AnimType.SCALE,
        // autoHide: Duration(seconds: 2),
        // dialogBackgroundColor: Colors.deepPurpleAccent,
        title: 'เช็คอินสำเร็จ',
        desc: 'เวลา 08:00 น.',
        showCloseIcon: false,
        btnOkText: "หน้าหลัก",
        btnCancelText: "ลองอีกครั้ง",
        btnOkColor: Colors.green,
        btnCancelColor: Colors.amber,
        btnOkOnPress: () {
          Navigator.pop(context);
        },
    ).show();
  }

  alerchecklocation(BuildContext context){
    return AwesomeDialog(
      context: context,
      dismissOnTouchOutside: false,
      dialogType: DialogType.WARNING,
      // dialogBackgroundColor: Colors.orange,
      borderSide: BorderSide(color: Colors.amber.shade600, width: 2),
      width: 500,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(10)),
      headerAnimationLoop: false,
      animType: AnimType.SCALE,
      // autoHide: Duration(seconds: 3),
      // dialogBackgroundColor: Colors.deepPurpleAccent,
      title: 'คุณอยู่นอกรัศมีที่กำหนด',
      desc: 'กรุณาอยู่ในพื้นที่ บริษัท วิรัชทุ่งสงค้าข้าว จำกัด',
      showCloseIcon: false,
      btnOkText: "หน้าหลัก",
      btnCancelText: "ลองอีกครั้ง",
      btnOkColor: Colors.deepPurpleAccent,
      btnCancelColor: Colors.amber,
      btnOkOnPress: () {
        Navigator.pop(context);
      },
      btnCancelOnPress: (){

      }
    ).show();
  }

  alertreload(BuildContext context){
    return AwesomeDialog(
      context: context,
      // dismissOnTouchOutside: false,
      // padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
      dialogType: DialogType.NO_HEADER,
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 10, 20),
        // child:  CircularProgressIndicator(
        //   valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
        //   strokeWidth: 5,
        // )
        child: LoadingAnimationWidget.threeArchedCircle(
            color: Colors.deepPurpleAccent, size: 50),
      ),
      // keyboardAware: false,
      dialogBackgroundColor: Colors.white,
      // borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
      width: 250,
      // buttonsBorderRadius: BorderRadius.all(Radius.circular(5)),
      headerAnimationLoop: false,
      animType: AnimType.SCALE,
      autoHide: Duration(seconds: 3),
      // dialogBackgroundColor: Colors.deepPurpleAccent,
      // title: 'คุณอยู่นอกรัศมีที่กำหนด',
      // desc: 'กรุณาอยู่ในพื้นที่ บริษัท วิรัชทุ่งสงค้าข้าว จำกัด',
    ).show();
  }


  alertpicselect(BuildContext context){
    return AwesomeDialog(
      context: context,
      // dismissOnTouchOutside: false,
      // padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
      dialogType: DialogType.NO_HEADER,
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Ink(
              child:IconButton(
                icon: Icon(Ionicons.camera_outline),
                color: Colors.black87,
                iconSize: 50,
                splashRadius: 40,
                disabledColor: Colors.grey,
                onPressed: () {},
              ),
              // decoration: ShapeDecoration(
              //     color: Colors.grey,
              //     shape: OutlineInputBorder()
              // ),
            ),
            Ink(
              child:IconButton(
                icon: Icon(Ionicons.image_outline),
                color: Colors.black87,
                iconSize: 50,
                splashRadius: 40,
                disabledColor: Colors.grey,
                onPressed: () {},
              ),
              // decoration: ShapeDecoration(
              //     color: Colors.grey,
              //     shape: OutlineInputBorder()
              // ),
            )
          ],
        ),
      ),
      // keyboardAware: false,
      // dialogBackgroundColor: Colors.orange,
      borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
      width: 300,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(5)),
      headerAnimationLoop: false,
      animType: AnimType.SCALE,
      // autoHide: Duration(seconds: 2),
      // dialogBackgroundColor: Colors.deepPurpleAccent,
      // title: 'คุณอยู่นอกรัศมีที่กำหนด',
      // desc: 'กรุณาอยู่ในพื้นที่ บริษัท วิรัชทุ่งสงค้าข้าว จำกัด',
    ).show();
  }

  alertForm(BuildContext context){
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      dismissOnTouchOutside: false,
      // dialogBackgroundColor: Colors.orange,
      borderSide: BorderSide(color: Colors.green, width: 2),
      width: 350,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(10)),
      headerAnimationLoop: false,
      animType: AnimType.SCALE,
      // autoHide: Duration(seconds: 3),
      // dialogBackgroundColor: Colors.deepPurpleAccent,
      title: 'บันทึกข้อมูลสำเร็จ',
      // desc: 'บันทึกข้อมูลสำเร็จ',
      showCloseIcon: false,
      btnOkText: "ตกลง",
      btnOkOnPress: () {
        Navigator.pop(context);
      },
    ).show();
  }

  alertlistmenu(BuildContext context){
    return AwesomeDialog(
      context: context,
      aligment: Alignment.centerLeft,
      // dismissOnTouchOutside: false,
      dialogType: DialogType.NO_HEADER,
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(Icons.circle,color: Colors.pink,),
                const SizedBox(width: 10),
                Text('ลงเวลาไม่ครบคู่',style: TextStyle(color: Colors.white),)
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.circle,color: Colors.yellow),
                const SizedBox(width: 10),
                Text('ขาดงานเต็มวัน',style: TextStyle(color: Colors.white))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.circle,color: Colors.greenAccent),
                const SizedBox(width: 10),
                Text('วันปัจจุบัน',style: TextStyle(color: Colors.white))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.circle,color: Colors.grey.shade100),
                const SizedBox(width: 10),
                Text('วันหยุด',style: TextStyle(color: Colors.white))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.circle,color: Colors.white),
                const SizedBox(width: 10),
                Text('เข้างานปกติ',style: TextStyle(color: Colors.white))
              ],
            ),
          ],
        ),
      ),
      // keyboardAware: false,
      dialogBackgroundColor: Colors.black38,
      width: 250,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(5)),
      headerAnimationLoop: false,
      animType: AnimType.SCALE,
      autoHide: Duration(seconds: 3),
      // dialogBackgroundColor: Colors.deepPurpleAccent,
      // title: 'คุณอยู่นอกรัศมีที่กำหนด',
      // desc: 'กรุณาอยู่ในพื้นที่ บริษัท วิรัชทุ่งสงค้าข้าว จำกัด',
    ).show();
  }


  alertJobWork(BuildContext context){
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.QUESTION,
      dismissOnTouchOutside: false,
      // dialogBackgroundColor: Colors.orange,
      // borderSide: BorderSide(color: Colors.green, width: 2),
      width: 350,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(10)),
      headerAnimationLoop: false,
      animType: AnimType.SCALE,
      // autoHide: Duration(seconds: 3),
      // dialogBackgroundColor: Colors.deepPurpleAccent,
      title: 'คุณสนใจใบสมัคร',
      // desc: 'บันทึกข้อมูลสำเร็จ',
      showCloseIcon: false,
      btnOkText: "ตกลง",
      btnOkOnPress: () {
        Navigator.pop(context);
      },
      btnCancelOnPress: (){

      }
    ).show();
  }

  alertJobWorkCancle(BuildContext context){
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.QUESTION,
      dismissOnTouchOutside: false,
      // dialogBackgroundColor: Colors.orange,
      borderSide: BorderSide(color: Colors.transparent, width: 2),
      width: 400,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(10)),
      headerAnimationLoop: false,
      animType: AnimType.SCALE,
      // autoHide: Duration(seconds: 3),
      // dialogBackgroundColor: Colors.deepPurpleAccent,
      title: 'คุณแน่ใจไหมที่จะปฎิเสธใบสมัคร',
      // desc: 'บันทึกข้อมูลสำเร็จ',
      showCloseIcon: false,
      btnOkText: "ตกลง",
      btnCancelText: "ยกเลิก",
      btnOkOnPress: () {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          dismissOnTouchOutside: false,
          // dialogBackgroundColor: Colors.orange,
          borderSide: BorderSide(color: Colors.green, width: 2),
          width: 350,
          buttonsBorderRadius: BorderRadius.all(Radius.circular(10)),
          headerAnimationLoop: false,
          animType: AnimType.SCALE,
          // autoHide: Duration(seconds: 3),
          // dialogBackgroundColor: Colors.deepPurpleAccent,
          title: 'บันทึกข้อมูลสำเร็จ',
          // desc: 'บันทึกข้อมูลสำเร็จ',
          showCloseIcon: false,
          btnOkText: "ตกลง",
          btnOkOnPress: () {
            Navigator.pop(context);
          },
        ).show();
      },
      btnCancelOnPress: (){

      }
    ).show();
  }


}