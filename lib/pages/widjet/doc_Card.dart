import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import 'package:index/login.dart';
import 'package:index/pages/bottom_pages/DateTimePage/calendar_time_work.dart';
import 'package:index/pages/bottom_pages/DateTimePage/check_in_check_out.dart';
import 'package:index/pages/bottom_pages/DocAddTime/insert_AddTime.dart';
import 'package:index/pages/bottom_pages/DocKa/insert_Doc_ChangeKa.dart';
import 'package:index/pages/bottom_pages/DocHoliday/insert_Doc_ChangeHoliday.dart';
import 'package:index/pages/bottom_pages/DocOT/inser_OT.dart';
import 'package:index/pages/bottom_pages/DocResign/insert_Doc_Resign.dart';
import 'package:index/pages/bottom_pages/DocSalaryCer/insert_Doc_Salary_Certificate.dart';
import 'package:index/pages/bottom_pages/DocHuman/insert_Doc_Human.dart';
import 'package:index/pages/bottom_pages/DocWorkCer/insert_Doc_Work_Certificate.dart';
import 'package:index/pages/bottom_pages/DateTimePage/table_time_work.dart';
import 'package:index/pages/drawer_page/DrawPoliciCom/detail_companyPolicy.dart';
import 'package:index/pages/drawer_page/DrawSalary/drawer_sum_salary.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import '../bottom_pages/DateTimePage/calendar_value_time.dart';
import '../bottom_pages/DocCondition/insert_Doc_Condition.dart';
import '../bottom_pages/DocGoodMemory/insert_Doc_GoodMemory.dart';
import '../bottom_pages/DocLa/insert_Doc_La.dart';
import '../bottom_pages/DocWarning/insert_Doc_Warning.dart';
import '../drawer_page/DrawSearchEm/report/report_calendar.dart';


class doc_WORK{
  // Color primaryColor = Colors.deepPurpleAccent;
  Widget show_doc_La(BuildContext context){
    return  Card(
        margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        child: ListTile(
          title: Text("ขอลางาน"),
          // subtitle: Text("Lower the anchor."),
          leading: Icon(Icons.assignment_rounded,color: Colors.deepPurpleAccent,),
          trailing: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
          onTap: (){
            // Navigator.push(context, MaterialPageRoute(
            //     builder: (BuildContext context){
            //       return InsertDocLAPage();
            //     })
            // );
            Navigator.of(context).push(
                PageTransition(
                  child: const InsertDocLAPage(),
                  type: PageTransitionType.rightToLeft,
                  alignment: Alignment.center,
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                )
            );
            // Navigator.push(context, MaterialPageRoute(builder: (context) => const InsertDocLAPage()));
          },
        )
    );
  }

  Widget show_doc_change_Ka(BuildContext context){
    return  Card(
        margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        child: ListTile(
          title: Text("ขอเปลี่ยนกะทำงาน"),
          // subtitle: Text("Lower the anchor."),
          leading: Icon(Ionicons.calendar_outline,color: Colors.deepPurpleAccent,),
          trailing: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
          onTap: (){
            // Navigator.push(context, MaterialPageRoute(
            //     builder: (BuildContext context){
            //       return insertDocChangeKa();
            //     })
            // );

            Navigator.of(context).push(
                PageTransition(
                  child: const insertDocChangeKa(),
                  type: PageTransitionType.rightToLeft,
                  alignment: Alignment.center,
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                )
            );
          },
        )
    );
  }

  Widget show_doc_change_holiday(BuildContext context){
    return  Card(
        margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        child: ListTile(
          title: Text("ขอเปลี่ยนวันหยุด"),
          // subtitle: Text("Lower the anchor."),
          leading: Icon(Ionicons.calendar_number_outline,color: Colors.deepPurpleAccent,),
          trailing: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
          onTap: (){
            // Navigator.push(context, MaterialPageRoute(
            //     builder: (BuildContext context){
            //       return insertDocChangeHoliday();
            //     })
            // );

            Navigator.of(context).push(
                PageTransition(
                  child: const insertDocChangeHoliday(),
                  type: PageTransitionType.rightToLeft,
                  alignment: Alignment.center,
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                )
            );
          },
        )
    );
  }

