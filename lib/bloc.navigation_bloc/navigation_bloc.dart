// import 'package:bloc/bloc.dart';
import 'package:index/pages/news.dart';
import 'package:index/pages/setting.dart';
import 'package:index/pages/submitdoc.dart';
import 'package:index/pages/time.dart';
import '../pages/myaccountspage.dart';
import '../pages/myorderspage.dart';

import '../pages/footerpage.dart';

enum NavigationEvents {
  HomePageClickedEvent,
  MyAccountClickedEvent,
  MyOrdersClickedEvent,
  MyTimeClickedEvent,
  submitdocClickedEvent,
  newsClickedEvent,
  settingClickedEvent,
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc {
  // class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {


  @override
  NavigationStates get initialState =>  FooterPage();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickedEvent:
        yield FooterPage();
        break;
      // case NavigationEvents.MyAccountClickedEvent:
      //   yield const MyAccountsPage();
      //   break;
      case NavigationEvents.MyOrdersClickedEvent:
        yield MyOrdersPage();
        break;
      case NavigationEvents.MyTimeClickedEvent:
        yield  MyTimePage();
        break;
      case NavigationEvents.submitdocClickedEvent:
        yield const MydocPage();
        break;
      case NavigationEvents.newsClickedEvent:
        yield const MyNewsPage();
        break;
      case NavigationEvents.settingClickedEvent:
        yield const MySettingPage();
        break;
    }
  }
}

class Bloc {
}

