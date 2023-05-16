import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:index/api/notificationApi.dart';
import 'package:index/api/url.dart';
import 'package:index/pages/bottom_pages/DocHoliday/Doc_ChangeHoliday.dart';
import 'package:index/pages/bottom_pages/HomePage/dataToDay.dart';
import 'package:index/pages/drawer_page/DrawNews/drawer_newsPublic_detail.dart';
import 'package:index/pages/widjet/popupAlert.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../../api/notification_service.dart';
import '../drawer_page/drawer_index.dart';
import '../drawer_page/drawer_index2.dart';
import '../drawer_page/drawer_menu.dart';
import '../loginV9/com_login.dart';
import 'DateTimePage/table_time_work.dart';
import 'dart:developer' as developer;

import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'myScore.dart';



class ProfilePage2 extends StatefulWidget {
  const ProfilePage2({Key? key,}) : super(key: key);

  @override
  _ProfilePage2State createState() => _ProfilePage2State();
}

class _ProfilePage2State extends State<ProfilePage2> with SingleTickerProviderStateMixin{
  var log = Logger(
    printer: PrettyPrinter(
        methodCount: 2,
        lineLength: 120,
        errorMethodCount: 8,
        colors: true,
        printEmojis: false,
    ),
  );

   bool loading = false;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
   PickedFile? _imageFile;
   File? selectedImage;
   final ImagePicker _picker = ImagePicker();
    Widget? mywidget;
   List company = [];
   final controller = ScrollController();
   late AnimationController _controller;

  void pickImage(ImageSource source) async{
    final pickedFile = await _picker.getImage(source: source);

    setState(() {
      _imageFile = pickedFile!;
    });
  }

   Future getImage() async {
     var image = await ImagePicker().pickImage(source: ImageSource.camera);

     setState(() {
       selectedImage = File(image!.path); // won't have any error now
     });
   }

   String comid = "";
   Future<Null> getComid() async{
     SharedPreferences preferences = await SharedPreferences.getInstance();
     if(preferences.getString("com_id") == null){
       comid = "false";
       // debugPrint(comid);
       // log.i(comid);
       // print(comid);
     }else{
       comid = preferences.getString("com_id")!;
       print(comid);
     }

   }

   String token = "";
   Future<Null> getToken() async{
     SharedPreferences preferences = await SharedPreferences.getInstance();
     token = preferences.getString("token")!;
     getdata();
     getdataTime();
     // print(token);
   }

   // var name = TextEditingController();
   List dataP = [];
   Future<Null> getdata() async{
     try{
       dataP = [];
       final String url = pathurl.urlprofile;
       final response = await get(
           Uri.parse(url),
           headers: {"Authorization": "Bearer $token"}
       );
       // print(response.statusCode);
       var data = jsonDecode(response.body.toString());
       if(response.statusCode == 200){
         setState(() {
           _refreshController.refreshCompleted();
           dataP.add(data["data"]);
           // print(dataP.length);
           // log.i(dataP);
           // developer.log('$dataP', name: 'ข้อมูลพนักงาน');
         });
       }else if(response.statusCode == 401){
         popup().sessionexpire(context);
       }

     }catch(e){

     }
   }