  Widget show_doc_more_time(BuildContext context){
    return  Card(
        margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        child: ListTile(
          title: Text("ขอเพิ่มเวลา"),
          // subtitle: Text("Lower the anchor."),
          leading: Icon(Icons.query_builder_outlined,color: Colors.deepPurpleAccent,),
          trailing: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
          onTap: (){
            // Navigator.push(context, MaterialPageRoute(
            //     builder: (BuildContext context){
            //       return insertDocAddTime();
            //     })
            // );

            Navigator.of(context).push(
                PageTransition(
                  child: const insertDocAddTime(),
                  type: PageTransitionType.rightToLeft,
                  alignment: Alignment.center,
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                )
            );
          },
        )
    );
  }

  Widget show_doc_OT(BuildContext context){
    return  Card(
        margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        child: ListTile(
          title: Text("ขอโอที"),
          // subtitle: Text("Lower the anchor."),
          leading: Icon(Ionicons.hourglass_outline,color: Colors.deepPurpleAccent,),
          trailing: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
          onTap: (){
            // Navigator.push(context, MaterialPageRoute(
            //     builder: (BuildContext context){
            //       return insertDocOT();
            //     })
            // );
            Navigator.of(context).push(
                PageTransition(
                  child: const insertDocOT(),
                  type: PageTransitionType.rightToLeft,
                  alignment: Alignment.center,
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                )
            );
          },
        )
    );
  }

  Widget show_doc_Human(BuildContext context){
    return  Card(
        margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        child: ListTile(
          title: Text("ขออัตรากำลังพล"),
          // subtitle: Text("Lower the anchor."),
          leading: Icon(Ionicons.man_outline,color: Colors.deepPurpleAccent,),
          trailing: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
          onTap: (){
            // Navigator.push(context, MaterialPageRoute(
            //     builder: (BuildContext context){
            //       return InsertDocHumanPage();
            //     })
            // );
            Navigator.of(context).push(
                PageTransition(
                  child: const InsertDocHumanPage(),
                  type: PageTransitionType.rightToLeft,
                  alignment: Alignment.center,
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                )
            );
          },
        )
    );
  }

  Widget show_doc_Resign(BuildContext context){
    return  Card(
        margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        child: ListTile(
          title: Text("ขอลาออก"),
          // subtitle: Text("Lower the anchor."),
          leading: Icon(Ionicons.exit_outline,color: Colors.deepPurpleAccent,),
          trailing: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
          onTap: (){
            // Navigator.push(context, MaterialPageRoute(
            //     builder: (BuildContext context){
            //       return InsertDocResignPage();
            //     })
            // );
            Navigator.of(context).push(
                PageTransition(
                  child: const InsertDocResignPage(),
                  type: PageTransitionType.rightToLeft,
                  alignment: Alignment.center,
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                )
            );
          },
        )
    );
  }

  Widget show_doc_GoodMemoryCard(BuildContext context){
    return  Card(
        margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        child: ListTile(
          title: Text("บันทึกความดี"),
          // subtitle: Text("Lower the anchor."),
          leading: Icon(Ionicons.book_outline,color: Colors.deepPurpleAccent,),
          trailing: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
          onTap: (){
            // Navigator.push(context, MaterialPageRoute(
            //     builder: (BuildContext context){
            //       return InsertDocResignPage();
            //     })
            // );
            Navigator.of(context).push(
                PageTransition(
                  child: const InsertDocGoodMemoryPage(),
                  type: PageTransitionType.rightToLeft,
                  alignment: Alignment.center,
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                )
            );
          },
        )
    );
  }

  Widget show_doc_pre_salary(BuildContext context){
    return  Card(
        margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        child: ListTile(
          title: Text("ขอเบิกล่วงหน้า"),
          // subtitle: Text("Lower the anchor."),
          leading: Icon(Icons.paid_rounded,color: Colors.deepPurpleAccent,),
          trailing: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
          onTap: (){
            print('Card Clicked');
          },
        )
    );
  }

