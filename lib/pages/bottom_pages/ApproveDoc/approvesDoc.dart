import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:index/api/docToMe_model.dart';
import 'package:index/api/url.dart';
import 'package:index/fade_animation.dart';
import 'package:index/pages/bottom_pages/ListDocApprove.dart';
import 'package:index/pages/widjet/doc_Card_to_ME.dart';
import 'package:index/pages/widjet/popupAlert.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListApproveDocPage extends StatefulWidget {
  final Function? onGoBack;
  const ListApproveDocPage({Key? key,this.onGoBack}) : super(key: key);

  @override
  State<ListApproveDocPage> createState() => _ListApproveDocPageState();
}

class _ListApproveDocPageState extends State<ListApproveDocPage> {
  onGoBack(dynamic value) {
    getToken();
  }
  bool loading = false;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<DocToMeModel> DocList = DocToMeModel.list;

  String token = "";
  Future<Null> getToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
    await getdataDocHuman();
    await getdataDocLa();
    // print(token);
  }

  List dataApproveDocHuman = [];
  Future<Null> getdataDocHuman() async{
    try{
      setState(() {
        loading = false;
      });
      final String url = pathurl.urldataApprove+'?status=รออนุมัติ';
      final response = await get(
          Uri.parse(url),
          headers: {"Authorization": "Bearer $token"}
      );
      var data = jsonDecode(response.body.toString());
      if(response.statusCode == 200){
        setState(() {
          loading = true;
          dataApproveDocHuman = data["data"];
          _refreshController.refreshCompleted();
          print(dataApproveDocHuman.length);
        });
      }else if(response.statusCode == 401){
        popup().sessionexpire(context);
      }
    }catch(e){

    }
  }

  List dataApproveDocLa = [];
  Future<Null> getdataDocLa() async{
    setState(() {
      loading = false;
    });

    var df = DateFormat('yyyy').format(DateTime.now());
    final String url = pathurl.dataApproveDocLa+"?status=รออนุมัติ&year=$df&month=00";
    final response = await get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
      setState(() {
        loading = true;
        // employeeModel = EmployeeModel.fromJson(data["data"]);
        // dataApprove.add(data["data"]);
        dataApproveDocLa = data["data"];
        _refreshController.refreshCompleted();
        print(dataApproveDocLa.length);
      });
    }
  }

  String level = "";
  Future<Null> checklevel() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    level = preferences.getString("level")!;
    print(level);
  }

  int noti = 1;


  @override
  void initState() {
    getToken();
    checklevel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: level == "พนักงานปฎิบัติการ" ? const Text("เอกสารถึงฉัน") : const Text("เอกสารอนุมัติ"),
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
      body: loading ? SmartRefresher(
        header: ClassicHeader(
          refreshStyle: RefreshStyle.Follow,
          releaseText: '',
          refreshingText: 'กรุณารอสักครู่...',
          completeText: 'โหลดข้อมูลสำเร็จ',
          idleText: '',
          idleIcon: null,
          refreshingIcon: LoadingAnimationWidget.discreteCircle(
              color: Colors.deepPurpleAccent,
              secondRingColor: Colors.white,
              thirdRingColor: Colors.deepPurpleAccent,
              size: 30),
          // refreshingIcon: Icon(Icons.refresh),
        ),
        controller: _refreshController,
        onRefresh: () async{
          await Future.delayed(Duration(milliseconds: 1000));
          getToken();
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              level == "พนักงานปฎิบัติการ"
              ? Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 20, left: 15.0, bottom: 0.0),
                    alignment: Alignment.topLeft,
                    child: const Text(
                      "เอกสารถึงฉัน",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  FadeAnimation(
                      0.5, docToMe.change_Ka(context)
                  ),
                  FadeAnimation(
                      1.0, docToMe.change_holiday(context),
                  ),
                  FadeAnimation(
                      1.5, docToMe.doc_OT(context),
                  ),
                  FadeAnimation(
                      2.0, docToMe.doc_warning(context),
                  ),
                  FadeAnimation(
                      2.5, docToMe.doc_change_condition(context),
                  ),
                  FadeAnimation(
                    3.0, docToMe.doc_to_me(context),
                  ),
                  // LottieBuilder.network(
                  //   "https://assets8.lottiefiles.com/packages/lf20_eh0ib2m7.json",
                  //   width: 100,
                  //   animate: true,
                  //   repeat: false,
                  //   fit: BoxFit.fitWidth,
                  // ),
                ],
              )
              : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 10, left: 15.0, bottom: 0.0),
                    alignment: Alignment.topLeft,
                    child: const Text(
                      "เอกสารอนุมัติ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  FadeAnimation(
                    0.5, listDoc().Human(context,dataApproveDocHuman.length,onGoBack),
                  ),
                  FadeAnimation(
                    1.0, listDoc().La(context,dataApproveDocLa.length,onGoBack),
                  ),
                  FadeAnimation(
                    1.5, listDoc().AddTime(context,0,onGoBack),
                  ),
                  FadeAnimation(
                    2.0, listDoc().Resign(context,0,onGoBack),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 30, left: 15.0, bottom: 0.0),
                    alignment: Alignment.topLeft,
                    child: const Text(
                      "เอกสารถึงฉัน",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  FadeAnimation(
                      2.5, docToMe.change_Ka(context)
                  ),
                  FadeAnimation(
                    3.0, docToMe.change_holiday(context),
                  ),
                  FadeAnimation(
                    3.5, docToMe.doc_OT(context),
                  ),
                  FadeAnimation(
                    4.0, docToMe.doc_warning(context),
                  ),
                  FadeAnimation(
                    4.5, docToMe.doc_change_condition(context),
                  ),
                  FadeAnimation(
                    5.0, docToMe.doc_to_me(context),
                  ),

                ],
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ) : const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
            strokeWidth: 5,
          )
      ),
    );
  }

  Widget buildGrid(){
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      padding: const EdgeInsets.all(5),
      controller: ScrollController(),
      shrinkWrap: true,

      itemCount: DocList.length,
      itemBuilder: (context, i) {
        return FadeAnimation(
          DocList[i].delay, Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: (){
              DocList[i].onPressed;
              setState(() {
                noti=0;
              });
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 5
            ),
            child: Container(
              padding: EdgeInsets.all(10),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  noti == 0
                      ?Icon(DocList[i].icon,color: DocList[i].color,size: 40,)
                      :Badge(
                    position: BadgePosition.topEnd(
                        top: -7, end: -5
                    ),
                    toAnimate: true,
                    badgeContent: Text("${noti}",style: TextStyle(color: Colors.white),),
                    child: Icon(DocList[i].icon,color: DocList[i].color,size: 40,),
                  ),
                  const SizedBox(height: 10,),
                  Text("${DocList[i].name}",textAlign: TextAlign.center,style: TextStyle(color: DocList[i].color,fontSize: 20),),
                ],
              ),
            ),
          ),
        ),
        );
        // return Text("${shoeList[i].imgPath}");
      },
    );
  }

}
