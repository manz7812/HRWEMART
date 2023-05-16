import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:index/api/utils.dart';
import 'package:index/loading.dart';
import 'package:index/login2.dart';
import 'package:index/pages/bottom_pages/ApproveDoc/DocLa/List_Data_DocLa.dart';
import 'package:index/pages/drawer_page/drawer_index.dart';
import 'package:index/pages/drawer_page/drawer_index2.dart';
import 'package:index/pages/loginV9/com_login.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(myBG);
  // debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp( MyApp());
}

Future<void> myBG(RemoteMessage message)async{
  await Firebase.initializeApp();
  print("RUN_BG");
  return _showNotification(message);
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future _showNotification(RemoteMessage message) async{
   AndroidNotificationChannel channel = const AndroidNotificationChannel(
       "id",
       "Message",
     description: 'description',
     importance: Importance.max,
   );

   await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

   RemoteNotification? data = message.notification;

   AndroidNotification? android = message.notification?.android;


   print("data = ${data?.toMap()}");

   if(data != null){
     if(data.android?.imageUrl != ""){
       final largePic = await Utils.downloadFile("${data.android?.imageUrl}", "largeIcon");
       final bigPic = await Utils.downloadFile("${data.android?.imageUrl}", "bigPicture");
       final styleInformation = BigPictureStyleInformation(
         FilePathAndroidBitmap(bigPic),
         largeIcon: FilePathAndroidBitmap(largePic),
         // contentTitle: "Demo image notification",
         // summaryText: "This is some text",
         // htmlFormatContent: true,
         // htmlFormatContentTitle: true
       );
       flutterLocalNotificationsPlugin.show(0,
           data.title,
           data.body,
           NotificationDetails(
               android: AndroidNotificationDetails(
                   channel.id,
                   channel.name,
                   channelDescription: channel.description,
                   setAsGroupSummary: true,
                   largeIcon: FilePathAndroidBitmap(largePic),
                   styleInformation: styleInformation
               ),
               iOS: const IOSNotificationDetails(presentAlert: true,presentSound: true)
           ),
           payload: "playload12345"
       );
     }else{
       flutterLocalNotificationsPlugin.show(0,
           data.title,
           data.body,
           NotificationDetails(
               android: AndroidNotificationDetails(
                   channel.id,
                   channel.name,
                   channelDescription: channel.description,
                   setAsGroupSummary: true,
                   // styleInformation: styleInformation
               ),
               iOS: const IOSNotificationDetails(presentAlert: true,presentSound: true)
           ),
           payload: "playload12315"
       );
     }
   }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String token = "";
  String level = "";
  bool login = false;
  bool loading = true;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String fcmToken = "";

  Widget? myWidget;
  Future<Null> checktoken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token") ?? "false";
    level = preferences.getString("level") ?? "false";
    print("level = ${preferences.getString("level") ?? "false"}");
    if(token != "false" && level != "false"){
      await Future.delayed(const Duration(seconds: 3),(){
        setState(() {
          login = true;
          loading = false;

          if(level == "พนักงานปฎิบัติการ"){
            myWidget = MyDrawer2();
          }else if(level == "บริหาร"){
            myWidget = CompanyLoginPage();
          }else{
            myWidget = MyDrawer();
          }
        });
      });

    }else{
      print("123");
      setState(() {
        loading = false;
      });
    }
  }

  Future<dynamic>onSelectNotification(payload) async {
    print("onSelec = ${payload}");
    Navigator.push(context, MaterialPageRoute(builder: (context) =>  ListDataApproveDocLaPage()));
  }

  Future initAndroid() async{
    var android = const AndroidInitializationSettings("@mipmap/ic_launcher");
    const IOSInitializationSettings iosInitializationSetting = IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: android,
      iOS: iosInitializationSetting
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: onSelectNotification);

    FirebaseMessaging.onMessage.listen((message) {
      _showNotification(message);
    });

  }

  // getFCMToken() async{
  //   _firebaseMessaging.deleteToken().whenComplete(() async{
  //     // String? token = await _firebaseMessaging.getToken();
  //     print("success");
  //   });
  //   String? token = await _firebaseMessaging.getToken();
  //   fcmToken = token!;
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   preferences.setString("fcmtoken",fcmToken);
  //   print("FCM = ${fcmToken}");
  // }

  requestPremissionIOS() async{
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print("permossion success");
    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print("no permossion");
    }else{
      print("not permossion");
    }

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true
    );
  }

  @override
  void initState() {
    checktoken();
    requestPremissionIOS();
    initAndroid();
    // reToken();
    // _firebaseMessaging.onTokenRefresh.listen((token) async {
    //   final prefs = await SharedPreferences.getInstance();
    //   final String TokenPre = 'fcmtoken';
    //   final String? currentToken = prefs.getString(TokenPre);
    //   if (currentToken != token) {
    //     print('token refresh: ' + token);
    //     // add code here to do something with the updated token
    //     // await prefs.setString(TokenPre, token);
    //   }
    // });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Prompt',
      ),
      // home: AnimatedSplashScreen(
      //   splash: 'images/78.jpg',
      //       splashTransition: SplashTransition.fadeTransition,
      //       duration: 500,
      //       backgroundColor: Colors.white,
      //       nextScreen: const Home(),
      // ),
      home: login ? myWidget : loading ? LoadingPage() : LoginPage(),
    );
  }
}



