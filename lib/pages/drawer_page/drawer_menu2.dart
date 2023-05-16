import 'package:es_drawer_controller/es_drawer_controller.dart';
import 'package:flutter/material.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import '../widjet/singout.dart';
import 'DrawAbout/drawer_aboutUS.dart';
import 'DrawEmployee/drawer_employee.dart';
import 'DrawNews/drawer_newsPublic.dart';
import 'DrawPoliciCom/drawer_companyPolicy.dart';
import 'DrawQuoTaLa/drawer_quotaLA.dart';
import 'DrawSalary/drawer_main_salary.dart';
import 'drawer_index.dart';
import 'drawer_main.dart';


enum eDrawerIndexLow {
  diDivider,
  diHome,
  diAboutUS,
  diEmployeedetail,
  diQuota_la,
  diTableManageTime,
  disalary,
  diNews,
  diCompanyPolicy,
  diExit,
}

class MainNavigation2 extends StatefulWidget {

  final List<ESDrawerItem<eDrawerIndexLow>> _cDrawerListLow =
  <ESDrawerItem<eDrawerIndexLow>>[
    const ESDrawerItem(
        type: eDrawerItemType.ditMenu,
        index: eDrawerIndexLow.diHome,
        labelName: 'หน้าหลัก',
        iconData: Icons.home),
    const ESDrawerItem(
        type: eDrawerItemType.ditLink,
        index: eDrawerIndexLow.diAboutUS,
        labelName: 'คำแนะนำ',
        iconData: Icons.help_outline_outlined),
    const ESDrawerItem(
        type: eDrawerItemType.ditLink,
        index: eDrawerIndexLow.diEmployeedetail,
        labelName: 'ข้อมูลพนักงาน',
        iconData: Icons.account_circle_rounded),
    const ESDrawerItem(
      type: eDrawerItemType.ditLink,
      index: eDrawerIndexLow.diQuota_la,
      labelName: 'โควต้าการลา',
      iconData: Icons.pending_actions_outlined,
    ),
    const ESDrawerItem(
      type: eDrawerItemType.ditLink,
      index: eDrawerIndexLow.disalary,
      labelName: 'เงินเดือน',
      iconData: IcoFontIcons.money,
    ),
    const ESDrawerItem(
      type: eDrawerItemType.ditLink,
      index: eDrawerIndexLow.diNews,
      labelName: 'ประกาศข่าวสาร',
      iconData: IcoFontIcons.megaphone,
    ),
    const ESDrawerItem(
      type: eDrawerItemType.ditLink,
      index: eDrawerIndexLow.diCompanyPolicy,
      labelName: 'นโยบายบริษัท',
      iconData: Icons.receipt_long_outlined,
    ),
    const ESDrawerItem(
        type: eDrawerItemType.ditDivider,
        index: eDrawerIndexLow.diDivider), // Add a divider here
    const ESDrawerItem(
      type: eDrawerItemType.ditLink,
      index: eDrawerIndexLow.diExit,
      labelName: 'ออกจากระบบ',
      iconData: Icons.exit_to_app_outlined,
    ),
  ];

  @override
  State<MainNavigation2> createState() => _MainNavigation2State();
}

class _MainNavigation2State extends State<MainNavigation2> {

  Widget screenView = const MainPagesDW();
  eDrawerIndexLow drawerIndexLow = eDrawerIndexLow.diHome;
  DateTime lastBackPressTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ESDrawerController<eDrawerIndexLow>(
      // assetLogo: 'images/2.jpg',
      // title: 'ธีรภัทร เจริญวงค์',
      // titleStyle: const TextStyle(
      //   fontFamily: 'Mitr',
      //   fontSize: 22,
      //   fontWeight: FontWeight.bold,
      //   color: Colors.black,
      //   decoration: TextDecoration.none,
      // ),
      // subTitle: 'IT Support',
      // subTitleStyle: const TextStyle(
      //   fontFamily: 'Mitr',
      //   fontSize: 18,
      //   fontWeight: FontWeight.bold,
      //   color: Colors.black,
      //   decoration: TextDecoration.none,
      // ),
      screenView: screenView,
      screenIndex: drawerIndexLow,
      drawerList: widget._cDrawerListLow,
      drawerWidth: MediaQuery.of(context).size.width * 0.75,
      // When user click on the menu, onDrawerCall is triggered
      onDrawerCall: (ESDrawerItem drawerItem) => _changeIndexLow(drawerItem),
    );
  }

  void _changeIndexLow(ESDrawerItem drawerItem) {
    // If user click on the same menu which is not marked as link/share then no need to create the same class again
    if (drawerItem.type == eDrawerItemType.ditMenu &&
        (drawerIndexLow == drawerItem.index || !mounted)) return;

    // Update new drawer index
    drawerIndexLow = drawerItem.index;
    switch (drawerIndexLow) {
      case eDrawerIndexLow.diHome:
        setState(() => screenView = const MainPagesDW());
        break;
      case eDrawerIndexLow.diAboutUS:
        setState(() => screenView = const AboutUsPage(title: 'คำแนะนำ',));
        break;
      case eDrawerIndexLow.diEmployeedetail:
        setState(() => screenView = const EmployeePage(title: 'ข้อมูลพนักงาน',));
        break;
      case eDrawerIndexLow.diQuota_la:
        setState(() => screenView = const QuotaLaPage(title: "โควต้าการลา"));
        break;
      case eDrawerIndexLow.disalary:
        setState(() => screenView = const ManinSalaryPage());
        break;
      case eDrawerIndexLow.diNews:
        setState(() => screenView = const NewsPublicPage(title: "ข่าวสาร"));
        break;
      case eDrawerIndexLow.diCompanyPolicy:
        setState(() => screenView = const CompanyPolicyPage(title: "นโยบายบริษัท"));
        break;
      case eDrawerIndexLow.diExit:
        signOut(context);
        break;
      default:
        break;
    }
  }
}

