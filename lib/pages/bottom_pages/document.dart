import 'package:flutter/material.dart';
import 'package:index/fade_animation.dart';
import 'package:index/pages/widjet/doc_Card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  final Function? onGoBack;
  const SearchPage({Key? key,this.onGoBack}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  onGoBack(dynamic value) {
    setState(() {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => super.widget));
    });
  }

  String level = "";
  Future<Null> checklevel() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    level = preferences.getString("level")!;
    print(level);
  }

  bool loading = false;

  @override
  void initState() {
    checklevel();
    Future.delayed(const Duration(seconds: 1),(){
      setState(() {
        loading = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text("ขอเอกสาร"),
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
            child: Column(
              children: <Widget>[
                level == "พนักงานปฎิบัติการ"
                ? Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(top: 10, left: 15.0, bottom: 0.0),
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "เอกสารส่งหัวหน้างาน",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      FadeAnimation(
                        0.3, doc_WORK().show_doc_Human(context),
                      ),
                      FadeAnimation(
                          0.6, doc_WORK().show_doc_La(context)
                      ),
                      FadeAnimation(
                        0.9, doc_WORK().show_doc_more_time(context),
                      ),
                      FadeAnimation(
                        1.2, doc_WORK().show_doc_Resign(context),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10, left: 15.0, bottom: 0.0),
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "เอกสารส่งฝ่ายบุคคล",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      FadeAnimation(
                        1.5, doc_WORK().show_doc_request_salary_certificate(context),
                      ),
                      // doc_WORK().show_doc_request_reimbursement_welfare(context),
                      FadeAnimation(
                        1.8, doc_WORK().show_doc_work_certificate(context),
                      ),
                      const SizedBox(height: 80,)
                    ],
                )
                : Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(top: 10, left: 15.0, bottom: 0.0),
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "เอกสารส่งหัวหน้างาน",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      FadeAnimation(
                        0.3, doc_WORK().show_doc_Human(context),
                      ),
                      FadeAnimation(
                          0.6, doc_WORK().show_doc_La(context)
                      ),
                      FadeAnimation(
                        0.9, doc_WORK().show_doc_more_time(context),
                      ),
                      FadeAnimation(
                        1.2, doc_WORK().show_doc_Resign(context),
                      ),
                      FadeAnimation(
                        1.5, doc_WORK().show_doc_change_Ka(context),
                      ),
                      FadeAnimation(
                        1.8, doc_WORK().show_doc_change_holiday(context),
                      ),
                      FadeAnimation(
                        2.1, doc_WORK().show_doc_OT(context),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10, left: 15.0, bottom: 0.0),
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "เอกสารส่งฝ่ายบุคคล",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      FadeAnimation(
                        2.4, doc_WORK().show_doc_request_salary_certificate(context),
                      ),
                      // doc_WORK().show_doc_request_reimbursement_welfare(context),
                      FadeAnimation(
                        2.4, doc_WORK().show_doc_work_certificate(context),
                      ),
                      FadeAnimation(
                        2.6, doc_WORK().show_doc_warning(context),
                      ),
                      FadeAnimation(
                        2.8, doc_WORK().show_doc_change_condition(context),
                      ),
                      FadeAnimation(
                        3.0, doc_WORK().show_doc_GoodMemoryCard(context),
                      ),
                      const SizedBox(height: 80,)
                    ],
                ),

              ],
            ),
      )
          : const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
              strokeWidth: 5,
            )
        )
    );
  }
}