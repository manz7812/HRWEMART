// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:basics/date_time_basics.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_font_icons/flutter_font_icons.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http ;
// import 'package:http/http.dart';
// import 'package:http_parser/http_parser.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:index/api/model_employee.dart';
// import 'package:index/pages/widjet/myAlertLocation.dart';
// import 'package:index/tflite/classifier.dart';
// import 'package:index/tflite/classifier_float.dart';
// import 'package:index/tflite/classifier_quant.dart';
// import 'package:intl/intl.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:logger/logger.dart';
// import 'package:lottie/lottie.dart' hide Marker;
// import 'package:image/image.dart' as img;
// import 'dart:math';
//
//
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
//
// class EmployeeTimePage extends StatefulWidget {
//
//   final String title;
//   EmployeeTimePage({Key? key, required this.title}) : super(key: key);
//
//   @override
//   _EmployeeTimePageState createState() => _EmployeeTimePageState();
// }
//
// class _EmployeeTimePageState extends State<EmployeeTimePage> {
//   // LatLng latLng = const LatLng(8.166038894896127, 99.65489290972046);
//   double? lat, lng;
//   bool loading = false;
//   bool onbtn = true;
//   late GoogleMapController _mapController;
//   // double distanceInMeters = 0;
//   double radius = 100;
//   late String _timeString;
//   late String _dateString;
//   late String time = "16:16";
//   DateTime timenow = DateTime.now();
//
//   late DateTime startTimeCheckIn;
//   late DateTime endTimeCheckOut;
//
//   String? distance;
//   late Timer _timer;
//   late Timer _currenDate;
//
//   File? file;
//
//   double LatWiratTH = 8.165981822672897;
//   double LngWiratTH = 99.65492855358653;
//
//
//   ////tflite////
//   Classifier? _classifier;
//   var logger = Logger();
//   File? _image;
//   final picker = ImagePicker();
//   Image? _imageWidget;
//   img.Image? fox;
//   Category? category;
//
//
//
//   Future<void> _getTime() async {
//     final DateTime now = DateTime.now();
//     final String formattedDateTime = _formatTime(now);
//     setState(() {
//       _timeString = formattedDateTime;
//     });
//   }
//
//   void checkTimeout() {
//     var nows = DateTime.now();
//     final _StartInH = 08;
//     final _StartInM = 00;
//     final start = DateTime(nows.year, nows.month, nows.day, _StartInH, _StartInM);
//
//     // String diff = calculateTimeDifferenceBetween(startDate: start, endDate: nows);
//     // print('สาย: $diff');
//     var newtime = nows - start;
//     // int diffs = nows.difference(start).inSeconds;
//     // print('สาย: $newtime');
//     // print("สาย: ${DateFormat.Hm().format(DateFormat("HH:mm").parse('$newtime'))}" );
//
//     var timetext = DateFormat.Hm().format(DateFormat("HH:mm").parse('$newtime'));
//     print('สาย: $timetext');
//     var parts = timetext.split(' ');
//     print('1: $parts');
//     var partss = parts[0].split(':');
//     print('2: ${partss}');
//     var lasttimediff;
//     if (partss[0] == "00") {
//       lasttimediff = "สาย: ${partss[1]} น.";
//       print(lasttimediff);
//     } else {
//       lasttimediff = "สาย: ${partss[0]}ชม. ${partss[1]}น.";
//       // MyDialog().alerchecklocation(context);
//       print(lasttimediff);
//     }
//
//     //   // print("สาย: $diff");
//     // }else{
//     //
//     // }
//     // var newtime = nows - start;
//     // Duration diff = nows.difference(start);
//     // getTime(diff);
//     // print("สาย: $diff");
//
//     // endTimeCheckOut = DateTime(now.year,now.month,now.day,_EndOutH,_EndOutM);
//     // print("เวลาออกงาน: $endTimeCheckOut");
//     //
//     // if(now > endTimeCheckOut){
//     //   print('เช็คเอ้าสำเร็จ');
//     // }else{
//     //   print('เช็คเอ้าไม่สำเร็จ');
//     // }
//   }
//
//   static String calculateTimeDifferenceBetween(
//       {required DateTime startDate, required DateTime endDate}) {
//     int seconds = endDate.difference(startDate).inSeconds;
//     if (seconds <= 60)
//       return '$seconds วินาที';
//     else if (seconds >= 60 && seconds < 3600)
//       return '${endDate.difference(startDate).inMinutes.abs()} นาที';
//     else if (seconds >= 3600 && seconds < 86400)
//       return '${endDate.difference(startDate).inHours} ชั่วโมง';
//     else
//       return '${endDate.difference(startDate).inDays} วัน';
//   }
//
//   String _formatTime(DateTime dateTime) {
//     return DateFormat('HH:mm:ss').format(dateTime);
//   }
//
//   Future<Null> checkPermission() async {
//     bool locationService;
//     LocationPermission locationPermission;
//
//     locationService = await Geolocator.isLocationServiceEnabled();
//     if (locationService) {
//       // print('เปิดโลเคชั่นแล้ว');
//       locationPermission = await Geolocator.checkPermission();
//       if (locationPermission == LocationPermission.denied) {
//         locationPermission = await Geolocator.requestPermission();
//         if (locationPermission == LocationPermission.deniedForever) {
//           MyDialog().alertLocationService3(context);
//         } else {
//           findLatLng();
//         }
//       } else {
//         if (locationPermission == LocationPermission.deniedForever) {
//           MyDialog().alertLocationService3(context);
//         } else {
//           findLatLng();
//         }
//       }
//     } else {
//       print('โลเคชั่นปิดอยู่');
//       MyDialog().alertLocationService3(context);
//       // MyDialog().alertLocationService2(context);
//       // MyDialog().alertLocationService(context);
//     }
//   }
//
//   Future<Null> findLatLng() async {
//     Position? position = await findPostion();
//     setState(() {
//       lat = position!.latitude;
//       lng = position.longitude;
//       print('ละติจูด =$lat, ลองติจูด = $lng');
//     });
//   }
//
//   Future<Position?> findPostion() async {
//     Position position;
//     try {
//       position = await Geolocator.getCurrentPosition();
//       return position;
//     } catch (e) {
//       return null;
//     }
//   }
//
//   Set<Marker> myMarker() {
//     return <Marker>{
//       // Marker(
//       //   markerId: const MarkerId('Office'),
//       //   position: LatLng(8.16596989474988, 99.65491614182471),
//       //   infoWindow: InfoWindow(
//       //     title: 'บริษัท วิรัชทุ่งสงค้าข้าว จำกัด',
//       //     snippet: 'ละติจูด = $lat, ลองติจูด = $lng',
//       //   ),
//       // ),
//       Marker(
//         markerId: const MarkerId('2'),
//         position: LatLng(lat!, lng!),
//         infoWindow: InfoWindow(
//           title: 'ตำแหน่งของคุณ',
//           snippet: 'ละติจูด = $lat, ลองติจูด = $lng',
//         ),
//       ),
//     };
//   }
//
//   Set<Circle> circles() {
//     return <Circle>{
//       Circle(
//         circleId: CircleId('1'),
//         center: LatLng(LatWiratTH, LngWiratTH),
//         radius: radius,
//         fillColor: Color.fromRGBO(149, 0, 255, 0.10196078431372549),
//         strokeColor: Colors.transparent,
//       ),
//     };
//   }
//
//   double calculateDistance(lat1, lon1, lat2, lon2) {
//     var p = 0.017453292519943295;
//     var c = cos;
//     var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p)
//         * (1 - c((lon2 - lon1) * p)) / 2;
//     return 12742 * asin(sqrt(a));
//   }
//
//   Future<Null> selecImg(ImageSource source) async {
//     try {
//       var result = await ImagePicker().pickImage(
//         source: source,
//         // maxHeight: 500,
//         // maxWidth: 800,
//       );
//       setState(() {
//         file = File(result!.path);
//       });
//     } catch (e) {
//       print("Don't Select Img");
//     }
//   }
//
//
//   Future<double> checklocation() async {
//     var datetimenow = DateTime.now();
//     var dateth = DateFormat.yMMMd().format(datetimenow);
//     // var datetimeTH = dateth.split('ค.ศ.');
//     // var DTN = datetimeTH[1].split(' ');
//     String url = "http://103.82.248.220:8000/${employeeModel!.id}";
//     String uri = "http://a8a6-110-78-146-193.ngrok.io/${employeeModel!.id}";
//
//     Random random = Random();
//     int i = random.nextInt(1000000);
//     String nameIMG = 'wemart$i';
//
//     Position _currentUserPosition;
//     _currentUserPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     double distanceInMeters = await Geolocator.distanceBetween(
//       LatWiratTH,LngWiratTH,
//       _currentUserPosition.latitude,
//       _currentUserPosition.longitude,
//     );
//     // var MyDistance = NumberFormat('##.0#', 'en_US');
//     // distance = MyDistance.format(distanceInMeters);
//     // print(distance);
//     print(distanceInMeters);
//     // if(distanceInMeters < radius){
//     //   var request = http.MultipartRequest('POST',
//     //       Uri.parse(uri)
//     //   );
//     //   request.files.add(await http.MultipartFile.fromPath('image',
//     //       _image!.path)
//     //   );
//     //
//     //   var streamedResponse = await request.send();
//     //   var response = await streamedResponse.stream.bytesToString();
//     //
//     //   var data = jsonDecode(response.toString());
//     //   print(data);
//     //   if(data["status"] == "success"){
//     //     context.loaderOverlay.hide();
//     //     print(data["status"]);
//     //     AwesomeDialog(
//     //       context: context,
//     //       dismissOnTouchOutside: false,
//     //       dialogType: DialogType.SUCCES,
//     //       // dialogBackgroundColor: Colors.orange,
//     //       borderSide: const BorderSide(color: Colors.green, width: 2),
//     //       width: 500,
//     //       buttonsBorderRadius: BorderRadius.all(Radius.circular(10)),
//     //       headerAnimationLoop: false,
//     //       animType: AnimType.SCALE,
//     //       // autoHide: Duration(seconds: 2),
//     //       // dialogBackgroundColor: Colors.deepPurpleAccent,
//     //       title: 'เช็คอินสำเร็จ',
//     //       desc: '${dateth} \n ${_timeString} ',
//     //       showCloseIcon: false,
//     //       btnOkText: "หน้าหลัก",
//     //       btnCancelText: "ลองอีกครั้ง",
//     //       btnOkColor: Colors.green,
//     //       btnCancelColor: Colors.amber,
//     //       btnOkOnPress: () {
//     //         Navigator.pop(context);
//     //       },
//     //     ).show();
//     //   }else{
//     //     context.loaderOverlay.hide();
//     //     print(data["status"]);
//     //     AwesomeDialog(
//     //       context: context,
//     //       // dismissOnTouchOutside: false,
//     //       dialogType: DialogType.WARNING,
//     //       // dialogBackgroundColor: Colors.orange,
//     //       borderSide: BorderSide(color: Colors.amber, width: 2),
//     //       width: 500,
//     //       buttonsBorderRadius: BorderRadius.all(Radius.circular(10)),
//     //       headerAnimationLoop: false,
//     //       animType: AnimType.SCALE,
//     //       // autoHide: Duration(seconds: 2),
//     //       // dialogBackgroundColor: Colors.deepPurpleAccent,
//     //       title: 'ยืนยันตัวตนไม่สำเร็จ',
//     //       desc: 'กรุณาลองใหม่อีกครั้ง',
//     //       showCloseIcon: false,
//     //       btnOkText: "ตกลง",
//     //       btnOkColor: Colors.amber,
//     //       btnOkOnPress: () {
//     //         Navigator.pushReplacement(
//     //             context,
//     //             MaterialPageRoute(
//     //                 builder: (BuildContext context) => super.widget));
//     //       },
//     //     ).show();
//     //   }
//     //   // FormData formData = FormData.fromMap({
//     //   //   'image': await MultipartFile.fromFile(
//     //   //       file!.path,
//     //   //       filename: nameIMG,
//     //   //       contentType: MediaType('image','jpg'),
//     //   //   )
//     //   // });
//     //   // var response = await Dio().post(url, data: formData);
//     //   // await Dio().post(url,data: formData).then((value) {
//     //   //   // print(value);
//     //   //   var data = jsonDecode(value.toString());
//     //   //   if(data["status"] == "success"){
//     //   //     context.loaderOverlay.hide();
//     //   //     print(data["status"]);
//     //
//     //   //     // print("คุณอยู่ในพื้นที่");
//     //   //   }else{
//     //   //     context.loaderOverlay.hide();
//     //   //     print(data["status"]);
//     //
//     //   //   }
//     //   //   // print(data["status"]);
//     //   // });
//     //
//     //
//     // }else{
//     //   MyDialog().alerchecklocation(context);
//     //
//     //   // print("คุณอยู่นอกพื้นที่");
//     // }
//     return distanceInMeters;
//   }
//
//   String token = "";
//   Future<Null> getToken() async{
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     token = preferences.getString("token")!;
//     getdata();
//     // print(token);
//   }
//   EmployeeModel? employeeModel;
//   Future<Null> getdata() async{
//     String url = "http://103.82.248.220/node/api/mobile/user/profile";
//     final response = await get(
//         Uri.parse(url),
//         headers: {"Authorization": "Bearer $token"}
//     );
//     var data = jsonDecode(response.body.toString());
//     if(data["status"] == "success"){
//       setState(() {
//         // print(data["data"]);
//         employeeModel = EmployeeModel.fromJson(data["data"]);
//         print(employeeModel!.id);
//       });
//     }
//   }
//
//
//   Future getImage() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//
//     setState(() {
//       _image = File(pickedFile!.path);
//       _imageWidget = Image.file(_image!);
//
//       _predict();
//     });
//   }
//
//   void _predict() async {
//     img.Image imageInput = img.decodeImage(_image!.readAsBytesSync())!;
//     var pred = _classifier!.predict(imageInput);
//
//     setState(() {
//       this.category = pred;
//     });
//
//     if(category!.label == employeeModel!.id){
//       print(category!.label);
//       context.loaderOverlay.hide();
//       AwesomeDialog(
//         context: context,
//         dismissOnTouchOutside: false,
//         dialogType: DialogType.SUCCES,
//         // dialogBackgroundColor: Colors.orange,
//         borderSide: const BorderSide(color: Colors.green, width: 2),
//         width: 500,
//         buttonsBorderRadius: BorderRadius.all(Radius.circular(10)),
//         headerAnimationLoop: false,
//         animType: AnimType.SCALE,
//         autoHide: Duration(seconds: 4),
//         // dialogBackgroundColor: Colors.deepPurpleAccent,
//         title: 'ยืนยันตัวตนสำเร็จ',
//         desc: 'กรุณาเช็คอิน',
//         showCloseIcon: false,
//         btnOkText: "ตกลง",
//         btnCancelText: "ลองอีกครั้ง",
//         btnOkColor: Colors.green,
//         btnCancelColor: Colors.amber,
//       ).show();
//     }else{
//       print(category!.label);
//       context.loaderOverlay.hide();
//       AwesomeDialog(
//         context: context,
//         dismissOnTouchOutside: true,
//         dialogType: DialogType.WARNING,
//         // dialogBackgroundColor: Colors.orange,
//         borderSide: BorderSide(color: Colors.amber, width: 2),
//         width: 500,
//         buttonsBorderRadius: BorderRadius.all(Radius.circular(10)),
//         headerAnimationLoop: false,
//         animType: AnimType.SCALE,
//         // autoHide: Duration(seconds: 2),
//         // dialogBackgroundColor: Colors.deepPurpleAccent,
//         title: 'ยืนยันตัวตนไม่สำเร็จ',
//         desc: 'กรุณาลองใหม่อีกครั้ง',
//         showCloseIcon: false,
//         btnOkText: "ตกลง",
//         btnOkColor: Colors.amber,
//         btnOkOnPress: () {
//           Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                   builder: (BuildContext context) => super.widget));
//         },
//       ).show();
//     }
//
//   }
//
//
//   @override
//   void initState() {
//     _classifier = ClassifierFloat();
//     Future.delayed(const Duration(seconds: 2), () {
//       setState(() {
//         loading = true;
//         // radius = 100;
//       });
//     });
//     checkPermission();
//     getToken();
//     _timeString = _formatTime(DateTime.now());
//     // Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
//     _timer = Timer.periodic(const Duration(seconds: 1),
//             (Timer timer) {
//               if(timer.isActive){
//                 // _getTime();
//                 // findLatLng();
//               }
//             });
//
//     var now = DateTime.now();
//     final _StartInH = 14;
//     final _StartInM = 00;
//     final _EndOutH = 17;
//     final _EndOutM = 00;
//     startTimeCheckIn = DateTime(now.year, now.month, now.day, _StartInH, _StartInM);
//     print("เวลาตอนนี้: $now");
//     endTimeCheckOut = DateTime(now.year, now.month, now.day, _EndOutH, _EndOutM);
//     print("เวลาออกงาน: $endTimeCheckOut");
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
//
//   showMap() {
//     LatLng latLng = const LatLng(8.165981822672897, 99.65492855358653);
//     CameraPosition cameraPosition = CameraPosition(
//       target: latLng,
//       zoom: 16.0,
//     );
//
//     var df = DateFormat('dd/MM/yyyy').format(DateTime.now());
//     // return SizedBox(
//     //   height: 300.0,
//     //   child: GoogleMap(
//     //     initialCameraPosition: cameraPosition,
//     //     mapType: MapType.normal,
//     //     onMapCreated: (controller) {},
//     //     // markers: myMarker(),
//     //   ),
//     // );
//
//     return Container(
//       padding: const EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 10),
//       child: Column(
//         children: <Widget>[
//           const SizedBox(
//             height: 10,
//           ),
//           Row(
//             children: <Widget>[
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Container(
//                     padding: const EdgeInsets.only(left: 8.0, bottom: 0.0),
//                     // alignment: Alignment.topLeft,
//                     child: const Text(
//                       "ขณะนี้เวลา",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                       textAlign: TextAlign.left,
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.only(left: 8.0, bottom: 0.0),
//                     alignment: Alignment.topLeft,
//                     child: Text(
//                       _timeString,
//                       style: const TextStyle(
//                         color: Colors.grey,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       ),
//                       textAlign: TextAlign.left,
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
//                     alignment: Alignment.topLeft,
//                     child: Text(
//                       df,
//                       style: const TextStyle(
//                         color: Colors.black87,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 18,
//                       ),
//                       textAlign: TextAlign.left,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(width: 80),
//               // LottieBuilder.network('https://assets3.lottiefiles.com/packages/lf20_d1dyords.json',
//               // LottieBuilder.network('https://assets3.lottiefiles.com/packages/lf20_5xqvi8pf.json',
//               LottieBuilder.network(
//                 'https://assets9.lottiefiles.com/packages/lf20_svy4ivvy.json',
//                 width: 120,
//                 // height: 80,
//                 animate: true,
//               ),
//             ],
//           ),
//
//           // const SizedBox(height: 10,),
//           ListTile(
//             // leading: Icon(Icons.location_on_outlined,size: 50,color: Colors.orangeAccent,),
//             leading: LottieBuilder.network(
//               'https://assets10.lottiefiles.com/private_files/lf30_kxkxycqz.json',
//               width: 50,
//               // height: 80,
//               animate: true,
//             ),
//             title: Text('Lat: $lat'),
//             subtitle: Text('Lng: $lng'),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Container(
//             padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
//             alignment: Alignment.topLeft,
//             child: const Text(
//               "ตำแหน่งของฉัน",
//               style: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//               textAlign: TextAlign.left,
//             ),
//           ),
//           lat == null
//               ? const Center(
//                   child: CircularProgressIndicator(
//                   valueColor:
//                       AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
//                   strokeWidth: 5,
//                 ))
//               : Container(
//                   height: 300.0,
//                   child: Card(
//                     clipBehavior: Clip.antiAlias,
//                     color: Colors.transparent,
//                     child: GoogleMap(
//                       initialCameraPosition: cameraPosition,
//                       mapType: MapType.normal,
//                       onMapCreated: (controller) => _mapController = controller,
//                       markers: myMarker(),
//                       circles: circles(),
//                       // circles: {
//                       //    Circle(
//                       //     circleId:  CircleId('1'),
//                       //     center: LatLng(8.1659433, 99.6549117),
//                       //     radius: radius,
//                       //     fillColor: Color.fromRGBO(255, 0, 0, 0.10196078431372549),
//                       //     strokeColor: Colors.transparent,
//                       //   )
//                       // },
//                       myLocationEnabled: false,
//                     ),
//                     elevation: 20,
//                     shape: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5),
//                         borderSide: const BorderSide(color: Colors.green)),
//                   )),
//           const SizedBox(
//             height: 20,
//           ),
//           Container(
//             padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
//             alignment: Alignment.topLeft,
//             child: const Text(
//               "ยืนยันตัวตน",
//               style: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//               textAlign: TextAlign.left,
//             ),
//           ),
//           Column(
//             children: [
//               Container(
//                 child: _image == null
//                     ? const Image(
//                         image: AssetImage(
//                           "images/man2.png",
//                         ),
//                         width: 150,
//                       )
//                     : Container(
//                         constraints: BoxConstraints(
//                             maxHeight: MediaQuery.of(context).size.height / 2),
//                         decoration: BoxDecoration(
//                           border: Border.all(),
//                         ),
//                         child: _imageWidget,
//                     ),
//               ),
//               const SizedBox(height: 20,),
//               Text(
//                 category != null ? category!.label : '',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(height: 100,),
//               // Expanded(
//               //   flex: 0,
//               //   child: Container(
//               //     width: double.infinity,
//               //     child: ElevatedButton(
//               //         onPressed: file != null
//               //             ? null
//               //             : () {
//               //                 selecImg(ImageSource.camera);
//               //               },
//               //         style: ElevatedButton.styleFrom(
//               //           primary: Colors.green,
//               //         ),
//               //         child: const Text(
//               //           'ยืนยันตัวตน',
//               //           style: TextStyle(
//               //             color: Colors.white,
//               //             fontSize: 20,
//               //             fontWeight: FontWeight.bold,
//               //             // fontFamily: "Sarabun",
//               //           ),
//               //         )),
//               //   ),
//               // ),
//             ],
//           ),
//           // lat == null
//           //     ? Container()
//           //     : Expanded(
//           //         flex: 0,
//           //         child: Container(
//           //           width: double.infinity,
//           //           child: ElevatedButton(
//           //               onPressed: () {
//           //                 // checkTimeout();
//           //                 checklocation();
//           //               },
//           //               style: ElevatedButton.styleFrom(
//           //                 primary: Colors.green,
//           //               ),
//           //               child: const Text(
//           //                 'เช็คอิน',
//           //                 style: TextStyle(
//           //                   color: Colors.white,
//           //                   fontSize: 20,
//           //                   fontWeight: FontWeight.bold,
//           //                   // fontFamily: "Sarabun",
//           //                 ),
//           //               )),
//           //         ),
//           //       ),
//           // timenow > endTimeCheckOut
//           //     ? Expanded(
//           //         flex: 0,
//           //         child: Container(
//           //           width: double.infinity,
//           //           child: ElevatedButton(
//           //               onPressed: () {
//           //                 checkTimeout();
//           //               },
//           //               style: ElevatedButton.styleFrom(
//           //                 primary: Colors.red,
//           //               ),
//           //               child: const Text(
//           //                 'เช็คเอ้า',
//           //                 style: TextStyle(
//           //                   color: Colors.white,
//           //                   fontSize: 20,
//           //                   fontWeight: FontWeight.bold,
//           //                   fontFamily: "Sarabun",
//           //                 ),
//           //               )),
//           //         ),
//           //       )
//           //     : Container(
//           //         child: const Center(
//           //           child: Text(
//           //             'เวลาออกงาน 17:00 น.',
//           //             style: TextStyle(
//           //                 fontSize: 18,
//           //                 // fontFamily: 'Sarabun',
//           //                 color: Colors.grey),
//           //           ),
//           //         ),
//           //       )
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       triggerMode: RefreshIndicatorTriggerMode.onEdge,
//       onRefresh: () async {
//         await Future.delayed(Duration(milliseconds: 1500));
//         setState(() {
//           // loading = false;
//           Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                   builder: (BuildContext context) => super.widget));
//         });
//         // Future.delayed(const Duration(seconds: 2),(){
//         //   setState(() {
//         //     loading = true;
//         //   });
//         // });
//       },
//       color: Colors.white,
//       backgroundColor: Colors.deepPurpleAccent.shade100,
//       displacement: 100.0,
//       child: Scaffold(
//         backgroundColor: Colors.grey.shade300,
//         appBar: AppBar(
//           title: Text(widget.title),
//           centerTitle: true,
//           flexibleSpace: Container(
//             decoration: const BoxDecoration(
//               borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
//               // border: Border.all(width: 15, color: Colors.white),
//               gradient: LinearGradient(
//                 colors: [
//                   Color(0xff6200EA),
//                   Colors.white,
//                 ],
//                 begin: FractionalOffset(0.0, 1.0),
//                 end: FractionalOffset(1.5, 1.5),
//               ),
//               // boxShadow: [
//               //   BoxShadow(
//               //     color: Colors.deepPurpleAccent,
//               //     spreadRadius: 5, blurRadius: 30,
//               //     offset: Offset(5, 3),
//               //   ),
//               // ],
//               // image: DecorationImage(image: NetworkImage('https://www.pngitem.com/pimgs/m/391-3918613_personal-service-platform-person-icon-circle-png-transparent.png'))
//             ),
//           ),
//         ),
//         body: loading
//             ? LoaderOverlay(
//               useDefaultLoading: false,
//               overlayWidget:  Center(
//                 child: LoadingAnimationWidget.threeArchedCircle(
//                     color: Colors.deepPurpleAccent, size: 50),
//               ),
//               child: SingleChildScrollView(
//                   child: Column(
//                     children: <Widget>[
//                       showMap(),
//                     ],
//                   ),
//                 ),
//             )
//             : const Center(
//                 child: CircularProgressIndicator(
//                 valueColor:
//                     AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
//                 strokeWidth: 5,
//               )),
//         floatingActionButton: FloatingActionButton.extended(
//           backgroundColor: _image != null  ? Colors.grey :Colors.amber,
//           elevation: 3.0,
//           icon: lat == null ? const Icon(MaterialCommunityIcons.loading, color: Colors.deepPurpleAccent,) : const Icon(Icons.perm_contact_cal),
//           label: lat == null ?
//             const Text(
//               'Loading...',
//               style: TextStyle(
//                 color: Colors.deepPurpleAccent,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 // fontFamily: "Sarabun",
//               ),
//             ): const Text(
//               'ยืนยันตัวตน',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               // fontFamily: "Sarabun",
//             ),
//           ),
//           onPressed: _image != null || lat == null
//               ? null
//               : () {
//                   context.loaderOverlay.show();
//                   getImage();
//               },
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//         bottomNavigationBar: Row(
//           children: [
//             _image == null ?
//             Expanded(
//               child: Material(
//                 color: Colors.grey,
//                 child: SizedBox(
//                   height: kToolbarHeight,
//                   width: double.infinity,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: const[
//                       const SizedBox(height: 10,),
//                       Text(
//                         'กรุณายืนยันตัวตน',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           // fontFamily: "Sarabun",
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ) :
//             Expanded(
//               child: Material(
//                 color: const Color(0xff27a32a),
//                 child: InkWell(
//                   onTap: onbtn
//                     ?(){
//                       setState(() {
//                         onbtn = false;
//                         Future.delayed(const Duration(seconds: 1), () {
//                           context.loaderOverlay.show();
//                           checklocation();
//                         });
//                       });
//                     }
//                     : null,
//                   child:  SizedBox(
//                     height: kToolbarHeight,
//                     width: double.infinity,
//                     child: Row(
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: const[
//                        Icon(Icons.where_to_vote,color: Colors.white,),
//                        const SizedBox(width: 3),
//                        Text(
//                          'เช็คอิน',
//                          style: TextStyle(
//                            color: Colors.white,
//                            fontSize: 18,
//                            fontWeight: FontWeight.bold,
//                            // fontFamily: "Sarabun",
//                          ),
//                        ),
//                        const SizedBox(width: 30),
//                      ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             timenow > endTimeCheckOut ?
//             Expanded(
//               child: Material(
//                 color: const Color(0x9aff0000),
//                 child: InkWell(
//                   onTap: () {
//
//                   },
//                   child: SizedBox(
//                     height: kToolbarHeight,
//                     width: double.infinity,
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: const[
//                         const SizedBox(width: 30),
//                         Text(
//                           'เช็คเอ้า',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             // fontFamily: "Sarabun",
//                           ),
//                         ),
//                         const SizedBox(width: 3),
//                         Icon(Icons.logout_outlined,color: Colors.white,),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             )
//             : Expanded(
//               child: Material(
//                 color: Colors.grey,
//                 child: SizedBox(
//                   height: kToolbarHeight,
//                   width: double.infinity,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: const[
//                       const SizedBox(height: 10,),
//                       Text(
//                         'เวลาออกงาน 17:00 น.',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           // fontFamily: "Sarabun",
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
