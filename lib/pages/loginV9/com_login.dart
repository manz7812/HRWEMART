import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:index/api/url.dart';
import 'package:index/pages/drawer_page/drawer_index.dart';
import 'package:index/pages/widjet/popupAlert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widjet/singout.dart';

class CompanyLoginPage extends StatefulWidget {
  const CompanyLoginPage({Key? key}) : super(key: key);

  @override
  State<CompanyLoginPage> createState() => _CompanyLoginPageState();
}

class _CompanyLoginPageState extends State<CompanyLoginPage> {
  List company = [];
  bool loading = false;

  // final numbers = List.generate(10, (index) => '$index');
  final controller = ScrollController();

  Future<Null> getdata() async {
    try{
      String url = pathurl.urlcom;
      final response = await get(
          Uri.parse(url),
          // headers: {"Authorization": "Bearer $token"}
      );
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          company = data['data'];
          print(company);
        });
      }else if(response.statusCode == 401){
        company = [];
        popup().sessionexpire(context);
      }else{
        setState(() {
          AwesomeDialog(
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
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => super.widget));
            },
          ).show();
        });
      }
    }catch (e){
      AwesomeDialog(
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
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => super.widget));
        },
      ).show();
    }
  }

  @override
  void initState() {
    getdata();
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
        elevation: 0,
        title: Text('หน้าหลัก'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              signOut(context);
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
            // border: Border.all(width: 15, color: Colors.white),
            gradient: LinearGradient(
              colors: [
                Color(0xff6200EA),
                Colors.white,
              ],
              begin: FractionalOffset(0.0, 1.0),
              end: FractionalOffset(1.5, 1.5),
            ),
            // image: DecorationImage(image: NetworkImage('https://www.pngitem.com/pimgs/m/391-3918613_personal-service-platform-person-icon-circle-png-transparent.png'))
          ),
        ),
      ),
      body: loading && company.length >0 ? Container(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: buildGridView()
      ) :const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
            strokeWidth: 5,
          )
      ),
    );
  }

  Widget buildGridView() => GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 1,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,

    ),
    padding: const EdgeInsets.all(5),
    controller: controller,
    itemCount: company.length,
    itemBuilder: (context, i) {
      return LisCom(company[i]);
    },
  );

  Widget LisCom(item) {
    var img = item['img_logo'];
    var id = item['id'];
    return InkWell(
      onTap: () async{
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("com_id",id);
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyDrawer()));
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        // child: Column(
        //   children: [
        //     Stack(
        //       children: [
        //         Ink.image(
        //           image: NetworkImage(img),
        //           height: 100,
        //           fit: BoxFit.cover,
        //         ),
        //         Positioned(
        //           bottom: 16,
        //           right: 16,
        //           left: 16,
        //           child: Text(
        //             'Cats rule the world!',
        //             style: TextStyle(
        //               fontWeight: FontWeight.bold,
        //               color: Colors.white,
        //               fontSize: 24,
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
        child: Center(
          child: Image.network(
            img,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

}
