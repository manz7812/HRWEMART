import 'package:flutter/material.dart';

import '../../widjet/doc_Card.dart';

class EmployeeMangeTimePages extends StatefulWidget {
  const EmployeeMangeTimePages({Key? key}) : super(key: key);

  @override
  State<EmployeeMangeTimePages> createState() => _EmployeeMangeTimePagesState();
}

class _EmployeeMangeTimePagesState extends State<EmployeeMangeTimePages> {
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
        // appBar: AppBar(
        //   title: Text(widget.title),
        //   centerTitle: true,
        //   flexibleSpace : Container(
        //     decoration: const BoxDecoration(
        //       borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
        //       // border: Border.all(width: 15, color: Colors.white),
        //       gradient:  LinearGradient(
        //         colors: [
        //           Color(0xff6200EA),
        //           Colors.white,
        //         ],
        //         begin:  FractionalOffset(0.0, 1.0),
        //         end:  FractionalOffset(1.5, 1.5),
        //       ),
        //       // boxShadow: [
        //       //   BoxShadow(
        //       //     color: Colors.deepPurpleAccent,
        //       //     spreadRadius: 5, blurRadius: 30,
        //       //     offset: Offset(5, 3),
        //       //   ),
        //       // ],
        //       // image: DecorationImage(image: NetworkImage('https://www.pngitem.com/pimgs/m/391-3918613_personal-service-platform-person-icon-circle-png-transparent.png'))
        //     ),
        //   ),
        // ),
        body: loading ? SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 10,right: 10,top: 20,bottom: 10),
            child: Column(
              children: [
                const SizedBox(height: 20),
                doc_WORK().show_card_img(context),
                const SizedBox(height: 30),
                doc_WORK().show_doc_calendar_value_time(context),
                doc_WORK().show_doc_check_in_check_out(context),
                doc_WORK().show_doc_report_anomaly(context),
              ],
            ),
          ),
        )
            : const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
                strokeWidth: 5,)
          )
    );
  }
}
