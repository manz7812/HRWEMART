import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:http/http.dart';
import 'package:index/api/url.dart';
import 'package:index/api/wtsapi.dart';
import 'package:index/pages/drawer_page/drawer_index.dart';
import 'package:index/pages/loginV9/com_login.dart';
import 'package:index/pages/widjet/popupAlert.dart';
import 'package:index/pages/widjet/route.dart';
import 'package:index/pages/widjet/singout.dart';
import 'package:index/signup.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fade_animation.dart';
import 'main.dart';
import 'pages/widjet/myAlertLocation.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _passwordVisible = true;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  Future<Null> checkPref() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token') ?? "false";
    print(preferences.getString('token'));
    print(token);
    try{
      if(token == "false"){
        print("0");
        return;
      }
      String url = pathurl.urlprofile;
      final response = await get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
      print(response.statusCode);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
          if(data['data']['level'] == "บริหาร") {
            routeToService(CompanyLoginPage());
            // Future.delayed(const Duration(seconds: 1),(){
            //   // Navigator.push(context, MaterialPageRoute(builder: (context) => const MyDrawer()));
            //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            //       CompanyLoginPage()), (Route<dynamic> route) => false);
            // });
          }else{
            routeToService(MyDrawer());
            // Future.delayed(const Duration(seconds: 1),(){
            //   // Navigator.push(context, MaterialPageRoute(builder: (context) => const MyDrawer()));
            //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            //       MyDrawer()), (Route<dynamic> route) => false);
            // });
          }
      }else{
        signOut(context);
        // routeToService(MyApp());

        print('1');
      }
    }catch (e){
      print('2');
      signOut(context);
    }
  }

  void routeToService(Widget myWidget){
    MaterialPageRoute route = MaterialPageRoute(builder: (context) =>myWidget);
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Future<Null> login(String username, password) async{
    try{
      var response = await post(
          Uri.parse(pathurl.urllogin),
          body: {
            "username": username,
            "password": password
          }
      );
      var data = jsonDecode(response.body.toString());

      if(data["status"] == "success"){
        // print(data["status"]);
        // print(data["token"]);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("token",data["token"]);
        checktoken();
      }else{
        context.loaderOverlay.hide();
        MyDialog().alertLogin6(context);
      }
      // if(data["status"] == "success"){
      //   print(data);
      //   // print("seccess");
      //   // MyDialog().alertLogin2(context);
      //   // Future.delayed( Duration(seconds: 3),(){
      //   //   Navigator.pop(context);
      //     Navigator.push(context, MaterialPageRoute(builder: (context) => const MyDrawer()));
      //   // });
      //   // MyDialog().alertLogin2(context);
      // }else{
      //   print(data);
      //   print("unseccess");
      //   // MyDialog().alertLogin3(context);
      //   MyDialog().alertLogin4(context);
      // }

    }catch (e){
      context.loaderOverlay.hide();
      MyDialog().alertLogin7(context);
      print(e.toString());
    }
  }

  String token = "";
  Future<Null> checktoken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
    print(token);
    getdata();
  }


  Future<Null> getdata() async {
    try{
      String url = pathurl.urlprofile;
      final response = await get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          context.loaderOverlay.hide();
          MyDialog().alertLogin2(context);
          if(data['data']['level'] == "บริหาร") {
            Future.delayed(const Duration(seconds: 3),(){
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const MyDrawer()));
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  CompanyLoginPage()), (Route<dynamic> route) => false);
            });
          }else{
            Future.delayed(const Duration(seconds: 3),(){
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const MyDrawer()));
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  MyDrawer()), (Route<dynamic> route) => false);
            });
          }
        });
      }else{
        setState(() {
          print('1');
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
      print('2');
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

  void hiddenpassword(){
    setState((){
      _passwordVisible= !_passwordVisible;
    });
  }

  @override
  void initState() {
    checkPref();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: LoadingAnimationWidget.threeArchedCircle(
              color: Colors.deepPurpleAccent, size: 50),
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 10,right: 10,bottom: 15),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    // Colors.purple,
                    Colors.purple.shade600,
                    Colors.deepPurpleAccent,
                  ])),
          child: Column(
            children: [
              // Image.asset("images/hr1-re.png"),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child:  FadeAnimation(2,
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(26)),
                      // child: Image(
                      //   // image: AssetImage('images/wts-d-r.png'),
                      //   image: AssetImage('images/55841.png'),
                      //   width: 400,
                      //   height: 250,
                      //   // fit: BoxFit.contain,
                      // ),
                      child: LottieBuilder.network('https://assets7.lottiefiles.com/packages/lf20_bvjyzebm.json',
                        width: 270,
                        animate: true,
                      ),
                    )
                ),
              ),
              Expanded(
                child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        )),
                    margin: const EdgeInsets.only(top: 30),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _key,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              // color: Colors.red,
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.only(left: 22, bottom: 10),
                                child: const FadeAnimation(
                                  2,
                                  Text(
                                    "เข้าสู่ระบบ",
                                    style: TextStyle(
                                      fontSize: 35,
                                      color: Colors.black87,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                )),
                            FadeAnimation(
                              2,
                              Container(
                                  width: double.infinity,
                                  height: 70,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.transparent, width: 1),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.purpleAccent,
                                            blurRadius: 10,
                                            offset: Offset(1, 1)),
                                      ],
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.email_outlined),
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.only(left: 10),
                                          child: TextFormField(
                                            controller: username,
                                            autofocus: false,
                                            focusNode: FocusNode(),
                                            showCursor: true,
                                            // validator: (value) => (value!.isEmpty) ? '' : null,
                                            maxLines: 1,
                                            decoration: InputDecoration(
                                              // label: Text("Username"),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            FadeAnimation(
                              2,
                              Container(
                                  width: double.infinity,
                                  height: 70,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.transparent, width: 1),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.purpleAccent,
                                            blurRadius: 10,
                                            offset: Offset(1, 1)),
                                      ],
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.lock),
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.only(left: 10),
                                          child: TextFormField(
                                            autofocus: false,
                                            focusNode: FocusNode(),
                                            showCursor: true,
                                            controller: password,
                                            // validator: (value) => (value!.isEmpty) ? '' : null,
                                            obscureText: _passwordVisible,
                                            keyboardType: TextInputType.visiblePassword,
                                            maxLines: 1,
                                            decoration:  InputDecoration(
                                              // label: Text("Password"),
                                                border: InputBorder.none,
                                                suffixIcon: InkWell(
                                                    onTap: hiddenpassword,
                                                    child: Icon(
                                                        _passwordVisible
                                                            ? Ionicons.eye_off_outline : Ionicons.eye_outline
                                                    )
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            const SizedBox(
                              height: 0,
                            ),
                            FadeAnimation(
                              2,
                              Container(
                                padding: const EdgeInsets.all(20),
                                child: ElevatedButton(
                                  onPressed: () async{
                                    if(username.text !="" && password.text !=""){
                                      FocusScope.of(context).requestFocus(new FocusNode());
                                      context.loaderOverlay.show();
                                      Future.delayed(const Duration(seconds: 2),(){
                                        _key.currentState!.save();
                                        login(username.text.toString(), password.text.toString());
                                        username.clear();
                                        password.clear();
                                      });

                                      // print('สำเร็จ');
                                    }else{
                                      MyDialog().alertLogin5(context);
                                    }
                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => const MyDrawer()));

                                    // SweetAlert.show(
                                    //     context,
                                    //     title: "สำเร็จ",
                                    //     subtitle: "บันทึกข้อมูลเรียบร้อย",
                                    //     style: SweetAlertStyle.success);
                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => const MyDrawer()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      onPrimary: Colors.purpleAccent,
                                      shadowColor: Colors.purpleAccent,
                                      elevation: 18,
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20))),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                        gradient: const LinearGradient(colors: [
                                          Colors.purpleAccent,
                                          Colors.deepPurpleAccent
                                        ]),
                                        borderRadius: BorderRadius.circular(20)),
                                    child: Container(
                                      width: double.infinity,
                                      height: 50,
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'ตกลง',
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,

                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // FadeAnimation(
                            //   2,
                            //   TextButton(
                            //       onPressed: () {
                            //         Navigator.push(context, MaterialPageRoute(builder: (context) => const signup()));
                            //       },
                            //       child: const Text(
                            //         " ลงทะเบียน ",
                            //         style: TextStyle(
                            //           color: Colors.black54, fontSize: 15,),
                            //       )),
                            // ),
                          ],
                        ),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
