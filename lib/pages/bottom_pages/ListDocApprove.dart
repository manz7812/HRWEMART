import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'ApproveDoc/DocAddTime/List_Data_DocAddTime.dart';
import 'ApproveDoc/DocHuman/List_Data_DocHuman.dart';
import 'ApproveDoc/DocLa/List_Data_DocLa.dart';
import 'ApproveDoc/DocResign/List_Data_DocResign.dart';


class listDoc{
  Widget La(BuildContext context, int length, Function(dynamic value) onGoBack){
    return  Card(
        margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        child: Stack(
          children: [
            length ==0 ? Container() :
            Positioned(
              top: -2,left: 135,width: 25,
              child: CircleAvatar(
                backgroundColor: Colors.red,
                child: Text('${length}',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text("ขอลางาน"),
              // subtitle: Text("Lower the anchor."),
              leading: Icon(Icons.assignment_rounded,color: Colors.deepPurpleAccent,),
              trailing: Icon(Icons.arrow_forward_rounded,color: Colors.grey.shade600,),

              onTap: (){
                // Navigator.push(context, MaterialPageRoute(builder: (context) => const ListDataApproveDocLaPage())).then(onGoBack);
                Navigator.of(context).push(
                    PageTransition(
                      child: const ListDataApproveDocLaPage(),
                      type: PageTransitionType.rightToLeft,
                      alignment: Alignment.center,
                      duration: Duration(milliseconds: 600),
                      reverseDuration: Duration(milliseconds: 600),
                    )
                ).then(onGoBack);
                // Navigator.push(context, MaterialPageRoute(builder: (context) => const InsertDocLAPage()));
              },
            ),
          ],
        )
    );
  }

  Widget Human(BuildContext context, int length, Function(dynamic value) onGoBack){
    return  Card(
        margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        child: Stack(
          children: [
            length == 0 ? Container() :
            Positioned(
              top: -2,left: 150,width: 25,
              child: CircleAvatar(
                backgroundColor: Colors.red,
                child: Text('${length}',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text("ขอกำลังพล"),
              // subtitle: Text("Lower the anchor."),
              leading: Icon(Ionicons.man_outline,color: Colors.deepPurpleAccent,),
              trailing: Icon(Icons.arrow_forward_rounded,color: Colors.grey.shade600,),

              onTap: (){
                // Navigator.push(context, MaterialPageRoute(
                //     builder: (BuildContext context){
                //       return DetailDocHumanApprovePage();
                //     })
                // ).then(onGoBack);
                Navigator.of(context).push(
                    PageTransition(
                      child: DetailDocHumanApprovePage(),
                      type: PageTransitionType.rightToLeft,
                      alignment: Alignment.center,
                      duration: Duration(milliseconds: 600),
                      reverseDuration: Duration(milliseconds: 600),
                    )
                ).then(onGoBack);
                // Navigator.push(context, MaterialPageRoute(builder: (context) => const InsertDocLAPage()));
              },
            ),
          ],
        )
    );
  }

  Widget AddTime(BuildContext context, int length, Function(dynamic value) onGoBack){
    return  Card(
        margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        child: Stack(
          children: [
            length ==0 ? Container() :
            Positioned(
              top: -2,left: 150,width: 25,
              child: CircleAvatar(
                backgroundColor: Colors.red,
                child: Text('${length}',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text("ขอเพิ่มเวลา"),
              // subtitle: Text("Lower the anchor."),
              leading: Icon(Icons.more_time,color: Colors.deepPurpleAccent,),
              trailing: Icon(Icons.arrow_forward_rounded,color: Colors.grey.shade600,),

              onTap: (){
                Navigator.of(context).push(
                    PageTransition(
                      child: ListDataApproveDocAddTimePage(),
                      type: PageTransitionType.rightToLeft,
                      alignment: Alignment.center,
                      duration: Duration(milliseconds: 600),
                      reverseDuration: Duration(milliseconds: 600),
                    )
                ).then(onGoBack);
                // Navigator.push(context, MaterialPageRoute(builder: (context) => const InsertDocLAPage()));
              },
            ),
          ],
        )
    );
  }

  Widget Resign(BuildContext context, int length, Function(dynamic value) onGoBack){
    return  Card(
        margin: EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        child: Stack(
          children: [
            length ==0 ? Container() :
            Positioned(
              top: -2,left: 150,width: 25,
              child: CircleAvatar(
                backgroundColor: Colors.red,
                child: Text('${length}',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text("ขอลาออก"),
              // subtitle: Text("Lower the anchor."),
              leading: Icon(Icons.exit_to_app_outlined,color: Colors.deepPurpleAccent,),
              trailing: Icon(Icons.arrow_forward_rounded,color: Colors.grey.shade600,),

              onTap: (){
                Navigator.of(context).push(
                    PageTransition(
                      child: ListDataApproveDocResignPage(),
                      type: PageTransitionType.rightToLeft,
                      alignment: Alignment.center,
                      duration: Duration(milliseconds: 600),
                      reverseDuration: Duration(milliseconds: 600),
                    )
                ).then(onGoBack);
                // Navigator.push(context, MaterialPageRoute(builder: (context) => const InsertDocLAPage()));
              },
            ),
          ],
        )
    );
  }


}