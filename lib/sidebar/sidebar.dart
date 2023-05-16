// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:index/bloc.navigation_bloc/navigation_bloc.dart';
// import 'package:index/main.dart';
// import 'package:index/sidebar/menu_item.dart';
// import 'package:rxdart/rxdart.dart';
//
// class SideBar extends StatefulWidget {
//   @override
//   _SideBarState createState() => _SideBarState();
// }
//
// class _SideBarState extends State<SideBar> with SingleTickerProviderStateMixin<SideBar> {
//   late AnimationController _animationController;
//   late StreamController<bool> isSidebarOpenedStreamController;
//   late Stream<bool> isSidebarOpenedStream;
//   late StreamSink<bool> isSidebarOpenedSink;
//   final _animationDuration = const Duration(milliseconds: 500);
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(vsync: this, duration: _animationDuration);
//     isSidebarOpenedStreamController = PublishSubject<bool>();
//     isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
//     isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     isSidebarOpenedStreamController.close();
//     isSidebarOpenedSink.close();
//     super.dispose();
//   }
//
//   void onIconPressed() {
//     final animationStatus = _animationController.status;
//     final isAnimationCompleted = animationStatus == AnimationStatus.completed;
//
//     if (isAnimationCompleted) {
//       isSidebarOpenedSink.add(false);
//       _animationController.reverse();
//     } else {
//       isSidebarOpenedSink.add(true);
//       _animationController.forward();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return StreamBuilder<bool>(
//       initialData: false,
//       stream: isSidebarOpenedStream,
//       builder: (context, AsyncSnapshot isSideBarOpenedAsync) {
//         return AnimatedPositioned(
//           duration: _animationDuration,
//           top: 0,
//           bottom: 0,
//           left: isSideBarOpenedAsync.data ? 0 : -screenWidth,
//           right: isSideBarOpenedAsync.data ? 0 : screenWidth - 35,
//           child: Row(
//             children: <Widget>[
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                       color: const Color(0xffffffff),
//                       // gradient: const LinearGradient(colors: [
//                       //   Color(0xffb388ff),
//                       //   Colors.white,
//                       // ],
//                       //   begin:  FractionalOffset(0.0, 1.0),
//                       //   end:  FractionalOffset(0.0, 0.0),
//                       // ),
//                       borderRadius: BorderRadius.circular(0)),
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   // color:  Colors.deepPurpleAccent,
//                   child: Column(
//                     children: <Widget>[
//                       const SizedBox(
//                         height: 100,
//                       ),
//                       const ListTile(
//                         title: Text(
//                           "ธีรภัทร์",
//                           style: TextStyle(color: Color(0xFF6200EA), fontSize: 30, fontWeight: FontWeight.w800),
//                         ),
//                         subtitle: Text(
//                           "IT Support",
//                           style: TextStyle(
//                             color: Color(0xFFB388FF),
//                             fontSize: 18,
//                           ),
//                         ),
//                         leading: CircleAvatar(
//                           child: Icon(
//                             Icons.perm_identity,
//                             color: Colors.white,
//                           ),
//                           radius: 40,
//                         ),
//                       ),
//                       Divider(
//                         height: 30,
//                         thickness: 1.5,
//                         color: Colors.grey.withOpacity(1.0),
//                         indent: 15,
//                         endIndent: 20,
//                       ),
//                       ListTile(
//                         textColor: Colors.deepPurpleAccent,
//                         leading: const Icon(Icons.perm_identity_outlined, color: Color(0xFF6200EA),size: 30,),
//                         title: const Text("ข้อมูลพนักงาน",style: TextStyle(fontSize: 22,fontFamily: "Sarabun",fontWeight: FontWeight.bold),),
//                         onTap: () {
//                           onIconPressed();
//                           BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.HomePageClickedEvent);
//                         },
//                       ),
//                       ListTile(
//                         textColor: Colors.deepPurpleAccent,
//                         leading: const Icon(Icons.more_time, color: Color(0xFF6200EA),size: 30,),
//                         title: const Text("เวลาทำงาน",style: TextStyle(fontSize: 22,fontFamily: "Sarabun",fontWeight: FontWeight.bold),),
//                         onTap: () {
//                           onIconPressed();
//                           BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.MyTimeClickedEvent);
//                         },
//                       ),
//                       ListTile(
//                         textColor: Colors.deepPurpleAccent,
//                         leading: const Icon(Icons.document_scanner, color: Color(0xFF6200EA),size: 30,),
//                         title: const Text("เอกสาร",style: TextStyle(fontSize: 22,fontFamily: "Sarabun",fontWeight: FontWeight.bold),),
//                         onTap: () {
//                           onIconPressed();
//                           BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.submitdocClickedEvent);
//                         },
//                       ),
//                       ListTile(
//                         textColor: Colors.deepPurpleAccent,
//                         leading: const Icon(Icons.newspaper, color: Color(0xFF6200EA),size: 30,),
//                         title: const Text("ข่าวสาร",style: TextStyle(fontSize: 22,fontFamily: "Sarabun",fontWeight: FontWeight.bold),),
//                         onTap: () {
//                           onIconPressed();
//                           BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.newsClickedEvent);
//                         },
//                       ),
//                       // MenuItem(
//                       //   icon: Icons.newspaper,
//                       //   title: "ประกาศข่าวสาร",
//                       //   onTap: () {
//                       //     onIconPressed();
//                       //     BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.newsClickedEvent);
//                       //   },
//                       // ),
//                       Divider(
//                         height: 50,
//                         thickness: 1.5,
//                         color: Colors.grey.withOpacity(1.0),
//                         indent: 15,
//                         endIndent: 20,
//                       ),
//                       const Divider(
//                         height: 180,
//                         color: Colors.white,
//                       ),
//                       ListTile(
//                         textColor: Colors.deepPurpleAccent,
//                         leading: const Icon(Icons.settings, color: Color(0xFF6200EA),size: 30,),
//                         title: const Text("ตั้งค่า",style: TextStyle(fontSize: 22,fontFamily: "Sarabun",fontWeight: FontWeight.bold),),
//                         onTap: () {
//                           onIconPressed();
//                           BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.settingClickedEvent);
//                         },
//                       ),
//                       ListTile(
//                         textColor: Colors.deepPurpleAccent,
//                         leading: const Icon(Icons.exit_to_app, color: Color(0xFF6200EA),size: 30,),
//                         title: const Text("ออกจากระบบ",style: TextStyle(fontSize: 22,fontFamily: "Sarabun",fontWeight: FontWeight.bold),),
//                         onTap: () {
//                           onIconPressed();
//                           Navigator.push(context, MaterialPageRoute(builder: (context) => const MyApp()));
//                         },
//                       ),
//                       // MenuItem(
//                       //   icon: Icons.settings,
//                       //   title: "ตั้งค่า",
//                       //   onTap: () {
//                       //     onIconPressed();
//                       //     BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.settingClickedEvent);
//                       //   },
//                       // ),
//                       // MenuItem(
//                       //   icon: Icons.exit_to_app,
//                       //   title: "ออกจากระบบ",
//                       //   onTap: () {
//                       //     Navigator.push(context, MaterialPageRoute(builder: (context) => const MyApp()));
//                       //   },
//                       // ),
//                     ],
//                   ),
//                 ),
//               ),
//               Align(
//                 alignment: const Alignment(0, -0.9),
//                 child: GestureDetector(
//                   onTap: () {
//                     onIconPressed();
//                   },
//                   child: ClipPath(
//                     clipper: CustomMenuClipper(),
//                     child: Container(
//                       width: 35,
//                       height: 110,
//                       color: Colors.white,
//                       alignment: Alignment.centerLeft,
//                       child: AnimatedIcon(
//                         progress: _animationController.view,
//                         icon: AnimatedIcons.menu_close,
//                         color: const Color(0xffb388ff),
//                         size: 30,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
// class CustomMenuClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Paint paint = Paint();
//     paint.color = Colors.white;
//
//     final width = size.width;
//     final height = size.height;
//
//     Path path = Path();
//     path.moveTo(0, 0);
//     path.quadraticBezierTo(0, 8, 10, 16);
//     path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
//     path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
//     path.quadraticBezierTo(0, height - 8, 0, height);
//     path.close();
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return true;
//   }
// }