  Widget show_doc_request_salary_certificate(BuildContext context){
    return  Card(
        margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        child: ListTile(
          title: Text("หนังสือรับรองเงินเดือน"),
          // subtitle: Text("Lower the anchor."),
          leading: Icon(Icons.verified_user_outlined,color: Colors.deepPurpleAccent,),
          trailing: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
          onTap: (){
            // Navigator.push(context, MaterialPageRoute(
            //     builder: (BuildContext context){
            //       return insertDocSalaryCertificate();
            //     })
            // );
            Navigator.of(context).push(
                PageTransition(
                  child: const insertDocSalaryCertificate(),
                  type: PageTransitionType.rightToLeft,
                  alignment: Alignment.center,
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                )
            );
          },
        )
    );
  }

  Widget show_doc_request_reimbursement_welfare(BuildContext context){
    return  Card(
        margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        child: ListTile(
          title: Text("ขอเอกเบิกสวัสดิการ"),
          // subtitle: Text("Lower the anchor."),
          leading: Icon(Icons.request_quote_outlined,color: Colors.deepPurpleAccent,),
          trailing: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
          onTap: (){
            // Navigator.push(context, MaterialPageRoute(
            //     builder: (BuildContext context){
            //       return insertDocOT();
            //     })
            // );
          },
        )
    );
  }

  Widget show_doc_warning(BuildContext context){
    return  Card(
        margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        child: ListTile(
          title: Text("หนังสือเตือน"),
          // subtitle: Text("Lower the anchor."),
          leading: Icon(Icons.warning_amber_rounded,color: Colors.deepPurpleAccent,),
          trailing: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
          onTap: (){
            Navigator.of(context).push(
                PageTransition(
                  child: const InsertDocWarningPage(),
                  type: PageTransitionType.rightToLeft,
                  alignment: Alignment.center,
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                )
            );
          },
        )
    );
  }

  Widget show_doc_change_condition(BuildContext context){
    return  Card(
        margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        child: ListTile(
          title: Text("ใบแจ้งเปลี่ยนสภาพการจ้างพนักงาน"),
          // subtitle: Text("Lower the anchor."),
          leading: Icon(Icons.change_circle_outlined,color: Colors.deepPurpleAccent,),
          trailing: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
          onTap: (){
            Navigator.of(context).push(
                PageTransition(
                  child: const InsertDocConditionPage(),
                  type: PageTransitionType.rightToLeft,
                  alignment: Alignment.center,
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                )
            );
          },
        )
    );
  }



  Widget show_doc_work_certificate(BuildContext context){
    return  Card(
        margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        child: ListTile(
          title: Text("หนังสือรับรองการทำงาน"),
          // subtitle: Text("Lower the anchor."),
          leading: Icon(Icons.workspace_premium_rounded,color: Colors.deepPurpleAccent,),
          trailing: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
          onTap: (){
            // Navigator.push(context, MaterialPageRoute(
            //     builder: (BuildContext context){
            //       return insertDocWorkCertificate();
            //     })
            // );
            Navigator.of(context).push(
                PageTransition(
                  child: const insertDocWorkCertificate(),
                  type: PageTransitionType.rightToLeft,
                  alignment: Alignment.center,
                  duration: Duration(milliseconds: 600),
                  reverseDuration: Duration(milliseconds: 600),
                )
            );
          },
        )
    );
  }