   String comName = "";
   Future<Null> getcom() async {
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

           for (var i = 0; i < company.length; i++){
             if(company[i]['id'] ==  comid){
               comName = company[i]['name'];
             }
           }
           // print(childrenCom);
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
               Navigator.of(context).pushReplacement(
                   PageTransition(
                     child: mywidget!,
                     type: PageTransitionType.fade,
                     alignment: Alignment.bottomCenter,
                     duration: Duration(milliseconds: 600),
                     reverseDuration: Duration(milliseconds: 600),
                   )
               );
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
           Navigator.of(context).pushReplacement(
               PageTransition(
                 child: mywidget!,
                 type: PageTransitionType.fade,
                 alignment: Alignment.bottomCenter,
                 duration: Duration(milliseconds: 600),
                 reverseDuration: Duration(milliseconds: 600),
               )
           );
         },
       ).show();
     }
   }

   List InOut = [];
   Future<Null> getdataTime() async{
     try{
       final String url = pathurl.timeINOUT;
       final response = await get(
           Uri.parse(url),
           headers: {"Authorization": "Bearer $token"}
       );
       var data = jsonDecode(response.body.toString());
       if(response.statusCode == 200){
         setState(() {
           InOut.add(data["data"]);
           // log.i(dataP);
           // developer.log('$dataP', name: 'ข้อมูลพนักงาน');
         });
       }
     }catch(e){

     }
   }


  void socketIO() {
     Socket socket = io('http://103.82.248.220:5000',
        OptionBuilder().setTransports(['websocket']).disableAutoConnect().setExtraHeaders({'foo': 'bar'}).build()
    );
    socket.connect();
    socket.onConnect((_) {
      print('connect: ${socket.id}');
      socket.emit('msg', {
        'token': token,
        // 'message':"test"
      });
    });

     socket.on('msg',(data) {
       print('msg: ${data}');
       NotificationApi.showNotification(
         id: 1,
         title: '${data['title']}',
         body: '${data['message']}',
         // playload: 'a111',
       );
     });

     socket.onConnectError((_) => print('connect error'));
     socket.onConnectTimeout((_) => print('timeout'));
     socket.onError((_) => print('error'));
     socket.onDisconnect((_) => print('disconnect'));

  }


  String _deviceId = "";
  Future<void> initPlatformState() async {
    String? deviceId;
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }
    setState(() {
      _deviceId = deviceId!;
      print("deviceId->$_deviceId");
    });
  }


   @override
  void initState() {
     Future.delayed(const Duration(seconds: 1),(){
       setState(() {
         loading = true;
         if(dataP[0]['level'] == "พนักงานปฎิบัติการ"){
           mywidget = const MyDrawer2();
         }else{
           mywidget = const MyDrawer();
         }
       });
     });
     // finddatauser();
     getToken();
     getcom();
     getComid();


     // NotificationApi.init();
     // socketIO();
     // NotificationService().initialize();

     _controller = AnimationController(
       vsync: this, // the SingleTickerProviderStateMixin
       duration: Duration(seconds: 1),
       animationBehavior: AnimationBehavior.normal,
     );


    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  // void listenNotification()=>NotificationApi.onNotification.stream.listen((event) { });
  // void onClickNotification(String? payload)=>

  // Future<void> initSocket() async{
  //    socket = IO.
  // }


  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    Intl.defaultLocale = 'th';
    var now = DateTime.now();
    // var toShow = now.yearInBuddhistCalendar;
    var dateth = DateFormat.yMMMMEEEEd().format(now);
    var formatter = DateFormat.yMMMMEEEEd();
    var datetimeTH = dateth.split('ค.ศ.');
    var DTN = datetimeTH[1].split(' ');


    return Scaffold(
      appBar: AppBar(
        title: const Text("หน้าหลัก"),
        centerTitle: true,
        elevation: 0,
        shadowColor: Colors.transparent,
        actions: [
          // Container(
          //   padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          //   child: InkWell(
          //     onTap: (){
          //       Navigator.push(context, MaterialPageRoute(
          //           builder: (BuildContext context){
          //             return EmployeeTimePage(title: 'ลงเวลางาน');
          //           })
          //       );
          //     },
          //     child: LottieBuilder.network('https://assets3.lottiefiles.com/temp/lf20_HXh4T7.json',
          //       // https://assets5.lottiefiles.com/packages/lf20_tmyg7clb.json
          //       width: 40,
          //       // height: 80,
          //       animate: true,
          //       // repeat: true,
          //     ),
          //   ),
          // ),
          // IconButton(
          //   icon: const Icon(Icons.fingerprint_sharp),
          //   onPressed: () {
          //     Navigator.push(context, MaterialPageRoute(
          //         builder: (BuildContext context){
          //           return EmployeeTimePage(title: 'ลงเวลางาน');
          //       })
          //     );
          //   },
          // ),
          // IconButton(
          //   icon: const Icon(Icons.web_asset_outlined),
          //   onPressed: () {
          //     Navigator.push(context, MaterialPageRoute(
          //         builder: (BuildContext context){
          //           return WebCheckINChecKOutPage();
          //         })
          //     );
          //   },
          // ),
        ],
        flexibleSpace : Container(
          decoration: const BoxDecoration(
            // borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
            // border: Border.all(width: 15, color: Colors.white),
            gradient:  LinearGradient(
              colors: [
                Color(0xff6200EA),
                Colors.white,
              ],
              begin:  FractionalOffset(0.0, 1.0),
              end:  FractionalOffset(1.5, 1.5),
            ),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.deepPurpleAccent,
            //     spreadRadius: 5, blurRadius: 30,
            //     offset: Offset(5, 3),
            //   ),
            // ],
            // image: DecorationImage(image: NetworkImage('https://www.pngitem.com/pimgs/m/391-3918613_personal-service-platform-person-icon-circle-png-transparent.png'))
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade300,
      extendBody: true,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   // title: const Text('My App'),
      //   flexibleSpace: Container(
      //     child:  Column(
      //       children: [
      //         ListView(
      //           shrinkWrap: true,
      //           padding: const EdgeInsets.only(top: 100,left: 60),
      //           children: const [
      //             Text("ธีรภัทร์ เจริญวงค์ (แมน)",style: TextStyle(fontSize: 18,color: Colors.white),),
      //             Text("ตำแหน่ง: IT Support",style: TextStyle(fontSize: 18,color: Colors.white),),
      //             Text("โทร: 086-9497812",style: TextStyle(fontSize: 18,color: Colors.white),),
      //             Text("อีเมล: Theeraphad2541@gmail.com",style: TextStyle(fontSize: 18,color: Colors.white),),
      //           ],
      //         )
      //       ],
      //     ),
      //     decoration: const BoxDecoration(
      //       gradient:  LinearGradient(
      //           colors: [
      //           Color(0xff6200EA),
      //           Colors.white,
      //         ],
      //         begin:  FractionalOffset(0.0, 1.0),
      //         end:  FractionalOffset(1.5, 1.5),
      //       ), borderRadius: BorderRadius.vertical(bottom: Radius.circular(30),)
      //     ),
      //   ),
      //   toolbarHeight:MediaQuery.of(context).size.height/5,
      //   // shape: const RoundedRectangleBorder(
      //   //   borderRadius: BorderRadius.vertical(
      //   //     bottom: Radius.circular(30),
      //   //   ),
      //   // ),
      // ),
      body: loading && dataP.length > 0 ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height/6.5,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                  // borderRadius: BorderRadius.only(
                  //   bottomRight: Radius.circular(70.0),
                  // ),
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
                      color: Colors.deepPurpleAccent,
                      spreadRadius: 1, blurRadius: 15,
                      // offset: Offset(5, 3),
                    ),
                  ],
                  // image: DecorationImage(image: NetworkImage('https://www.pngitem.com/pimgs/m/391-3918613_personal-service-platform-person-icon-circle-png-transparent.png'))
                ),
                    child:  Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 15),
                              // margin: const EdgeInsets.symmetric(
                              //   vertical: 30,horizontal: 0,
                              // ),
                              child: CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.grey.shade400,
                                child: ClipOval(
                                    // child: Center(
                                    //   child: _imageFile == null
                                    //   ? Icon(
                                    //       Icons.person,
                                    //       color: Colors.grey.shade800,
                                    //       size: 50,
                                    //   ) : Image.file(
                                    //     File(_imageFile!.path),
                                    //     fit: BoxFit.cover,
                                    //     width: MediaQuery.of(context).size.width,
                                    //   ),
                                    // )
                                  child: Center(
                                    child: dataP[0]['img_url'] != ""
                                        ? Image.network(dataP[0]['img_url'])
                                        : Image.asset("images/avatars.png"),
                                  ),
                                ),
                                // backgroundImage: _imageFile == null
                                //     ? AssetImage("")
                                //     : FileImage(File(_imageFile!.path)) as ImageProvider,
                              ),
                            ),

                            // Positioned(
                            //     top: 45,left: 43,width: 25,
                            //     child: RawMaterialButton(
                            //       // elevation: 10,
                            //       fillColor: Colors.grey.shade300,
                            //       child: Icon(Ionicons.camera_outline,size: 18,),
                            //       // padding: EdgeInsets.all(10),
                            //       shape: CircleBorder(),
                            //       onPressed: (){
                            //         AwesomeDialog(
                            //           context: context,
                            //           // dismissOnTouchOutside: false,
                            //           // padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
                            //           dialogType: DialogType.NO_HEADER,
                            //           body: Container(
                            //             padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                            //             child: Row(
                            //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //               crossAxisAlignment: CrossAxisAlignment.center,
                            //               children: [
                            //                 Ink(
                            //                   child:IconButton(
                            //                     icon: Icon(Ionicons.camera_outline),
                            //                     color: Colors.black87,
                            //                     iconSize: 50,
                            //                     splashRadius: 40,
                            //                     disabledColor: Colors.grey,
                            //                     onPressed: () {
                            //                       pickImage(ImageSource.camera);
                            //                     },
                            //                   ),
                            //                   // decoration: ShapeDecoration(
                            //                   //     color: Colors.grey,
                            //                   //     shape: OutlineInputBorder()
                            //                   // ),
                            //                 ),
                            //                 Ink(
                            //                   child:IconButton(
                            //                     icon: Icon(Ionicons.image_outline),
                            //                     color: Colors.black87,
                            //                     iconSize: 50,
                            //                     splashRadius: 40,
                            //                     disabledColor: Colors.grey,
                            //                     onPressed: () {
                            //                       pickImage(ImageSource.gallery);
                            //                     },
                            //                   ),
                            //                   // decoration: ShapeDecoration(
                            //                   //     color: Colors.grey,
                            //                   //     shape: OutlineInputBorder()
                            //                   // ),
                            //                 )
                            //               ],
                            //             ),
                            //           ),
                            //           // keyboardAware: false,
                            //           // dialogBackgroundColor: Colors.orange,
                            //           borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
                            //           width: 300,
                            //           buttonsBorderRadius: BorderRadius.all(Radius.circular(5)),
                            //           headerAnimationLoop: false,
                            //           animType: AnimType.SCALE,
                            //           autoHide: Duration(seconds: 5),
                            //           // dialogBackgroundColor: Colors.deepPurpleAccent,
                            //           // title: 'คุณอยู่นอกรัศมีที่กำหนด',
                            //           // desc: 'กรุณาอยู่ในพื้นที่ บริษัท วิรัชทุ่งสงค้าข้าว จำกัด',
                            //         ).show();
                            //       },
                            //     )),
                          ],
                        ),
                        // Column(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Padding(padding: const EdgeInsets.only(top: 10,left: 10),
                        //       child: Image.asset('images/2.jpg',width: 60,)
                        //     ),
                        //   ],
                        // ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, bottom: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                                 Text(dataP.length == 0 ? "" :
                                   "${dataP[0]['name'].toString().split(' ')[1]}"
                                       " ${dataP[0]['name'].toString().split(' ')[2]}"
                                       " (${dataP[0]['nick_name']})",
                                   style: TextStyle(fontSize: 16,color: Colors.white),),
                                 Text(dataP.length == 0 ? "" :
                                   "ตำแหน่ง: ${dataP[0]['position']['pos_name']}",
                                   style: TextStyle(fontSize: 16,color: Colors.white),),
                                 Text(dataP.length == 0 ? "" :
                                   "โทร: ${dataP[0]['tel']}",
                                   style: TextStyle(fontSize: 16,color: Colors.white),),
                                 Text(dataP.length == 0 ? "" :
                                   "อีเมล: ${dataP[0]['email']}",
                                   style: TextStyle(fontSize: 16,color: Colors.white),),

                                // RatingBar.builder(
                                //   initialRating: 5,
                                //   minRating: 1,
                                //   // direction: Axis.horizontal,
                                //   allowHalfRating: true,
                                //   itemCount: 5,
                                //   itemSize: 20,
                                //   // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                //   itemBuilder: (context, _) => Icon(
                                //     Icons.star,
                                //     color: Colors.amber,
                                //
                                //   ),
                                //   onRatingUpdate: (rating) {
                                //     print(rating);
                                //   },
                                // ),
                                // RatingBarIndicator(
                                //   rating: 5,
                                //   itemBuilder: (context, index) => Icon(
                                //     Icons.star,
                                //     color: Colors.amber,
                                //   ),
                                //   itemCount: 5,
                                //   itemSize: 20.0,
                                //   // direction: Axis.vertical,
                                // ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),

              ),
              Positioned(
                top: 95,
                left: 10,
                child: GestureDetector(
                  onTap: (){
                    showModalBottomSheet(
                        elevation: 0,
                        enableDrag: true,
                        isDismissible: true,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        // builder: (context) => CalendarTimeWorkPage()
                        builder: (context) => MyScorePage(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0)
                          ),
                        ),
                        transitionAnimationController: _controller
                    );
                  },
                  child: RatingBarIndicator(
                      rating: 5,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 15.0,
                      // direction: Axis.vertical,
                    ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Expanded(
              child: SmartRefresher(
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
                  print(dataP[0]['level']);

                  Navigator.of(context).pushReplacement(
                      PageTransition(
                        child: mywidget!,
                        type: PageTransitionType.fade,
                        alignment: Alignment.bottomCenter,
                        duration: Duration(milliseconds: 600),
                        reverseDuration: Duration(milliseconds: 600),
                      )
                  );
                  // getToken();
                },
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Column(
                    children: [
                      dataP[0]['level'] == 'บริหาร' ?
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                              alignment: Alignment.topLeft,
                              child: comName == null ? Text("บริษัท"): Text(
                                comName ,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),

                            ),
                            Card(
                              child: Container(
                                // alignment: Alignment.center,
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        for (var i=0; i < company.length; i++)
                                          Row(
                                            children: [
                                              if(i % 3 == 0)
                                                // Text(company[i]['id']),
                                              Card(
                                                elevation: 3,
                                                clipBehavior: Clip.antiAlias,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Image.network(
                                                  company[i]['img_logo']??"http://103.82.248.220/node/api/v1/avatars/F9/avatars.png",
                                                  width: 100,
                                                  height: 90,
                                                ),
                                              )
                                            ],
                                          ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        for (var i=0; i < company.length; i++)
                                          Row(
                                            children: [
                                              if(i % 3 == 1)
                                                // Text(company[i]['id']),
                                              Card(
                                                elevation: 3,
                                                clipBehavior: Clip.antiAlias,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Image.network(
                                                  company[i]['img_logo']??"http://103.82.248.220/node/api/v1/avatars/F9/avatars.png",
                                                  width: 100,
                                                  height: 90,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            ],
                                          ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        for (var i=0; i < company.length; i++)
                                          Row(
                                            children: [
                                              if(i % 3 == 2)
                                                // Text(company[i]['id']),
                                              Card(
                                                elevation: 3,
                                                clipBehavior: Clip.antiAlias,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Image.network(
                                                  company[i]['img_logo']??"http://103.82.248.220/node/api/v1/avatars/F9/avatars.png",
                                                  width: 100,
                                                  height: 90,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            ],
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // color: Colors.grey.shade300,
                              elevation: 3,
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(color: Colors.transparent)
                              ),
                            ),
                          ],
                        ),
                      ) : Container(),

                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                                  alignment: Alignment.topLeft,
                                  child:  Text(
                                    "ข้อมูลประจำวัน",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: (){
                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => const DataToDayPage()));
                                    Navigator.of(context).push(
                                        PageTransition(
                                          child: DataToDayPage(),
                                          type: PageTransitionType.fade,
                                          alignment: Alignment.bottomCenter,
                                          duration: Duration(milliseconds: 600),
                                          reverseDuration: Duration(milliseconds: 600),
                                        )
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 8.0, right: 6, bottom: 4.0),
                                    alignment: Alignment.topLeft,
                                    child: const Text(
                                      "ดูเพิ่มเติม",
                                      style: TextStyle(
                                        color: Colors.black,
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: (){
                                // Navigator.push(context, MaterialPageRoute(builder: (context) =>  MainNavigation()));
                              },
                              child: Card(
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('${datetimeTH[0]}${DTN[1]}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.deepPurpleAccent,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('${InOut[0]['event']}',
                                            style:  TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Text('',
                                            style:  TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10,),
                                      IntrinsicHeight(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children:  [
                                                Text("เวลาเข้างาน",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.deepPurpleAccent,
                                                    // fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 5,),
                                                Text('${InOut[0]['time_in']}',
                                                  style:  TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.red,
                                                    // fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const VerticalDivider(
                                              width: 20,
                                              thickness: 1,
                                              color: Colors.grey,
                                            ),
                                            Column(
                                              children:  [
                                                Text("เวลาออกงาน",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.deepPurpleAccent,
                                                    // fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 5,),
                                                Text("${InOut[0]['time_out']}",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.red,
                                                    // fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],),
                                      )
                                    ],
                                  ),
                                ),
                                elevation: 3,
                                shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(color: Colors.white)
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      // const SizedBox(height: 0,),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                              alignment: Alignment.topLeft,
                              child: const Text(
                                "คำแนะนำ",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const ClampingScrollPhysics(),
                              child: Row(
                                children: [
                                  Card(
                                    child: Column(
                                      children: [
                                        Container(
                                          // width: double.infinity,
                                          width: 363,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 50),
                                          child: const Text(
                                            "วันที่ 06/02/2022 ตรวจพบว่าคุณได้มาทำงานในวันหยุด เพื่อประโยชน์สูงสุดของคุณ เราจึงแนะนำให้...",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Row(
                                          // crossAxisAlignment: CrossAxisAlignment.center,
                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            // const Spacer(),
                                            const SizedBox(width: 50),
                                            Expanded(
                                              flex: 0,
                                              child: Container(
                                                width: 100,
                                                // width: double.infinity,
                                                // padding: const EdgeInsets.only(right: 16, left: 16),
                                                // margin: EdgeInsets.all(10),
                                                // alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  // border: Border.all(
                                                  //     color: Colors.grey.shade500
                                                  // ),
                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                                child: TextButton(
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: Colors.deepPurpleAccent,
                                                      primary: Colors.white,
                                                      // minimumSize: Size(width, 100),
                                                    ),
                                                    onPressed: (){
                                                      // Navigator.push(context, MaterialPageRoute(
                                                      //     builder: (BuildContext context){
                                                      //       return DocOTPage();
                                                      //     })
                                                      // );

                                                        // NotificationApi.showNotification(
                                                        //   id: 3,
                                                        //   title: 'hello world',
                                                        //   body: 'test',
                                                        //   playload: 'a111',
                                                        // );
                                                        // NotificationService().imageNotification();
                                                    },
                                                    child: Text('ขอโอที')),
                                              ),
                                            ),
                                            const SizedBox(width: 10,),
                                            Expanded(
                                              flex: 0,
                                              child: Container(
                                                width: 100,
                                                // width: double.infinity,
                                                // padding: const EdgeInsets.only(right: 16, left: 16),
                                                // margin: EdgeInsets.all(10),
                                                // alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  // border: Border.all(
                                                  //     color: Colors.grey.shade500
                                                  // ),
                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                                child: TextButton(
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: Colors.green,
                                                      primary: Colors.white,
                                                      // minimumSize: Size(width, 100),
                                                    ),
                                                    onPressed: (){
                                                      Navigator.push(context, MaterialPageRoute(
                                                          builder: (BuildContext context){
                                                            return DocChangeHolidayPage();
                                                          })
                                                      );
                                                    },
                                                    child: Text('เปลี่ยนวันหยุด')),
                                              ),
                                            ),
                                            const SizedBox(width: 50),
                                          ],
                                        ),
                                        const SizedBox(height: 20,),
                                      ],
                                    ),
                                    elevation: 3,
                                    shape: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(color: Colors.white)
                                    ),
                                  ),
                                  Card(
                                    child: Column(
                                      children: [
                                        Container(
                                          // width: double.infinity,
                                          width: 363,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 50),
                                          child: const Text(
                                            "วันที่ 06/02/2022 ตรวจพบว่าคุณได้มาทำงานในวันหยุด เพื่อประโยชน์สูงสุดของคุณ เราจึงแนะนำให้...",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Row(
                                          // crossAxisAlignment: CrossAxisAlignment.center,
                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            // const Spacer(),
                                            const SizedBox(width: 50),
                                            Expanded(
                                              flex: 0,
                                              child: Container(
                                                width: 100,
                                                // width: double.infinity,
                                                // padding: const EdgeInsets.only(right: 16, left: 16),
                                                // margin: EdgeInsets.all(10),
                                                // alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  // border: Border.all(
                                                  //     color: Colors.grey.shade500
                                                  // ),
                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                                child: TextButton(
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: Colors.deepPurpleAccent,
                                                      primary: Colors.white,
                                                      // minimumSize: Size(width, 100),
                                                    ),
                                                    onPressed: (){

                                                    },
                                                    child: Text('ขอโอที')),
                                              ),
                                            ),
                                            const SizedBox(width: 10,),
                                            Expanded(
                                              flex: 0,
                                              child: Container(
                                                width: 100,
                                                // width: double.infinity,
                                                // padding: const EdgeInsets.only(right: 16, left: 16),
                                                // margin: EdgeInsets.all(10),
                                                // alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  // border: Border.all(
                                                  //     color: Colors.grey.shade500
                                                  // ),
                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                                child: TextButton(
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: Colors.green,
                                                      primary: Colors.white,
                                                      // minimumSize: Size(width, 100),
                                                    ),
                                                    onPressed: (){},
                                                    child: Text('เปลี่ยนวันหยุด')),
                                              ),
                                            ),
                                            const SizedBox(width: 50),
                                          ],
                                        ),
                                        const SizedBox(height: 20,),
                                      ],
                                    ),
                                    elevation: 3,
                                    shape: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(color: Colors.white)
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                              alignment: Alignment.topLeft,
                              child: const Text(
                                "ประกาศข่าวสาร",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailNewsPublicPage()));
                                    },
                                    child: Card(
                                      child: Container(
                                        width: 363,
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
                                        child: Row(
                                          children: [
                                            Image(
                                              image: AssetImage('images/55841.png'),
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.contain,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "วันหยุดสงกรานต์",
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 20,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  Text(
                                                    "หยุด 3วัน วันที่ 13-15 เมษายน 2565",
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 16,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      elevation: 3,
                                      shape: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: const BorderSide(color: Colors.white)
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailNewsPublicPage()));
                                    },
                                    child: Card(
                                      child: Container(
                                        width: 363,
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
                                        child: Row(
                                          children: [
                                            Image(
                                              image: AssetImage('images/55841.png'),
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.contain,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "วันหยุดสงกรานต์",
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 16,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  Text(
                                                    "หยุด 3วัน วันที่ 13-15 เมษายน 2565",
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 16,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      elevation: 3,
                                      shape: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          borderSide: const BorderSide(color: Colors.white)
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ),
          const SizedBox(height: 50)
        ],
      )
          : const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
              strokeWidth: 5,
            )
       )
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
     // controller: controller,
     itemCount: company.length,
     itemBuilder: (context, i) {
       return LisCom(company[i]);
     },
   );

   Widget LisCom(item) {
     var img = item['img_logo'];
     var id = item['id'];
     return InkWell(
       onTap: (){
         Navigator.push(context, MaterialPageRoute(builder: (context) => const MyDrawer()));
       },
       child: Center(
         child: Image.network(
           img,
           fit: BoxFit.cover,
         ),
       ),
     );
   }
}
