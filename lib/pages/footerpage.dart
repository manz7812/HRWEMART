import 'dart:async';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:index/pages/bottom_pages/ApproveDoc/approvesDoc.dart';
import 'package:lottie/lottie.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'bottom_pages/notification.dart';
import 'bottom_pages/profile.dart';
import 'bottom_pages/document.dart';
import 'bottom_pages/time_date.dart';

class FooterPage extends StatefulWidget with NavigationStates{
  const FooterPage({Key? key,}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FooterPageState();

}

class _FooterPageState extends State<FooterPage>{

  int _page = 0;
  int _noti = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final textNoti = Text(_noti > 99 ? "99+" : "${_noti}",style: TextStyle(color: Colors.white),);

    final items =<Widget>[
       // Image.asset('images/home.png',width: 30,color: Colors.white,),
      // const Icon(Ionicons.home,size: 30,),
      LottieBuilder.network('https://assets10.lottiefiles.com/packages/lf20_TpC8By.json',
        width: 30,
        // height: 80,
        animate: true,
      ),
      LottieBuilder.network('https://assets3.lottiefiles.com/packages/lf20_hn2uyykn.json',
        width: 40,
        // height: 80,
        animate: true,
        repeat: false,
      ),
      //#7c4dff colors deeppurpleAccedent
      // const Icon(Ionicons.document_text_outline,size: 30,),
      // const Icon(Icons.note_add, size: 30),
      LottieBuilder.network('https://assets10.lottiefiles.com/packages/lf20_lcrwlbdl.json',
        width: 40,
        // height: 80,
        animate: true,
      ),
      // const Icon(Icons.assignment_turned_in_rounded, size: 30),
      LottieBuilder.network('https://assets7.lottiefiles.com/packages/lf20_w33hwx1e.json',
        width: 40,
        // height: 80,
        animate: true,
        // repeat: false,
      ),
      // const Icon(Icons.more_time_outlined, size: 30),
      _noti == 0
      ?LottieBuilder.network('https://assets4.lottiefiles.com/packages/lf20_tszeeqxl.json',
        width: 35,
        // height: 80,
        animate: false,
      )
      :Badge(
        position: BadgePosition.topEnd(
            top: -8, end: -3
        ),
        toAnimate: true,
        // badgeContent: Text(_noti > 99 ? "99+" : "${_noti}",style: TextStyle(color: Colors.white),),
        badgeContent: textNoti,
        child: LottieBuilder.network('https://assets4.lottiefiles.com/packages/lf20_tszeeqxl.json',
          width: 35,
          // height: 80,
          animate: true,
        ),
      ),
      // const Icon(Ionicons.notifications_outline, size: 30),
    ];

    final screens = [
      const ProfilePage2(),
      const SearchPage(),
      const ListApproveDocPage(),
      // const FavouritPage(),
      const TimeDatePage(),
      // const CalendarTimeWorkPage(),
      const NotificationPage(),
    ];



    return Container(
      // color: Colors.blue,
      child: SafeArea(
        top: true,
        child: ClipRect(
          child: Scaffold(
            extendBody: true,
            body: screens[_page ],
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                  iconTheme: const IconThemeData(color: Colors.white)
              ),
              child: CurvedNavigationBar(
                color: Colors.deepPurpleAccent,
                index: _page ,
                items: [
                  LottieBuilder.network('https://assets10.lottiefiles.com/packages/lf20_TpC8By.json',
                    width: 30,
                    // height: 80,
                    animate: true,
                  ),
                  LottieBuilder.network('https://assets3.lottiefiles.com/packages/lf20_hn2uyykn.json',
                    width: 40,
                    // height: 80,
                    animate: true,
                  ),
                  LottieBuilder.network('https://assets10.lottiefiles.com/packages/lf20_lcrwlbdl.json',
                    width: 40,
                    // height: 80,
                    animate: true,
                  ),
                  LottieBuilder.network('https://assets7.lottiefiles.com/packages/lf20_w33hwx1e.json',
                    width: 40,
                    // height: 80,
                    animate: true,
                    // repeat: false,
                  ),
                  _noti == 0
                  ?LottieBuilder.network('https://assets4.lottiefiles.com/packages/lf20_tszeeqxl.json',
                    width: 35,
                    // height: 80,
                    animate: false,
                  )
                  :Badge(
                    position: BadgePosition.topEnd(
                        top: -7, end: -4
                    ),
                    toAnimate: true,
                    animationType: BadgeAnimationType.scale,
                    // badgeContent: Text(_noti > 99 ? "99+" : "${_noti}",style: TextStyle(color: Colors.white),),
                    badgeContent: textNoti,
                    child: LottieBuilder.network('https://assets4.lottiefiles.com/packages/lf20_tszeeqxl.json',
                      width: 35,
                      // height: 80,
                      animate: true,
                    ),
                  ),
                ],
                height: 50,
                buttonBackgroundColor: Colors.deepPurpleAccent,
                backgroundColor: Colors.transparent,
                animationCurve: Curves.easeIn,
                animationDuration: const Duration(milliseconds: 300),
                onTap: (index) {
                  setState(() {
                    _page  = index;
                    if(_page == 4){
                      _noti=0;
                    }
                  });
                },
                letIndexChange: (index) => true,
              ),
            ),
          ),
        )
        // backgroundColor: Colors.deepPurpleAccent,
      ),
    );


  }

}



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