  Widget show_doc_calendar_value_time(BuildContext context){
    return  Card(
        margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        child: ListTile(
          title: Text("ปฎิทินข้อมูลสรุปเวลา"),
          // subtitle: Text("Lower the anchor."),
          leading: Icon(Ionicons.calendar_number_outline,color: Colors.deepPurpleAccent,),
          trailing: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context){
                  return CalendarValueTimePage();
                })
            );
          },
        )
    );
  }

  Widget show_doc_check_in_check_out(BuildContext context){
    return  Card(
        margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        child: ListTile(
          title: Text("เวลาเข้าออกประจำวัน"),
          // subtitle: Text("Lower the anchor."),
          leading: Icon(IcoFontIcons.people,color: Colors.deepPurpleAccent,),
          trailing: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context){
                  return CheckInCheckOutToDayTimePage();
                })
            );
          },
        )
    );
  }

  Widget show_doc_table_time_work(BuildContext context){
    return  Card(
        margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        child: ListTile(
          title: Text("ตารางเวลาการทำงาน"),
          // subtitle: Text("Lower the anchor."),
          leading: Icon(IcoFontIcons.bagAlt,color: Colors.deepPurpleAccent,),
          trailing: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context){
                  return TableTimeWorkPage();
                })
            );
          },
        )
    );
  }

  Widget show_doc_carlendar_time_work(BuildContext context){
    return  Card(
        margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        child: ListTile(
          title: Text("ปฎิทินสรุปเวลาการทำงาน"),
          // subtitle: Text("Lower the anchor."),
          leading: Icon(IcoFontIcons.uiCalendar,color: Colors.deepPurpleAccent,),
          trailing: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
          onTap: (){
            showModalBottomSheet(
                elevation: 50,
                enableDrag: true,
                isDismissible: true,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                context: context, builder: (context) => CalendarTimeWorkPage()
            );
            // Navigator.push(context, MaterialPageRoute(
            //     builder: (BuildContext context){
            //       return CalendarTimeWorkPage();
            //     })
            // );
          },
        )
    );
  }

  Widget show_card_img(BuildContext context){
    var url = "https://assets2.lottiefiles.com/packages/lf20_kvsp4zlb.json";
    return  Card(
        margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        child: Container(
          padding: EdgeInsets.all(15),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Container( 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ข้อมูล",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.black),),
                      Text("การจัดการเวลา",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.black),),
                    ],
                  ),
                ),
              ),
              // SvgPicture.asset(
              //   'images/spinner.svg',
              //   width: 130.0,
              //   height: 130.0,
              // ),
              LottieBuilder.network(url,
                width: 200,
                animate: true,
              ),

            ],
          ),
        )
    );
  }

  Widget show_card_img2(BuildContext context, DateTime now, List dataCalendarToday){
    var url = "https://assets6.lottiefiles.com/packages/lf20_eIXuIz.json";
    var datenow = DateFormat("dd/MM/yyyy").format(now);
    var dateTHN = DateFormat.d('th').format(now);
    var dateTHM = DateFormat.yMMMMEEEEd('th').format(now).split(" ")[2];
    var dateTHY = DateFormat.yMMMMEEEEd('th').format(now).split(" ")[4];
    var ka;
    var idka;
    var date;
    var curendate;
    if(dataCalendarToday[0]['event'] == "วันทำงาน"){
       ka = dataCalendarToday[0]['description'].split("\n");
       date = dataCalendarToday[0]['date'].split("-");
       curendate = "${date[2]}-${date[1]}-${date[0]}";
       idka = "${ka[1].split(" ")[1].replaceAll('[', '').replaceAll(']','')}";
    }else{
      idka = "";
      date = dataCalendarToday[0]['date'].split("-");
      curendate = "${date[2]}-${date[1]}-${date[0]}";
    }

    return  InkWell(
      // onTap: (){
      //   showModalBottomSheet(
      //       elevation: 0,
      //       enableDrag: true,
      //       isDismissible: true,
      //       isScrollControlled: true,
      //       backgroundColor: Colors.transparent,
      //       context: context,
      //       // builder: (context) => CalendarTimeWorkPage()
      //       builder: (context) => CalendarTimeWorkPage(),
      //       // transitionAnimationController: _controller
      //   );
      // },
      child: Card(
          margin: EdgeInsets.all(10),
          clipBehavior: Clip.antiAlias,
          elevation: 20,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          child: Container(
            padding: EdgeInsets.all(15),
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("ปฎิทิน",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.black),),
                          Text("สรุปเวลา",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.black),),
                        ],
                      ),
                    ),
                    // SvgPicture.asset(
                    //   'images/time-management.svg',
                    //   width: 130.0,
                    //   height: 130.0,
                    // ),
                    LottieBuilder.network(url,
                      width: 200,
                      animate: true,
                    )
                  ],
                ),
                const SizedBox(height: 30,),
                Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            // color: Colors.blue,
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(dateTHN.toString().length >1
                                    ?"${dateTHN}"
                                    : "0${dateTHN}",
                                  style: TextStyle(fontSize: 40,fontWeight: FontWeight.w700,color: Colors.red.shade600),),
                                Text("${dateTHM}",style: TextStyle(fontSize: 18),),
                                const SizedBox(height: 5),
                                IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Text("${dateTHY} ",style: TextStyle(fontSize: 18),),
                                        const VerticalDivider(
                                          width: 10,
                                          thickness: 1,
                                          indent: 3,
                                          endIndent: 5,
                                          color: Colors.black87,
                                        ),
                                        Text(" ${int.parse(dateTHY)+543}",style: TextStyle(fontSize: 18),),
                                      ],
                                    )),

                              ],
                            ),
                          ),
                          // const SizedBox(width: 20,),
                          const VerticalDivider(
                            width: 10,
                            thickness: 1,
                            color: Colors.black87,
                          ),
                          Container(
                            // width: double.infinity,
                            // color: Colors.blue,
                            padding: EdgeInsets.fromLTRB(0, 15, 10, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("วันที่ : $curendate"),
                                Text("กะ : $idka"),
                                Text("เวลา : ${dataCalendarToday[0]['title']}"),
                                Text("สถานะ : ${dataCalendarToday[0]['event']}"),
                              ],
                            ),
                          )
                        ],
                      ),
                    )

                  ],
                )
              ],
            ),
          )
      ),
    );
  }

  Widget show_card_img_salary(BuildContext context){
    return  Card(
        // margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
        ),
        child: Container(
          padding: EdgeInsets.only(left: 15,top: 30,right: 15,bottom: 30),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ข้อมูลการจัดการ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.black),),
                      Text("เงินเดือน",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.black),),
                    ],
                  ),
                ),
              ),
              // LottieBuilder.network('https://assets8.lottiefiles.com/packages/lf20_OdVhgq.json',
              //   width: 200,
              //   animate: true,
              // ),
              LottieBuilder.network('https://assets8.lottiefiles.com/packages/lf20_dsokakuq.json',
                width: 200,
                animate: true,
              )
              // Image(
              //   // image: AssetImage('images/wts-d-r.png'),
              //   image: AssetImage('images/salary.jpg'),
              //   width: 200,
              //   // height: 250,
              //   fit: BoxFit.contain,
              // ),
            ],
          ),
        )
    );
  }

  Widget show_doc_salary(BuildContext context){
    return  Card(
        margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        child: ListTile(
          title: Text("สลิปเงินเดือน"),
          // subtitle: Text("Lower the anchor."),
          leading: Icon(IcoFontIcons.money,color: Colors.deepPurpleAccent,),
          trailing: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context){
                  return SumSalaryPage();
                })
            );
          },
        )
    );
  }

  Widget show_doc_report_anomaly(BuildContext context){
    return  Card(
        margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        child: ListTile(
          title: Text("รายงานความผิดปกติ"),
          // subtitle: Text("Lower the anchor."),
          leading: Icon(IcoFontIcons.documentFolder,color: Colors.deepPurpleAccent,),
          trailing: Icon(Icons.arrow_forward_rounded,color: Colors.black,),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context){
                  return ReportAnomalyCalendarPage();
                })
            );
          },
        )
    );
  }

}


class nayoby{
  Widget show_nayoby1(BuildContext context){
    return  Card(
        // margin: EdgeInsets.all(10),
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3)
        ),
        child: ListTile(
          title: Text("มาตราโควิด-19"),
          // subtitle: Text("Lower the anchor."),
          // leading: Icon(Icons.assignment_rounded,color: Colors.deepPurpleAccent,),
          trailing: Icon(Icons.arrow_forward_ios_outlined,color: Colors.black,),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context){
                  return DetailCompanyPolicyPage();
                })
            );
            // Navigator.push(context, MaterialPageRoute(builder: (context) => const InsertDocLAPage()));
          },
        )
    );
  }

}