class FooterPage2 extends StatefulWidget with NavigationStates{
  const FooterPage2({Key? key,}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FooterPage2State();
  }
}

class _FooterPage2State extends State<FooterPage2>{

  int _page = 0;
  int _noti = 0;
  late Timer timer;


  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 15), (_) {
      setState(() {
        _noti++;
      });
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   print("WidgetsBinding");
    // });
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   print("SchedulerBinding");
    // });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final textNoti = Text(_noti > 99 ? "99+" : "${_noti}",style: TextStyle(color: Colors.white),);

    final items =<Widget>[
      // Image.asset('images/home.png',width: 30,color: Colors.white,),
      // const Icon(Ionicons.home,size: 30,),
      LottieBuilder.network('https://assets10.lottiefiles.com/packages/lf20_TpC8By.json',
        width: 30,
        // height: 80,
        animate: true,
      ),
      LottieBuilder.network('https://assets3.lottiefiles.com/packages/lf20_hn2uyykn.json',
        width: 40,
        // height: 80,
        animate: true,
        repeat: false,
      ),
      //#7c4dff colors deeppurpleAccedent
      // const Icon(Ionicons.document_text_outline,size: 30,),
      // const Icon(Icons.note_add, size: 30),
      LottieBuilder.network('https://assets10.lottiefiles.com/packages/lf20_lcrwlbdl.json',
        width: 40,
        // height: 80,
        animate: true,
      ),
      // const Icon(Icons.assignment_turned_in_rounded, size: 30),
      LottieBuilder.network('https://assets7.lottiefiles.com/packages/lf20_w33hwx1e.json',
        width: 40,
        // height: 80,
        animate: true,
        // repeat: false,
      ),
      // const Icon(Icons.more_time_outlined, size: 30),
      _noti == 0
      ?LottieBuilder.network('https://assets4.lottiefiles.com/packages/lf20_tszeeqxl.json',
        width: 35,
        // height: 80,
        animate: false,
      )
      :Badge(
        position: BadgePosition.topEnd(
            top: -8, end: -3
        ),
        toAnimate: true,
        // badgeContent: Text(_noti > 99 ? "99+" : "${_noti}",style: TextStyle(color: Colors.white),),
        badgeContent: textNoti,
        child: LottieBuilder.network('https://assets4.lottiefiles.com/packages/lf20_tszeeqxl.json',
          width: 35,
          // height: 80,
          animate: true,
        ),
      ),
      // const Icon(Ionicons.notifications_outline, size: 30),
    ];

    final screens = [
      const ProfilePage2(),
      const SearchPage(),
      // const ListApproveDocPage(),
      // const FavouritPage(),
      const TimeDatePage(),
      // const CalendarTimeWorkPage(),
      const NotificationPage(),
    ];



    return Container(
      // color: Colors.blue,
      child: SafeArea(
          top: true,
          child: ClipRect(
            child: Scaffold(
              extendBody: true,
              body: screens[_page ],
              bottomNavigationBar: Theme(
                data: Theme.of(context).copyWith(
                    iconTheme: const IconThemeData(color: Colors.white)
                ),
                child: CurvedNavigationBar(
                  color: Colors.deepPurpleAccent,
                  index: _page ,
                  items: [
                    LottieBuilder.network('https://assets10.lottiefiles.com/packages/lf20_TpC8By.json',
                      width: 30,
                      // height: 80,
                      animate: true,
                    ),
                    LottieBuilder.network('https://assets3.lottiefiles.com/packages/lf20_hn2uyykn.json',
                      width: 40,
                      // height: 80,
                      animate: true,
                      repeat: false,
                    ),
                    // LottieBuilder.network('https://assets10.lottiefiles.com/packages/lf20_lcrwlbdl.json',
                    //   width: 40,
                    //   // height: 80,
                    //   animate: true,
                    // ),
                    LottieBuilder.network('https://assets7.lottiefiles.com/packages/lf20_w33hwx1e.json',
                      width: 40,
                      // height: 80,
                      animate: true,
                      // repeat: false,
                    ),
                    _noti == 0
                    ?LottieBuilder.network('https://assets4.lottiefiles.com/packages/lf20_tszeeqxl.json',
                      width: 35,
                      // height: 80,
                      animate: false,
                    )
                    :Badge(
                      position: BadgePosition.topEnd(
                          top: -7, end: -4
                      ),
                      toAnimate: true,
                      animationType: BadgeAnimationType.scale,
                      // badgeContent: Text(_noti > 99 ? "99+" : "${_noti}",style: TextStyle(color: Colors.white),),
                      badgeContent: textNoti,
                      child: LottieBuilder.network('https://assets4.lottiefiles.com/packages/lf20_tszeeqxl.json',
                        width: 35,
                        // height: 80,
                        animate: true,
                      ),
                    ),
                  ],
                  height: 50,
                  buttonBackgroundColor: Colors.deepPurpleAccent,
                  backgroundColor: Colors.transparent,
                  animationCurve: Curves.easeIn,
                  animationDuration: const Duration(milliseconds: 300),
                  onTap: (index) {
                    setState(() {
                      _page  = index;
                      if(_page == 3){
                        _noti=0;
                      }
                    });
                  },
                  letIndexChange: (index) => true,
                ),
              ),
            ),
          )
        // backgroundColor: Colors.deepPurpleAccent,
      ),
    );


  }

}

